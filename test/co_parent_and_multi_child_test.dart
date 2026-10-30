import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_cubit.dart';
import 'package:loving_brain/ui/family_menu/family_menu_screen.dart';
import 'package:loving_brain/ui/permissions/bloc/permissions_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/sheets/child_switcher_sheet.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
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

    testWidgets(
      'showPrimaryParentInfoDialog renders themed shield icon, fraunces title, and Got it button',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(389, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(389, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? _) {
              return MaterialApp(
                home: Scaffold(
                  body: Builder(
                    builder: (BuildContext ctx) {
                      return ElevatedButton(
                        onPressed: () {
                          showPrimaryParentInfoDialog(ctx, 'H007');
                        },
                        child: const Text('Open Dialog'),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        // Tap open button
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        // Verify themed dialog contents
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.text('Primary Parent'), findsOneWidget);
        expect(
          find.text(
            'H007 is the primary parent and creator of this profile. Their permissions cannot be modified.',
          ),
          findsOneWidget,
        );
        expect(find.text('Got it'), findsOneWidget);

        // Tap 'Got it' to dismiss dialog
        await tester.tap(find.text('Got it'));
        await tester.pumpAndSettle();

        // Verify dialog is closed
        expect(find.byType(Dialog), findsNothing);
      },
    );

    testWidgets(
      'ChildSwitcherSheet renders Edit active child profile as AppButton with edit icon',
      (WidgetTester tester) async {
        final ChildModel child = ChildModel(
          childName: 'Johnny',
          childAge: '2 years',
          parentReferenceIds: <String>['test_uid'],
        );
        await preferences.saveChildModel(child);

        tester.view.physicalSize = const Size(389, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(389, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? _) {
              return const MaterialApp(
                home: Scaffold(body: ChildSwitcherSheet()),
              );
            },
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Switch child profile'), findsOneWidget);
        expect(find.text('Edit active child profile'), findsOneWidget);
        expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
        expect(
          find.widgetWithText(AppButton, 'Edit active child profile'),
          findsOneWidget,
        );
        expect(find.byType(TextButton), findsNothing);

        final Size editBtnSize = tester.getSize(
          find.widgetWithText(AppButton, 'Edit active child profile'),
        );
        final Size addBtnSize = tester.getSize(
          find.widgetWithText(AppButton, '+ Add another child'),
        );
        expect(editBtnSize.width, greaterThan(340));
        expect(addBtnSize.width, greaterThan(340));
      },
    );
  });
}
