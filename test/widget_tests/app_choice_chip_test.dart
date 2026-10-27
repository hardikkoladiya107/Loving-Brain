import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/ui/widget/app_choice_chip.dart';

Widget createChipTestApp(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(389, 780),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (BuildContext context, Widget? _) {
      return MaterialApp(
        home: Scaffold(body: Center(child: child)),
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppChoiceChip Widget Tests', () {
    testWidgets('renders label with proper unselected styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createChipTestApp(
          AppChoiceChip(label: 'Calm', isSelected: false, onTap: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Calm'), findsOneWidget);
      final AnimatedContainer container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.white));
    });

    testWidgets('triggers onTap and applies active styling when selected', (
      WidgetTester tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        createChipTestApp(
          AppChoiceChip(
            label: 'Tired',
            isSelected: true,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tired'), findsOneWidget);
      final AnimatedContainer container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(indigoLight));

      await tester.tap(find.text('Tired'));
      expect(tapped, isTrue);
    });

    testWidgets('displays error border when isError is true and unselected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createChipTestApp(
          AppChoiceChip(
            label: 'Overwhelmed',
            isSelected: false,
            isError: true,
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final AnimatedContainer container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      final Border border = decoration.border as Border;
      expect(border.top.color, equals(Colors.red));
    });
  });
}
