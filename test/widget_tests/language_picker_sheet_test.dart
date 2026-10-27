import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart';
import 'package:loving_brain/ui/parent_profile_v2/parent_profile_screen.dart';

Widget createTestApp(
  Widget child,
  ParentProfileV2Cubit cubit, {
  Size size = const Size(389, 780),
}) {
  return BlocProvider<ParentProfileV2Cubit>.value(
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

  group('Language Picker Sheet Overflow Prevention Tests', () {
    testWidgets(
      'Language picker sheet opens without RenderFlex overflow and displays all languages',
      (WidgetTester tester) async {
        // Set a constrained phone screen height (e.g. 667 like iPhone SE)
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final ParentProfileV2Cubit cubit = ParentProfileV2Cubit();
        cubit.changeProps(language: 'English');

        await tester.pumpWidget(
          createTestApp(
            const ParentProfileScreen(),
            cubit,
            size: const Size(375, 667),
          ),
        );
        await tester.pumpAndSettle();

        // Find the language tile and tap it to open bottom sheet
        final Finder languageTileFinder = find.text('PREFERRED LANGUAGE');
        expect(languageTileFinder, findsOneWidget);
        await tester.tap(languageTileFinder);
        await tester.pumpAndSettle();

        // Verify bottom sheet title is visible
        expect(find.text('Select preferred language'), findsOneWidget);

        // Verify languages are rendered
        expect(find.text('English'), findsWidgets);
        expect(find.text('Hindi'), findsOneWidget);
        expect(find.text('Gujarati'), findsOneWidget);

        // Verify NO overflow error occurred
        expect(tester.takeException(), isNull);

        // Tap Gujarati to select
        await tester.tap(find.text('Gujarati'));
        await tester.pumpAndSettle();

        // Bottom sheet dismissed and state updated
        expect(cubit.state.language, equals('Gujarati'));
      },
    );

    testWidgets(
      'Language picker sheet scrolls to bottom items on constrained height screens without overflow',
      (WidgetTester tester) async {
        // Constrain screen to very small height
        tester.view.physicalSize = const Size(360, 520);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final ParentProfileV2Cubit cubit = ParentProfileV2Cubit();
        cubit.changeProps(language: 'English');

        await tester.pumpWidget(
          createTestApp(
            const ParentProfileScreen(),
            cubit,
            size: const Size(360, 520),
          ),
        );
        await tester.pumpAndSettle();

        final Finder prefLangFinder = find.text('PREFERRED LANGUAGE');
        await tester.ensureVisible(prefLangFinder);
        await tester.pumpAndSettle();
        await tester.tap(prefLangFinder);
        await tester.pumpAndSettle();

        // Scroll down to the bottom of the language list
        final Finder listViewFinder = find.byType(ListView).last;
        await tester.drag(listViewFinder, const Offset(0, -300));
        await tester.pumpAndSettle();

        // Verify items scrolled into view
        expect(find.text('Portuguese'), findsOneWidget);

        // Ensure zero overflow exceptions
        expect(tester.takeException(), isNull);

        // Select Portuguese
        await tester.tap(find.text('Portuguese'));
        await tester.pumpAndSettle();

        expect(cubit.state.language, equals('Portuguese'));
      },
    );
  });
}
