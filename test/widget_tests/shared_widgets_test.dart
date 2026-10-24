import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/status_pill.dart';

Widget createTestApp(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(389, 780),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (BuildContext context, Widget? _) {
      return MaterialApp(home: Scaffold(body: child));
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Shared Widgets - AppButton Widget Tests', () {
    testWidgets('AppButton displays title and triggers onTap when pressed', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestApp(
          AppButton(
            title: 'Continue',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets(
      'AppButton shows loader and disables tap when isLoading is true',
      (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          createTestApp(
            AppButton(
              title: 'Submit Form',
              isLoading: true,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Submit Form'), findsNothing);

        await tester.tap(find.byType(CircularProgressIndicator));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tapped, isFalse);
      },
    );

    testWidgets('AppButton renders custom child widget when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          AppButton(
            widget: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.star, key: Key('star_icon')),
                Text('Custom Button'),
              ],
            ),
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('star_icon')), findsOneWidget);
      expect(find.text('Custom Button'), findsOneWidget);
    });
  });

  group('Shared Widgets - BaseButton Widget Tests', () {
    testWidgets('BaseButton wraps child and fires onTap', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestApp(
          BaseButton(
            onTap: () {
              tapped = true;
            },
            child: const Text('Tap Me'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tap Me'), findsOneWidget);

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  group('Shared Widgets - StatusPill Widget Tests', () {
    testWidgets('StatusPill.linked renders linked label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(StatusPill.linked()));
      await tester.pumpAndSettle();

      expect(find.text('Linked'), findsOneWidget);
    });

    testWidgets('StatusPill.awaitingResponse renders awaiting label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(StatusPill.awaitingResponse()));
      await tester.pumpAndSettle();

      expect(find.text('Awaiting response'), findsOneWidget);
    });

    testWidgets('StatusPill.pending renders pending label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(StatusPill.pending()));
      await tester.pumpAndSettle();

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('StatusPill custom constructor renders custom text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          const StatusPill(
            text: 'Special Status',
            textColor: Colors.blue,
            backgroundColor: Colors.white,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Special Status'), findsOneWidget);
    });
  });

  group('Shared Widgets - AppTextField Widget Tests', () {
    testWidgets('AppTextField displays title, hint, and receives input', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      String changedValue = '';

      await tester.pumpWidget(
        createTestApp(
          AppTextField(
            title: 'Child Name',
            hint: 'Enter your child name',
            controller: controller,
            onChanged: (String val) {
              changedValue = val;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Title is rendered uppercase by default in AppTextField
      expect(find.text('CHILD NAME'), findsOneWidget);
      expect(find.text('Enter your child name'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Leo');
      await tester.pumpAndSettle();

      expect(controller.text, 'Leo');
      expect(changedValue, 'Leo');
    });

    testWidgets('AppTextField renders error message when error is set', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          const AppTextField(
            title: 'Email',
            error: 'Invalid email address',
            showError: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Invalid email address'), findsOneWidget);
    });
  });
}
