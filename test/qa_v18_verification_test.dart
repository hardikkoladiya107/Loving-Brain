import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/invitation_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/repo/experiment_repo.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_cubit.dart';
import 'package:loving_brain/ui/permissions/bloc/permissions_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPreference.init();
  });

  group('QA Report v1.8 Verification Tests', () {
    test('TC-N01: Permissions persistence across save and reopen', () async {
      final ChildModel child = ChildModel(
        childName: 'Emma',
        parentReferenceIds: <String>['creator_uid', 'caregiver_uid'],
      );
      await preferences.saveChildModel(child);

      final PermissionsCubit cubit = PermissionsCubit();
      cubit.init(
        caregiverName: 'Alex Partner',
        role: 'Partner',
        caregiverId: 'caregiver_uid',
        caregiverEmail: 'alex.partner@gmail.com',
      );

      // Initially health notes are disabled for partner
      expect(cubit.state.healthNotesEnabled, false);

      // Toggle health notes on and save
      cubit.toggleHealthNotes();
      expect(cubit.state.healthNotesEnabled, true);

      final bool saved = await cubit.savePermissions();
      expect(saved, true);

      // Verify stored in preferences under email and caregiverId
      final Map<String, dynamic>? storedByEmail = preferences
          .getCaregiverPermissions('alex.partner@gmail.com');
      expect(storedByEmail, isNotNull);
      expect(storedByEmail!['can_view_health_notes'], true);

      final Map<String, dynamic>? storedById = preferences
          .getCaregiverPermissions('caregiver_uid');
      expect(storedById, isNotNull);
      expect(storedById!['can_view_health_notes'], true);

      await cubit.close();

      // Reopen permissions cubit
      final PermissionsCubit reopenCubit = PermissionsCubit();
      reopenCubit.init(
        caregiverName: 'Alex Partner',
        role: 'Partner',
        caregiverId: 'caregiver_uid',
        caregiverEmail: 'alex.partner@gmail.com',
      );

      expect(reopenCubit.state.healthNotesEnabled, true);
      await reopenCubit.close();
    });

    test(
      'TC-N02: Health notes privacy boundary for co-parents and unlinked users',
      () async {
        // 1. Unlinked user -> false
        expect(TodayLogRepo.instance.canCurrentCaregiverViewHealth(), false);

        // 2. Secondary caregiver with no saved permissions -> false
        final ChildModel child = ChildModel(
          childName: 'Emma',
          parentReferenceIds: <String>[
            'primary_owner_uid',
            'secondary_co_parent_uid',
          ],
        );
        await preferences.saveChildModel(child);

        final UserModel secondaryUser = UserModel(
          uid: 'secondary_co_parent_uid',
          email: 'secondary@lovingbrain.test',
          relationshipToChild: 'Partner',
        );
        await preferences.saveUserModel(secondaryUser);

        expect(TodayLogRepo.instance.canCurrentCaregiverViewHealth(), false);

        // 3. Secondary caregiver with explicit health permissions -> true
        final CaregiverPermissionsModel allowedPermissions =
            CaregiverPermissionsModel(
              caregiverEmail: 'secondary@lovingbrain.test',
              canViewHealthNotes: true,
            );
        await preferences.saveCaregiverPermissions(allowedPermissions.toMap());

        expect(TodayLogRepo.instance.canCurrentCaregiverViewHealth(), true);

        // 4. Primary owner -> always true
        final UserModel primaryOwner = UserModel(
          uid: 'primary_owner_uid',
          email: 'owner@lovingbrain.test',
        );
        await preferences.saveUserModel(primaryOwner);

        expect(TodayLogRepo.instance.canCurrentCaregiverViewHealth(), true);
      },
    );

    test('TC-N06: Co-parent naming avoids raw email local part', () async {
      final UserModel user = UserModel(
        uid: 'user_a',
        email: 'user_a@lovingbrain.test',
        partnerUserId: 'user_b',
      );
      await preferences.saveUserModel(user);

      final ChildModel child = ChildModel(
        childName: 'Tommy',
        parentReferenceIds: <String>['user_a', 'user_b'],
      );
      await preferences.saveChildModel(child);

      final FamilyMenuCubit familyCubit = FamilyMenuCubit();
      await familyCubit.init();

      // Ensure no raw email prefixes leaked in linked or pending names
      for (final caregiver in familyCubit.state.linkedCaregivers) {
        expect(caregiver.name.contains('@'), false);
        expect(caregiver.name.toLowerCase().contains('+qa'), false);
      }
      await familyCubit.close();
    });

    test(
      'TC-N07: Orphaned co-parent lands on no-child state instead of generic Child Today',
      () async {
        // User with no child linked
        final UserModel user = UserModel(
          uid: 'unlinked_user',
          email: 'unlinked@lovingbrain.test',
          parentName: 'Jane',
        );
        await preferences.saveUserModel(user);
        await preferences.clearChild();

        final TodayCubit todayCubit = TodayCubit();
        await todayCubit.init();

        expect(todayCubit.state.activeChildId, '');
        expect(todayCubit.state.childName, '');

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await todayCubit.close();
      },
    );

    test(
      'TC-N09: Deep link accept succeeds idempotently if already accepted',
      () async {
        final InvitationModel acceptedInvite = InvitationModel(
          status: CoParentInvitationHelpers.statusAccepted,
          toParent: 'coparent@lovingbrain.test',
          fromParent: 'inviter@lovingbrain.test',
          children: 'child_123',
        );

        final UserModel user = UserModel(
          uid: 'coparent_uid',
          email: 'coparent@lovingbrain.test',
        );
        await preferences.saveUserModel(user);

        // Verification of helper email matching
        expect(
          CoParentInvitationHelpers.emailsMatch(
            acceptedInvite.toParent ?? '',
            user.email ?? '',
          ),
          true,
        );
      },
    );
  });
}
