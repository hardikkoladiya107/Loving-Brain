import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/sleep_forecast/bloc/sleep_forecast_cubit.dart';
import 'package:loving_brain/ui/sleep_forecast/widgets/forecast_days_row.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/widgets/today_header.dart';

Widget createTestAppWithProviders({
  required Widget child,
  TodayCubit? todayCubit,
  SleepForecastCubit? sleepForecastCubit,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<TodayCubit>.value(value: todayCubit ?? TodayCubit()),
      BlocProvider<SleepForecastCubit>.value(
        value: sleepForecastCubit ?? SleepForecastCubit(),
      ),
    ],
    child: ScreenUtilInit(
      designSize: const Size(389, 780),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? _) {
        return MaterialApp(home: Scaffold(body: child));
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Today Screen Widgets - TodayHeader Widget Tests', () {
    testWidgets('TodayHeader renders child name and profile avatars', (
      WidgetTester tester,
    ) async {
      final TodayCubit todayCubit = TodayCubit();
      todayCubit.changeProps(childName: 'Emma');

      await tester.pumpWidget(
        createTestAppWithProviders(
          child: const TodayHeader(),
          todayCubit: todayCubit,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Emma'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.face), findsOneWidget);
    });
  });

  group('Sleep Forecast Widgets - ForecastDaysRow Widget Tests', () {
    testWidgets(
      'ForecastDaysRow renders all 7 day labels and highlights selected day',
      (WidgetTester tester) async {
        final SleepForecastCubit forecastCubit = SleepForecastCubit();
        forecastCubit.selectDay(2); // Wednesday

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const ForecastDaysRow(),
            sleepForecastCubit: forecastCubit,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('M'), findsOneWidget);
        expect(find.text('W'), findsOneWidget);
        expect(find.text('F'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);
      },
    );
  });
}
