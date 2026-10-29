import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_cubit.dart';
import 'package:loving_brain/ui/permissions/bloc/permissions_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Multi-Child and Co-Parent Ownership Hierarchy Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      await SharedPreference.init();
    });

    test(
      'TodayCubit.switchActiveChild successfully switches active child and updates state',
      () async {
        final ChildModel child1 = ChildModel(
          childName: 'Johnny',
          childAge: '2 years',
          parentReferenceIds: <String>['user_a'],
        );
        final ChildModel child2 = ChildModel(
          childName: 'Emma',
          childAge: '4 years',
          parentReferenceIds: <String>['user_b'],
        );

        await preferences.saveChildModel(child1);
        expect(preferences.getChildModel()?.childName, 'Johnny');

        final TodayCubit todayCubit = TodayCubit();
        await todayCubit.switchActiveChild(child2);

        expect(preferences.getChildModel()?.childName, 'Emma');
        expect(todayCubit.state.childName, 'Emma');
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await todayCubit.close();
      },
    );

    test(
      'PermissionsCubit blocks modifying or revoking access for primary parent',
      () async {
        // Child belongs to user_b (creator / primary parent)
        final ChildModel child = ChildModel(
          childName: 'Emma',
          parentReferenceIds: <String>['user_b', 'user_a'],
        );
        await preferences.saveChildModel(child);

        // User A attempts to edit permissions or revoke User B (the owner)
        final PermissionsCubit cubit = PermissionsCubit();
        cubit.init(
          caregiverName: 'User B',
          role: 'Mother',
          caregiverId: 'user_b',
          caregiverEmail: 'user_b@lovingbrain.test',
        );

        // Revocation attempt must be blocked
        final bool revoked = await cubit.revokeAccess();
        expect(revoked, isFalse);

        // Modification attempt must be blocked
        final bool saved = await cubit.savePermissions();
        expect(saved, isFalse);

        cubit.close();
      },
    );

    test(
      'FamilyMenuCubit correctly identifies primary parent vs secondary caregiver',
      () async {
        // Logged-in user is user_a (co-parent)
        final UserModel userA = UserModel(
          uid: 'user_a',
          partnerUserId: 'user_b',
          parentName: 'Parent A',
          email: 'usera@lovingbrain.test',
        );
        await preferences.saveUserModel(userA);

        // Child was created by user_b (primary parent)
        final ChildModel child = ChildModel(
          childName: 'Emma',
          parentReferenceIds: <String>['user_b', 'user_a'],
        );
        await preferences.saveChildModel(child);

        final FamilyMenuCubit cubit = FamilyMenuCubit();
        cubit.init();

        // Give async loader a microtask turn
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // user_a is NOT the owner
        expect(cubit.state.isCurrentUserOwner, isFalse);
        cubit.close();
      },
    );
  });
}
