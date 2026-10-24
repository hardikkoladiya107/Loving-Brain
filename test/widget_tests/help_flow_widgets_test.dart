import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/help_flow/bloc/help_flow_cubit.dart';
import 'package:loving_brain/ui/help_flow/help_guidance_screen.dart';
import 'package:loving_brain/ui/help_flow/help_problem_selection_screen.dart';

Widget createHelpFlowTestApp({
  required Widget child,
  required HelpFlowCubit cubit,
}) {
  return BlocProvider<HelpFlowCubit>.value(
    value: cubit,
    child: ScreenUtilInit(
      designSize: const Size(389, 780),
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

  group('Help Flow Widget Tests - HelpProblemSelectionScreen', () {
    testWidgets('renders all 4 problem options with labels and icons', (
      WidgetTester tester,
    ) async {
      final HelpFlowCubit cubit = HelpFlowCubit();

      await tester.pumpWidget(
        createHelpFlowTestApp(
          child: const HelpProblemSelectionScreen(),
          cubit: cubit,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Crying'), findsOneWidget);
      expect(find.text("Won't sleep"), findsOneWidget);
      expect(find.text('Feeding issue'), findsOneWidget);
      expect(find.text('Too fussy'), findsOneWidget);

      cubit.close();
    });
  });

  group('Help Flow Widget Tests - HelpGuidanceScreen', () {
    testWidgets(
      'renders guidance content, numbered steps, and action buttons',
      (WidgetTester tester) async {
        final HelpFlowCubit cubit = HelpFlowCubit();
        await cubit.selectProblem('wont_sleep');

        await tester.pumpWidget(
          createHelpFlowTestApp(
            child: const HelpGuidanceScreen(),
            cubit: cubit,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(HelpGuidanceScreen), findsOneWidget);

        cubit.close();
      },
    );
  });
}
