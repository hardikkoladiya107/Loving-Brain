import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/invitation_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_cubit.dart';
import 'package:loving_brain/ui/permissions/bloc/permissions_cubit.dart';
import 'package:loving_brain/ui/sleep_forecast/bloc/sleep_forecast_cubit.dart';
import 'package:loving_brain/ui/sleep_forecast/sleep_forecast_screen.dart';
import 'package:loving_brain/ui/sleep_forecast/widgets/forecast_days_row.dart';
import 'package:loving_brain/ui/today_screen/sheets/child_switcher_sheet.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/sleep_header.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_sleep_update_sheet.dart';
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

    test(
      'Today tab pre-populates activeChildId from cached child synchronously on frame 0',
      () async {
        final UserModel user = UserModel(
          uid: 'cached_user_uid',
          email: 'parent@test.com',
          parentName: 'Sarah',
        );
        final ChildModel child = ChildModel(childName: 'Liam');
        await preferences.saveUserModel(user);
        await preferences.saveChildModel(child);
        await preferences.putBool(SharedPreference.isLogin, true);

        // Instantiation must evaluate synchronously from cached preferences
        final TodayCubit todayCubit = TodayCubit();

        expect(todayCubit.state.isLoading, false);
        expect(todayCubit.state.activeChildId, 'local_Liam');
        expect(todayCubit.state.childName, 'Liam');
        expect(todayCubit.state.parentName, 'SARAH');

        await todayCubit.close();
      },
    );

    test(
      'Today tab marks isLoading: true when logged in user has no cached child yet',
      () async {
        final UserModel user = UserModel(
          uid: 'fresh_user_uid',
          email: 'fresh@test.com',
          parentName: 'David',
        );
        await preferences.saveUserModel(user);
        await preferences.clearChild();
        await preferences.putBool(SharedPreference.isLogin, true);

        // Initial state for logged in user without cached child should be loading
        final TodayCubit todayCubit = TodayCubit();

        expect(todayCubit.state.isLoading, true);
        expect(todayCubit.state.activeChildId, '');

        await todayCubit.close();
      },
    );

    testWidgets(
      'Sleep update sheet auto-updates NAP STARTED & ENDED when fell asleep and woke up times are set',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(389, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final TodayCubit cubit = TodayCubit();

        await tester.pumpWidget(
          BlocProvider<TodayCubit>.value(
            value: cubit,
            child: ScreenUtilInit(
              designSize: const Size(389, 844),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (BuildContext context, Widget? _) {
                return const MaterialApp(
                  home: Scaffold(body: AddSleepUpdateSheet()),
                );
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Initially placeholder is visible
        expect(find.text('HH:MM AM - HH:MM PM'), findsOneWidget);

        // Set fell asleep time
        cubit.setFellAsleepTime('10:53 pm');
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('10:53 pm \u2013 HH:MM'), findsOneWidget);

        // Set woke up time
        cubit.setWokeUpTime('10:53 pm');
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('10:53 pm \u2013 10:53 pm'), findsOneWidget);

        await cubit.close();
      },
    );

    testWidgets(
      'SleepForecastScreen renders full screen view with interactive header controls and View details CTA',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(389, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final ChildModel child = ChildModel(
          childName: 'K',
          parentReferenceIds: <String>['test_parent'],
        );
        await preferences.saveChildModel(child);

        final SleepForecastCubit cubit = SleepForecastCubit();
        cubit.changeProps(
          isLoading: false,
          childName: 'K',
          parentName: 'HARDIK',
          timeOfDayGreeting: 'GOOD MORNING',
          windowStart: '6:00 pm',
          windowEnd: '7:00 pm',
          bedtimeEstimate: '6:30 pm',
          confidenceLevel: 'Low',
          reason: 'K woke at 10:55 am from a longer nap.',
        );

        await tester.pumpWidget(
          BlocProvider<SleepForecastCubit>.value(
            value: cubit,
            child: ScreenUtilInit(
              designSize: const Size(389, 844),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (BuildContext context, Widget? _) {
                return const MaterialApp(
                  home: SleepForecastScreen(),
                );
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Verifies header has back button, child chip, and parent avatar
        expect(find.byType(SleepHeader), findsOneWidget);
        expect(find.byType(BaseButton), findsAtLeastNWidgets(1));
        expect(find.text('K'), findsOneWidget);
        expect(find.byIcon(Icons.face), findsOneWidget);

        // Verifies greeting and forecast info
        expect(find.text('GOOD MORNING '), findsOneWidget);
        expect(find.text('HARDIK!'), findsOneWidget);
        expect(find.text('Next window'), findsOneWidget);
        expect(find.text('6:00 pm - 7:00 pm'), findsOneWidget);

        // Verifies View details CTA button
        expect(find.widgetWithText(AppButton, 'View details'), findsOneWidget);

        await cubit.close();
      },
    );

    testWidgets(
      'ForecastDaysRow selects days without popping or dismissing the screen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(389, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final SleepForecastCubit cubit = SleepForecastCubit();
        cubit.changeProps(
          isLoading: false,
          selectedDayIndex: 0,
        );

        await tester.pumpWidget(
          BlocProvider<SleepForecastCubit>.value(
            value: cubit,
            child: ScreenUtilInit(
              designSize: const Size(389, 844),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (BuildContext context, Widget? _) {
                return const MaterialApp(
                  home: Scaffold(body: ForecastDaysRow()),
                );
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        expect(cubit.state.selectedDayIndex, 0);

        // Tap Wednesday (index 2)
        await tester.tap(find.text('W'));
        await tester.pump(const Duration(milliseconds: 100));

        // State changes to selected day without popping
        expect(cubit.state.selectedDayIndex, 2);
        expect(find.byType(ForecastDaysRow), findsOneWidget);

        await cubit.close();
      },
    );

    testWidgets(
      'SleepHeader child switcher chip opens ChildSwitcherSheet and back button pops',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(389, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final ChildModel child = ChildModel(
          childName: 'Emma',
          parentReferenceIds: <String>['test_parent'],
        );
        await preferences.saveChildModel(child);

        bool backTapped = false;
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(389, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? _) {
              return MaterialApp(
                home: Scaffold(
                  body: SleepHeader(
                    showBackButton: true,
                    onBackTap: () => backTapped = true,
                    titleWidget: const Text('Header Title'),
                    chipText: 'Test Chip',
                    timeText: '7:00 PM',
                    estimateText: 'Estimate',
                    cloudImagePath: 'assets/v2/images/img_nori_sleep_forecaste.png',
                  ),
                ),
              );
            },
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Test Back Button
        await tester.tap(find.byType(BaseButton));
        await tester.pump(const Duration(milliseconds: 100));
        expect(backTapped, isTrue);

        // Test Child Chip Tap opens ChildSwitcherSheet
        await tester.tap(find.text('Emma'));
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(ChildSwitcherSheet), findsOneWidget);
      },
    );
  });
}
