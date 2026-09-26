import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/sleep_details/sleep_details_screen.dart';
import 'package:loving_brain/ui/sleep_forecast/widgets/forecast_days_row.dart';
import 'package:loving_brain/ui/sleep_forecast/widgets/forecast_details_card.dart';
import 'package:loving_brain/ui/sleep_forecast/widgets/forecast_header.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';

import 'bloc/sleep_forecast_cubit.dart';
import 'bloc/sleep_forecast_state.dart';

class SleepForecastScreen extends StatelessWidget {
  const SleepForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SleepForecastCubit()..init(),
      child: BlocBuilder<SleepForecastCubit, SleepForecastState>(
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: darkBlue,
            ),
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: const Color(0xFFFEF8F4),
              body: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const ForecastHeader(),
                        16.spaceH,
                        const ForecastDaysRow(),
                        16.spaceH,
                        const ForecastDetailsCard(),
                        32.spaceH,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: AppButton(
                            title: "View details",
                            onTap: () {
                              final todayCubit = context.read<TodayCubit>();
                              // Pop the Forecast bottom sheet
                              Navigator.pop(context);
                              // Open Details as a new bottom sheet
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (context) => BlocProvider.value(
                                  value: todayCubit,
                                  child: const SleepDetailsScreen(),
                                ),
                              );
                            },
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                          ),
                        ),
                        100.spaceH,
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
