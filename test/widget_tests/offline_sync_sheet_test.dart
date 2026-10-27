import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/privacy_data/bloc/privacy_data_cubit.dart';
import 'package:loving_brain/ui/privacy_data/privacy_data_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget createTestApp(
  Widget child,
  PrivacyDataCubit cubit, {
  Size size = const Size(389, 780),
}) {
  return BlocProvider<PrivacyDataCubit>.value(
    value: cubit,
    child: ScreenUtilInit(
      designSize: size,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? _) {
        return MaterialApp(home: child);
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Offline Sync Bottom Sheet Widget Tests', () {
    testWidgets(
      'Tapping Offline sync tile opens bottom sheet with sync info and Sync now button',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(389, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final PrivacyDataCubit cubit = PrivacyDataCubit();
        cubit.changeProps(
          childName: 'Kaushik',
          lastSyncedTime: '12:05 PM',
          pendingOfflineUpdatesCount: 0,
        );

        await tester.pumpWidget(
          createTestApp(
            const PrivacyDataScreen(),
            cubit,
            size: const Size(389, 844),
          ),
        );
        await tester.pumpAndSettle();

        // Verify Offline sync tile is rendered
        final Finder tileFinder = find.text('Offline sync');
        expect(tileFinder, findsOneWidget);
        expect(find.text('All data is up to date'), findsOneWidget);

        // Tap the tile to open the bottom sheet
        await tester.tap(tileFinder);
        await tester.pumpAndSettle();

        // Verify bottom sheet content
        expect(
          find.text('Cloud synchronization & offline storage'),
          findsOneWidget,
        );
        expect(find.text('Offline Resilience Guarantee'), findsOneWidget);
        expect(find.text('Sync now'), findsOneWidget);

        // Verify no RenderFlex overflow
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Tapping Sync now in bottom sheet triggers sync and updates status without errors',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(389, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final PrivacyDataCubit cubit = PrivacyDataCubit();
        cubit.changeProps(
          childName: 'Kaushik',
          lastSyncedTime: '11:00 AM',
          pendingOfflineUpdatesCount: 0,
        );

        await tester.pumpWidget(
          createTestApp(
            const PrivacyDataScreen(),
            cubit,
            size: const Size(389, 844),
          ),
        );
        await tester.pumpAndSettle();

        // Tap tile to open bottom sheet
        await tester.tap(find.text('Offline sync'));
        await tester.pumpAndSettle();

        // Tap Sync now button inside the sheet
        final Finder syncNowButton = find.text('Sync now');
        expect(syncNowButton, findsOneWidget);
        await tester.tap(syncNowButton);

        // Pump frame to start async sync
        await tester.pump();
        expect(cubit.state.isSyncing, isTrue);

        // Fast forward through minimum visual delay (600ms) and settle
        await tester.pump(const Duration(milliseconds: 700));
        await tester.pumpAndSettle();

        // Verify sync completes and isSyncing resets to false
        expect(cubit.state.isSyncing, isFalse);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Offline sync bottom sheet handles constrained viewport height (520px) without overflow',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(360, 520);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final PrivacyDataCubit cubit = PrivacyDataCubit();
        cubit.changeProps(
          childName: 'Kaushik',
          lastSyncedTime: '12:05 PM',
          pendingOfflineUpdatesCount: 2,
        );

        await tester.pumpWidget(
          createTestApp(
            const PrivacyDataScreen(),
            cubit,
            size: const Size(360, 520),
          ),
        );
        await tester.pumpAndSettle();

        final Finder tileFinder = find.text('Offline sync');
        await tester.scrollUntilVisible(tileFinder, 50.0);
        await tester.pumpAndSettle();
        await tester.tap(tileFinder);
        await tester.pumpAndSettle();

        expect(find.text('All data is up to date'), findsWidgets);
        expect(find.text('Sync now'), findsOneWidget);

        // Verify strictly 0 overflows
        expect(tester.takeException(), isNull);
      },
    );
  });
}
