import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/invitation_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/auth/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/auth/register/bloc/register_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPreference.init();
  });

  group('PendingInvitationManager Tests', () {
    test('save and read pending invitation data correctly', () async {
      expect(PendingInvitationManager.hasPending(), isFalse);
      expect(PendingInvitationManager.getId(), isEmpty);
      expect(PendingInvitationManager.getEmail(), isEmpty);

      await PendingInvitationManager.save(
        invitationId: 'inv_abc_789',
        invitationEmail: 'partner@example.com',
      );

      expect(PendingInvitationManager.hasPending(), isTrue);
      expect(PendingInvitationManager.getId(), 'inv_abc_789');
      expect(PendingInvitationManager.getEmail(), 'partner@example.com');
    });

    test('clear properly wipes invitation id and email', () async {
      await PendingInvitationManager.save(
        invitationId: 'inv_to_clear',
        invitationEmail: 'clear@example.com',
      );
      expect(PendingInvitationManager.hasPending(), isTrue);

      await PendingInvitationManager.clear();
      expect(PendingInvitationManager.hasPending(), isFalse);
      expect(PendingInvitationManager.getId(), isEmpty);
      expect(PendingInvitationManager.getEmail(), isEmpty);
    });

    test(
      'matchesEmail is true for the same email ignoring case and spaces',
      () async {
        await PendingInvitationManager.save(
          invitationId: 'inv_match',
          invitationEmail: 'Partner@Example.com',
        );

        expect(
          PendingInvitationManager.matchesEmail('  partner@example.com  '),
          isTrue,
        );
      },
    );

    test('matchesEmail is false for a different email', () async {
      await PendingInvitationManager.save(
        invitationId: 'inv_diff',
        invitationEmail: 'partner@example.com',
      );

      expect(
        PendingInvitationManager.matchesEmail(
          'abc123@privaterelay.appleid.com',
        ),
        isFalse,
      );
    });

    test('masked invite email is not used to prefill signup', () async {
      await PendingInvitationManager.save(
        invitationId: 'inv_masked',
        invitationEmail: 'u***@yopmail.com',
      );

      expect(PendingInvitationManager.hasPending(), isTrue);
      expect(PendingInvitationManager.getId(), 'inv_masked');
      expect(PendingInvitationManager.getEmail(), isEmpty);
      expect(
        PendingInvitationManager.matchesEmail('usertest11@yopmail.com'),
        isFalse,
      );
    });

    test('matchesEmail is false when logged email is empty', () async {
      await PendingInvitationManager.save(
        invitationId: 'inv_empty',
        invitationEmail: 'partner@example.com',
      );

      expect(PendingInvitationManager.matchesEmail(''), isFalse);
      expect(PendingInvitationManager.matchesEmail('   '), isFalse);
    });
  });

  group('Unified Auth Cubits Pre-Fill Tests', () {
    test(
      'RegisterCubit sets emailAddress and clears error when pre-filled',
      () {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        expect(cubit.state.emailAddress, isEmpty);

        cubit.changeProps(
          emailAddress: 'invited_coparent@test.com',
          emailAddressError: '',
        );

        expect(cubit.state.emailAddress, 'invited_coparent@test.com');
        expect(cubit.state.emailAddressError, isEmpty);
        cubit.close();
      },
    );

    test('LoginCubit sets emailAddress and clears error when pre-filled', () {
      final LoginCubit cubit = LoginCubit();
      cubit.init();

      expect(cubit.state.emailAddress, isEmpty);

      cubit.changeProps(
        emailAddress: 'invited_coparent@test.com',
        emailAddressError: '',
      );

      expect(cubit.state.emailAddress, 'invited_coparent@test.com');
      expect(cubit.state.emailAddressError, isEmpty);
      cubit.close();
    });
  });

  group('CoParent Invitation Validation Edge Cases', () {
    test('validates case-insensitive and trimmed email match', () {
      final String? error =
          CoParentInvitationHelpers.validateInvitationForAccept(
            invitedEmail: '  Coparent@Test.COM ',
            loggedInEmail: 'coparent@test.com  ',
            invitationStatus: CoParentInvitationHelpers.statusRequested,
          );
      expect(error, isNull);
    });

    test('rejects mismatched email with thisInvitationIsNotForYou', () {
      final String? error =
          CoParentInvitationHelpers.validateInvitationForAccept(
            invitedEmail: 'coparent1@test.com',
            loggedInEmail: 'other_parent@test.com',
            invitationStatus: CoParentInvitationHelpers.statusRequested,
          );
      expect(error, 'thisInvitationIsNotForYou');
    });

    test('rejects already accepted invitation with invitationAlreadyUsed', () {
      final String? error =
          CoParentInvitationHelpers.validateInvitationForAccept(
            invitedEmail: 'coparent@test.com',
            loggedInEmail: 'coparent@test.com',
            invitationStatus: CoParentInvitationHelpers.statusAccepted,
          );
      expect(error, 'invitationAlreadyUsed');
    });

    test('rejects invitation with empty invited email', () {
      final String? error =
          CoParentInvitationHelpers.validateInvitationForAccept(
            invitedEmail: '   ',
            loggedInEmail: 'coparent@test.com',
            invitationStatus: CoParentInvitationHelpers.statusRequested,
          );
      expect(error, 'deepLinkInvitationInvalidEmail');
    });

    test('handles multiple comma-separated children correctly', () {
      final List<String> childIds =
          CoParentInvitationHelpers.parseChildIdsFromCsv(
            'child_101,  child_202 , child_303',
          );
      expect(childIds, <String>['child_101', 'child_202', 'child_303']);

      final String csv = CoParentInvitationHelpers.buildChildrenCsv(childIds);
      expect(csv, 'child_101,child_202,child_303');
    });
  });

  group('CoParent User State & Invitation Model Lifecycle', () {
    test('InvitationModel serializes and deserializes correctly', () {
      final InvitationModel model = InvitationModel(
        fromParent: 'inviter@test.com',
        toParent: 'coparent@test.com',
        children: 'child_1,child_2',
        status: CoParentInvitationHelpers.statusRequested,
      );

      final Map<String, dynamic> json = model.toJson();
      expect(json['from_parent'], 'inviter@test.com');
      expect(json['to_parent'], 'coparent@test.com');
      expect(json['children'], 'child_1,child_2');
      expect(json['status'], CoParentInvitationHelpers.statusRequested);

      final InvitationModel reconstructed = InvitationModel.fromJson(json);
      expect(reconstructed.fromParent, 'inviter@test.com');
      expect(reconstructed.toParent, 'coparent@test.com');
      expect(reconstructed.status, CoParentInvitationHelpers.statusRequested);
    });

    test(
      'CoParent user marked as onboarded upon accepting invitation',
      () async {
        final UserModel initialUser = UserModel(
          uid: 'coparent_uid_1',
          email: 'coparent@test.com',
          isOnboardingCompleted: false,
        );
        await preferences.saveUserModel(initialUser);

        UserModel? loaded = preferences.getUserModel();
        expect(loaded?.isOnboardingCompleted, isFalse);

        // Simulating post-accept user state update
        final UserModel updatedUser = initialUser.copyWith(
          isOnboardingCompleted: true,
        );
        await preferences.saveUserModel(updatedUser);

        loaded = preferences.getUserModel();
        expect(loaded?.isOnboardingCompleted, isTrue);
        expect(loaded?.email, 'coparent@test.com');
      },
    );
  });
}
