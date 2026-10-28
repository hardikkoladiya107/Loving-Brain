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
import 'package:loving_brain/ui/widget/app_loading_indicator.dart';

import 'bloc/sleep_forecast_cubit.dart';
import 'bloc/sleep_forecast_state.dart';

/// Screen 23 — Sleep Forecast detail view.
class SleepForecastScreen extends StatefulWidget {
  const SleepForecastScreen({super.key});

  @override
  State<SleepForecastScreen> createState() => _SleepForecastScreenState();
}

class _SleepForecastScreenState extends State<SleepForecastScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SleepForecastCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepForecastCubit, SleepForecastState>(
      listener: (BuildContext context, SleepForecastState state) {},
      builder: (BuildContext context, SleepForecastState state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(statusBarColor: darkBlue),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: const Color(0xFFFEF8F4),
            body: state.isLoading
                ? const AppLoadingIndicator()
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
                            // Pop the Forecast bottom sheet
                            Navigator.pop(context);
                            // Open Details as a new bottom sheet
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: (BuildContext sheetCtx) =>
                                  const SleepDetailsScreen(),
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
    );
  }
}
