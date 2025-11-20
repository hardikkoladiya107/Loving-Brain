import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/ui/sleep_summary/add_sleep_log.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_cubit.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_state.dart';
import 'package:loving_brain/ui/widget/app_bar_graph.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class SleepSummaryScreen extends StatefulWidget {
  const SleepSummaryScreen({super.key});

  @override
  State<SleepSummaryScreen> createState() => _SleepSummaryScreenState();
}

class _SleepSummaryScreenState extends State<SleepSummaryScreen> {
  @override
  void initState() {
    context.read<SleepSummaryCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepSummaryCubit, SleepSummaryState>(
      listener: (context, state) {
        state.getSleepLogsApiResult.whenOrNull(
          data: (data) {
            EasyLoading.dismiss();
            context.read<SleepSummaryCubit>().changeProps(sleepLogs: data);
          },
          error: (error) {
            EasyLoading.dismiss();
          },
          initial: () {
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: sleepSummaryBackgroundColor,
          body: Stack(
            children: [
              Column(
                children: [
                  6.spaceH,
                  "Sleep Summary for ${state.childModel?.childName}".appText(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  if (state.sleepLogs.isNotEmpty)
                    _sleepSummaryChart(state)
                  else
                    _noSleepSummary(),
                ],
              ),
              _appBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _addButton() {
    return BaseButton(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AddSleepLog()));
      },
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "+ Add First Sleep Log"
                .appText(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                )
                .appPadding(all: 8),
          ],
        ),
      ),
    );
  }

  Widget _noSleepSummary() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 222,
            decoration: BoxDecoration(
              color: yellowColor6,
              borderRadius: BorderRadius.all(Radius.elliptical(30, 40)),
            ),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Assets.images.imgSleepTeddy.image(width: 140),
                Expanded(
                  child: Column(
                    children: [
                      "No Sleep Logs Yet..".appText(fontSize: 20),
                      12.spaceH,
                      "Start by logging your child's bedtime and wake time to monitor their rest."
                          .appText(fontSize: 12),
                      12.spaceH,
                      Row(children: [_addButton()]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sleepSummaryChart(SleepSummaryState state) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: selectedTabColor,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(left: 12, right: 12, top: 80),

          child: Column(
            children: [
              60.spaceH,
              Assets.images.imgSleepMoon.image(width: 120),

              16.spaceH,
              _addButton().padding(left: 20, right: 20),

              16.spaceH,
              SizedBox(
                width: 170,
                child: AppDropDownButton(
                  offset: Offset(0, 20.h),
                  // dropdownWidth: 200,
                  dropDownWidget: (close) {
                    List<Widget> widgetsList = [];
                    for (int i = 0; i < state.weeks.length; i++) {
                      var week = state.weeks[i];
                      widgetsList.add(
                        BaseButton(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(),
                              8.spaceH,
                              week.getFormattedRange
                                  .appText(fontWeight: FontWeight.w500)
                                  .appPadding(left: 16),
                              if (i < state.weeks.length - 1) 8.spaceH,
                              if (i < state.weeks.length - 1)
                                Divider(height: 0.1, thickness: 0.5),
                            ],
                          ),
                          onTap: () {
                            close.call();
                            context.read<SleepSummaryCubit>().changeProps(
                              selectedWeek: week,
                            );
                          },
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widgetsList,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (state.selectedWeek?.getFormattedRange ?? "").appText(
                          color: Colors.black,
                        ),
                        Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Colors.black,
                        ),
                      ],
                    ).padding(all: 4),
                  ),
                ),
              ),
              16.spaceH,
              "View weekly Trend".appText(color: Colors.black, fontSize: 20),
              20.spaceH,
              "${state.childModel?.childName} Slept ${context.read<SleepSummaryCubit>().getTotalSleepStringForWeek()} well done"
                  .appText(color: yellowTextColor4, fontSize: 20),
              20.spaceH,
              "Bed Time : ${context.read<SleepSummaryCubit>().getAverageBedTimeString()}"
                  .appText(color: Colors.black, fontSize: 12),
              "Wake Up : ${context.read<SleepSummaryCubit>().getAverageWakeTimeString()}"
                  .appText(color: Colors.black, fontSize: 12),
              if (state.selectedWeek != null)
                AppBarGraph(
                  height: 200,
                  titles: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],

                  values: SleepLogRepo.instance.getWeeklySleepHoursOffline(
                    state.sleepLogs,
                    state.selectedWeek!,
                  ),
                  interval: 4,
                  showBest: false,
                  showTitles: true,
                  textColor: Colors.black,
                  hrTitlesWidget: (val, meta) => val.toInt().toString().appText(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Positioned(
      top: 60,
      left: 16,
      child: Row(
        children: [
          BaseButton(
            child: Assets.icons.icBackIcon.image(
              height: 36,
              width: 36,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ).appPadding(left: 20),
    );
  }
}
