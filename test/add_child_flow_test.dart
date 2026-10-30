import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/add_child/add_child_screen.dart';
import 'package:loving_brain/ui/add_child/bloc/add_child_cubit.dart';
import 'package:loving_brain/ui/today_screen/sheets/child_switcher_sheet.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/shared_preferences'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'getAll') {
              return <String, Object>{};
            }
            return true;
          },
        );
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPreference.init();
  });

  group('AddChildCubit State & Form Validation Tests', () {
    test(
      'init sets toddler default date and location from user model',
      () async {
        final UserModel user = UserModel(
          uid: 'user_123',
          location: 'Mumbai, India',
        );
        await preferences.saveUserModel(user);

        final AddChildCubit cubit = AddChildCubit();
        cubit.init();

        expect(cubit.state.name, isEmpty);
        expect(cubit.state.location, contains('Mumbai, India'));
        expect(cubit.state.childDob, isNotNull);
        expect(cubit.state.dob, isNotEmpty);
        expect(cubit.state.selectedConcerns, isEmpty);

        await cubit.close();
      },
    );

    test(
      'updateName, updateDob, and toggleConcern update state correctly',
      () async {
        final AddChildCubit cubit = AddChildCubit();
        cubit.init();

        cubit.updateName('Maya');
        expect(cubit.state.name, 'Maya');

        final DateTime dob = DateTime(2023, 5, 20);
        cubit.updateDob(dob);
        expect(cubit.state.childDob, dob);
        expect(cubit.state.dob, contains('20 May 2023'));

        cubit.toggleConcern('Bedtime resistance');
        expect(cubit.state.selectedConcerns, contains('Bedtime resistance'));
        expect(cubit.state.concerns, contains('Bedtime resistance'));

        cubit.toggleConcern('Bedtime resistance');
        expect(
          cubit.state.selectedConcerns,
          isNot(contains('Bedtime resistance')),
        );

        await cubit.close();
      },
    );

    test(
      'submit blocks empty or whitespace name with validation error',
      () async {
        final AddChildCubit cubit = AddChildCubit();
        cubit.init();

        cubit.updateName('   ');
        await cubit.submit();

        expect(cubit.state.saveStatus, isA<Error>());
        final Error error = cubit.state.saveStatus as Error;
        expect(error.error.toString(), contains("Please enter child's name"));

        await cubit.close();
      },
    );
  });

  group('AddChildScreen Widget Rendering Tests', () {
    testWidgets(
      'Renders all fields, headers, suggested concerns, and Add child CTA',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(389, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final AddChildCubit cubit = AddChildCubit();
        cubit.init();

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(389, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? _) {
              return BlocProvider<AddChildCubit>.value(
                value: cubit,
                child: const MaterialApp(home: AddChildScreen()),
              );
            },
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Add another child'), findsOneWidget);
        expect(find.text("CHILD'S NAME"), findsOneWidget);
        expect(find.text("DATE OF BIRTH"), findsOneWidget);
        expect(find.text("COMMON ROUTINES & CONCERNS"), findsOneWidget);
        expect(find.text("Bedtime resistance"), findsOneWidget);
        expect(find.text("Night wakings"), findsOneWidget);
        expect(find.text("LOCATION / TIME ZONE"), findsOneWidget);
        expect(find.widgetWithText(AppButton, "Add child"), findsOneWidget);

        cubit.close();
      },
    );

    testWidgets(
      'ChildSwitcherSheet separates + Add another child from Edit active child profile',
      (WidgetTester tester) async {
        final ChildModel activeChild = ChildModel(
          childName: 'Emma',
          childAge: '3 years',
          parentReferenceIds: <String>['uid_1'],
        );
        await preferences.saveChildModel(activeChild);

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

        expect(
          find.widgetWithText(AppButton, '+ Add another child'),
          findsOneWidget,
        );
        expect(
          find.widgetWithText(AppButton, 'Edit active child profile'),
          findsOneWidget,
        );
      },
    );
  });
}
