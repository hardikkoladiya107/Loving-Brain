import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/family_snapsshot/family_snapshot_screen.dart';
import 'package:loving_brain/ui/sleep_low_confidence/sleep_low_confidence_screen.dart';
import 'package:loving_brain/ui/sleep_no_data/sleep_no_data_screen.dart';

Widget createScreenTestApp(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(389, 780),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (BuildContext context, Widget? _) {
      return MaterialApp(home: child);
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Screen Widget Tests - SleepNoDataScreen (Screen 64)', () {
    testWidgets('SleepNoDataScreen renders no-data banner and fallback guide', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createScreenTestApp(const SleepNoDataScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('No sleep data yet'), findsOneWidget);
      expect(find.text('Add a sleep update'), findsOneWidget);
    });
  });

  group('Screen Widget Tests - SleepLowConfidenceScreen (Screen 69)', () {
    testWidgets(
      'SleepLowConfidenceScreen renders wide window and honest caveat',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestApp(const SleepLowConfidenceScreen()),
        );
        await tester.pumpAndSettle();

        expect(find.text('Sleep'), findsOneWidget);
        expect(find.text('Still learning this pattern'), findsOneWidget);
        expect(find.text('Confidence: low'), findsOneWidget);
      },
    );
  });

  group('Screen Widget Tests - FamilySnapshotScreen', () {
    testWidgets('FamilySnapshotScreen renders family snapshot cards & CTA', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenTestApp(const FamilySnapshotScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('What we noticed'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Try this first'), 100);
      expect(find.text('Try this first'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Go to Today'), 100);
      expect(find.text('Go to Today'), findsOneWidget);
    });
  });
}
