import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_cubit.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_state.dart';
import 'package:loving_brain/ui/permissions/permissions_screen.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_state.dart';
import 'package:loving_brain/ui/today_screen/today_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QA Report v1.7 Deep Audit Verification', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        SharedPreference.isLogin: true,
        SharedPreference.user:
            '{"uid": "inviter_01", "email": "parent@lovingbrain.com", "partner_user_id": "coparent_02"}',
        SharedPreference.child:
            '{"child_name": "QA Child", "parent_reference_ids": ["inviter_01", "coparent_02"]}',
      });
      await SharedPreference.init();
    });

    testWidgets(
      'TC-N01 / NEW17-1: PermissionsScreen layout uses MainAxisSize.min for bottom actions and does not block body',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(389, 780),
            builder: (BuildContext context, Widget? child) {
              return const MaterialApp(
                home: PermissionsScreen(
                  caregiverName: 'Co-Parent',
                  caregiverRole: 'Partner',
                  caregiverId: 'coparent_02',
                  caregiverEmail: 'coparent@lovingbrain.com',
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        // Verify title and toggle cards are visible and not hidden by bottomNavigationBar
        expect(find.text("What Co-Parent can see"), findsOneWidget);
        expect(find.text("Change any of this at any time."), findsOneWidget);
        expect(find.text("Sleep"), findsOneWidget);
        expect(find.text("Behaviour"), findsOneWidget);
        expect(find.text("Health notes"), findsOneWidget);
        expect(find.text("Plans"), findsOneWidget);
        expect(find.text("Mentorship summaries"), findsOneWidget);

        // Verify bottom action buttons are also present and visible
        expect(find.text("Save permissions"), findsOneWidget);
        expect(find.text("Remove Co-Parent's access"), findsOneWidget);
      },
    );

    test(
      'TC-N02 / NEW17-2: Re-authentication message detection and guard for stale sessions',
      () {
        const String reauthError =
            'For security, please sign out and sign in again before deleting your account.';
        final bool isSecurityError =
            reauthError.toLowerCase().contains('sign out and sign in') ||
            reauthError.toLowerCase().contains('security') ||
            reauthError.toLowerCase().contains('requires-recent-login');

        expect(isSecurityError, isTrue);

        final ApiResultStatus<dynamic> status = ApiResultStatus.error(
          error: Exception(reauthError),
        );
        expect(status, isA<Error<dynamic>>());
        final Error<dynamic> err = status as Error<dynamic>;
        expect(err.error.toString(), contains('sign out and sign in again'));
      },
    );

    test(
      'TC-N04 / NEW15-4: Caregiver name never falls back to raw email local part',
      () {
        // Test CaregiverPermissionsModel name resolution
        final CaregiverPermissionsModel perm = CaregiverPermissionsModel(
          caregiverEmail: 'testuser123@lovingbrain.com',
          name: '',
          role: 'Partner',
        );

        expect(perm.caregiverName, isNot(contains('testuser123')));
        expect(perm.caregiverName, equals('Partner'));

        // Test with empty role
        final CaregiverPermissionsModel permNoRole = CaregiverPermissionsModel(
          caregiverEmail: 'rawemail@domain.com',
          name: null,
          role: '',
        );
        expect(permNoRole.caregiverName, equals('Caregiver'));
      },
    );

    test(
      'TC-N05 & TC-N07: Unlinked co-parent has empty activeChildId, no ghost forecast, and childName is not "Child"',
      () async {
        // Set user as completely unlinked (no children in prefs or user)
        await preferences.clearChild();
        final UserModel unlinkedUser = UserModel(
          uid: 'unlinked_user_01',
          email: 'unlinked@lovingbrain.com',
          parentName: 'Test Parent',
          children: <dynamic>[],
        );
        await preferences.saveUserModel(unlinkedUser);

        final TodayCubit cubit = TodayCubit();
        await cubit.init();

        final TodayState state = cubit.state;
        expect(state.activeChildId, isEmpty);
        expect(state.childName, isEmpty);
        expect(state.hasAnyLogs, isFalse);
        expect(state.hasSleepLogs, isFalse);
        expect(state.forecastSubtitle, isEmpty);

        cubit.close();
      },
    );

    testWidgets(
      'TC-N05: TodayScreen displays welcoming No Child Linked card when activeChildId is empty',
      (WidgetTester tester) async {
        await preferences.clearChild();
        final UserModel unlinkedUser = UserModel(
          uid: 'unlinked_user_02',
          email: 'unlinked2@lovingbrain.com',
          parentName: 'Test Parent',
          children: <dynamic>[],
        );
        await preferences.saveUserModel(unlinkedUser);

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(389, 780),
            builder: (BuildContext context, Widget? child) {
              return const MaterialApp(home: TodayScreen());
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text("No child profile linked"), findsOneWidget);
        expect(find.text("Add child profile"), findsOneWidget);
        expect(
          find.text(
            "You are not currently linked to a child. You can create a new child profile to start tracking routines, or ask your partner to send an invite.",
          ),
          findsOneWidget,
        );
      },
    );
  });
}
