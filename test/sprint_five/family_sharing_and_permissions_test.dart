import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/child_essentials/bloc/child_essentials_cubit.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_cubit.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_state.dart';
import 'package:loving_brain/ui/invite_caregiver/bloc/invite_caregiver_cubit.dart';
import 'package:loving_brain/ui/invite_pending/bloc/invite_pending_cubit.dart';
import 'package:loving_brain/ui/permissions/bloc/permissions_cubit.dart';
import 'package:loving_brain/ui/shared_child_summary/bloc/shared_child_summary_cubit.dart';
import 'package:loving_brain/ui/shared_child_summary/bloc/shared_child_summary_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sprint 5: CaregiverPermissionsModel & Privacy Boundary Invariants', () {
    test(
      'Grandparent role defaults to sleep and plans only per V2 specification',
      () {
        final CaregiverPermissionsModel perms =
            CaregiverPermissionsModel.forRole(
              'Grandparent',
              'Susan',
              caregiverEmail: 'susan@example.com',
            );

        expect(perms.caregiverName, 'Susan');
        expect(perms.role, 'Grandparent');
        expect(perms.canViewSleep, isTrue);
        expect(perms.canViewPlans, isTrue);
        expect(perms.canViewBehaviour, isFalse);
        expect(perms.canViewHealthNotes, isFalse);
        expect(perms.canViewMentorshipSummaries, isFalse);
        // STRICT INVARIANT: Parent reflections must never be shared under any circumstances
        expect(perms.parentReflectionsNeverShared, isTrue);
      },
    );

    test('Partner role defaults to sleep, behaviour, and plans', () {
      final CaregiverPermissionsModel perms = CaregiverPermissionsModel.forRole(
        'Partner',
        'Ravi',
        caregiverEmail: 'ravi@example.com',
      );

      expect(perms.caregiverName, 'Ravi');
      expect(perms.role, 'Partner');
      expect(perms.canViewSleep, isTrue);
      expect(perms.canViewBehaviour, isTrue);
      expect(perms.canViewPlans, isTrue);
      expect(perms.canViewHealthNotes, isFalse);
      expect(perms.parentReflectionsNeverShared, isTrue);
    });

    test(
      'Serialization and copyWith maintains non-shared reflections invariant',
      () {
        final CaregiverPermissionsModel original =
            CaregiverPermissionsModel.forRole('Grandparent', 'Grandma');

        final Map<String, dynamic> json = original.toJson();
        expect(json['can_view_sleep'], isTrue);
        expect(json['parent_reflections_never_shared'], isTrue);

        final CaregiverPermissionsModel restored =
            CaregiverPermissionsModel.fromJson(json);
        expect(restored.caregiverName, 'Grandma');
        expect(restored.canViewSleep, isTrue);
        expect(restored.parentReflectionsNeverShared, isTrue);

        final CaregiverPermissionsModel updated = restored.copyWith(
          canViewHealthNotes: true,
        );
        expect(updated.canViewHealthNotes, isTrue);
        expect(updated.parentReflectionsNeverShared, isTrue);
      },
    );
  });

  group('Sprint 5: Family Sharing Cubits Flow', () {
    test('SharedChildSummaryCubit loads recent handover log updates', () async {
      final SharedChildSummaryCubit cubit = SharedChildSummaryCubit();
      await cubit.init();

      expect(cubit.state.partnerName, isNotEmpty);
      expect(cubit.state.childName, isNotEmpty);
      expect(cubit.state.todaysPlanTitle, isNotEmpty);
      // Per V2 QA audit (f2), empty state must be empty rather than showing sample rows
      expect(cubit.state.recentUpdates, isEmpty);

      cubit.changeProps(
        recentUpdates: const <HandoverLogItem>[
          HandoverLogItem(
            authorName: 'Co-Parent',
            isPartner: true,
            actionDescription: 'logged bedtime at 7:35 PM',
            timeAgo: '20 min ago',
          ),
        ],
      );
      expect(cubit.state.recentUpdates, isNotEmpty);

      final HandoverLogItem firstLog = cubit.state.recentUpdates.first;
      expect(firstLog.authorName, 'Co-Parent');
      expect(firstLog.actionDescription, isNotEmpty);

      cubit.close();
    });

    test('FamilyMenuCubit provides linked caregivers and pending invites', () {
      final FamilyMenuCubit cubit = FamilyMenuCubit();
      cubit.init();

      expect(cubit.state.childName, isNotEmpty);
      expect(cubit.state.linkedCaregivers, isA<List<CaregiverItem>>());
      expect(cubit.state.pendingInvites, isA<List<CaregiverItem>>());

      cubit.changeProps(
        linkedCaregivers: const <CaregiverItem>[
          CaregiverItem(
            id: '1',
            name: 'Co-Parent',
            email: 'coparent@example.com',
            role: 'Co-Parent',
            status: 'Linked',
          ),
        ],
        pendingInvites: const <CaregiverItem>[
          CaregiverItem(
            id: '2',
            name: 'Caregiver',
            email: 'caregiver@example.com',
            role: 'Grandparent',
            status: 'Pending',
          ),
        ],
      );
      expect(cubit.state.linkedCaregivers.isNotEmpty, isTrue);
      expect(cubit.state.pendingInvites.isNotEmpty, isTrue);

      cubit.close();
    });

    test(
      'InviteCaregiverCubit validates inputs and manages role selection',
      () async {
        final InviteCaregiverCubit cubit = InviteCaregiverCubit();
        cubit.init();

        expect(cubit.state.selectedRole, isEmpty);

        cubit.selectRole('Nanny');
        expect(cubit.state.selectedRole, 'Nanny');

        // Empty email validation
        cubit.updateEmail('');
        final bool failedResult = await cubit.sendInvite();
        expect(failedResult, isFalse);
        expect(cubit.state.sendStatus, isA<Error>());
        expect(cubit.state.emailError, isNotEmpty);

        // Invalid format email validation
        cubit.updateEmail('invalid-email-address');
        final bool invalidFormatResult = await cubit.sendInvite();
        expect(invalidFormatResult, isFalse);
        expect(cubit.state.sendStatus, isA<Error>());
        expect(cubit.state.emailError, isNotEmpty);

        // Valid email clears local validation; create is server-side (callable).
        cubit.updateEmail('nanny@example.com');
        expect(cubit.state.emailError, isEmpty);
        final bool successResult = await cubit.sendInvite();
        expect(successResult, isFalse);
        expect(cubit.state.sendStatus, isA<Error>());

        cubit.close();
      },
    );

    test('InviteCaregiverCubit prevents self-invitation', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'user': json.encode(
          UserModel(
            email: 'hardikkoladiya107@gmail.com',
          ).toJson(forConvert: true),
        ),
      });
      await SharedPreference.init();

      final InviteCaregiverCubit cubit = InviteCaregiverCubit();
      cubit.init();

      // Exact match check
      expect(cubit.isSelfEmail('hardikkoladiya107@gmail.com'), isTrue);

      // Case-insensitivity and whitespace trim check
      expect(cubit.isSelfEmail('  HardikKoladiya107@GMAIL.com '), isTrue);

      // Different email is not self
      expect(cubit.isSelfEmail('caregiver@example.com'), isFalse);

      // Attempting to send invite to own email address must fail
      cubit.updateEmail('hardikkoladiya107@gmail.com');
      final bool selfInviteResult = await cubit.sendInvite();
      expect(selfInviteResult, isFalse);
      expect(cubit.state.sendStatus, isA<Error>());
      expect(cubit.state.emailError, isNotEmpty);

      // Typing a different email clears the error
      cubit.updateEmail('nanny@example.com');
      expect(cubit.state.emailError, isEmpty);

      cubit.close();
    });

    test(
      'InvitePendingCubit manages expiry and requires invitation id for actions',
      () async {
        final InvitePendingCubit cubit = InvitePendingCubit();
        cubit.init(recipient: 'grandma@example.com', role: 'Grandparent');

        expect(cubit.state.recipientEmail, 'grandma@example.com');
        expect(cubit.state.daysUntilExpiry, 14);
        expect(cubit.state.isCancelled, isFalse);

        await cubit.resendInvite();
        expect(cubit.state.actionStatus, isA<Error<dynamic>>());

        await cubit.cancelInvite();
        expect(cubit.state.isCancelled, isFalse);
        expect(cubit.state.actionStatus, isA<Error<dynamic>>());

        cubit.close();
      },
    );

    test('PermissionsCubit toggles permissions and saves', () async {
      final PermissionsCubit cubit = PermissionsCubit();
      cubit.init(caregiverName: 'Grandma', role: 'Grandparent');

      expect(cubit.state.caregiverName, 'Grandma');
      expect(cubit.state.sleepEnabled, isTrue);
      expect(cubit.state.behaviourEnabled, isFalse); // Grandparent default
      expect(cubit.state.healthNotesEnabled, isFalse);

      cubit.toggleHealthNotes();
      expect(cubit.state.healthNotesEnabled, isTrue);

      cubit.toggleBehaviour();
      expect(cubit.state.behaviourEnabled, isTrue);

      final bool saved = await cubit.savePermissions();
      expect(saved, isTrue);
      expect(cubit.state.saveStatus, isA<Data<dynamic>>());

      // Revoke is server-side; without a child DocumentReference it fails closed.
      final bool revoked = await cubit.revokeAccess();
      expect(revoked, isFalse);

      cubit.close();
    });

    test('ChildEssentialsCubit manages allergies and medications', () {
      final ChildEssentialsCubit cubit = ChildEssentialsCubit();
      cubit.init();

      expect(cubit.state.childName, isNotEmpty);
      expect(cubit.state.allergies, isEmpty);
      expect(cubit.state.medications, isEmpty);

      cubit.addAllergy('Dairy / Lactose');
      expect(cubit.state.allergies, contains('Dairy / Lactose'));

      cubit.addMedication('Vitamin D3 drops');
      expect(cubit.state.medications, contains('Vitamin D3 drops'));

      cubit.removeAllergy(0);
      expect(cubit.state.allergies, isEmpty);

      cubit.removeMedication(0);
      expect(cubit.state.medications, isEmpty);

      cubit.close();
    });
  });
}
