import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/ui/sleep_summary/add_sleep_log_screen.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_cubit.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_state.dart';
import 'package:loving_brain/ui/widget/app_bar_graph.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import '../../generated/locale_keys.g.dart';

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
                  55.spaceH,
                  "${LocaleKeys.sleepSummaryFor.tr()} ${state.childModel?.childName}"
                      .appText(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                  if (state.sleepLogs.isEmpty) ...[
                    _noSleepSummary(),
                  ] else ...[
                    _sleepSummaryChart(state),
                  ],
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
        ).push(MaterialPageRoute(builder: (context) => AddSleepLogScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: blueColor2.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 20),
            8.spaceW,
            LocaleKeys.addFirstSleepLog.tr().appText(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _noSleepSummary() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 24),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Assets.images.imgSleepTeddy.image(width: 160),
                24.spaceH,
                LocaleKeys.noSleepLogsYet.tr().appText(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                12.spaceH,
                LocaleKeys.startByLoggingYourChildBedtime.tr().appText(
                  fontSize: 14,
                  color: Colors.grey[600],
                  textAlign: TextAlign.center,
                ),
                24.spaceH,
                _addButton(),
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
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              _addButton(),
              24.spaceH,
              Container(
                decoration: BoxDecoration(
                  color: selectedTabColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LocaleKeys.viewWeeklyTrend.tr().appText(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        _weeklyDropdown(state),
                      ],
                    ),
                    24.spaceH,
                    _graph(state),
                  ],
                ),
              ),
              24.spaceH,
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Assets.images.imgSleepMoon.image(width: 24),
                    ),
                    12.spaceH,
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${state.childModel?.childName} ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: LocaleKeys.slept.tr(),
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " ${context.read<SleepSummaryCubit>().getTotalSleepStringForWeek()} ",
                              style: TextStyle(
                                color: Colors.amber[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: "well done",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              24.spaceH,
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      LocaleKeys.averageBedTime.tr(),
                      context.read<SleepSummaryCubit>().getAverageBedTimeString(),
                      Icons.bedtime_rounded,
                      Colors.indigo,
                    ),
                  ),
                  16.spaceW,
                  Expanded(
                    child: _statCard(
                      LocaleKeys.averageWakeUp.tr(),
                      context.read<SleepSummaryCubit>().getAverageWakeTimeString(),
                      Icons.wb_sunny_rounded,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              40.spaceH,
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          12.spaceH,
          title.appText(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          4.spaceH,
          value.appText(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ],
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

  Widget _weeklyDropdown(SleepSummaryState state) {
    return SizedBox(
      width: 170,
      child: AppDropDownButton(
        offset: Offset(0, 30.h),
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
                        .appText(fontWeight: FontWeight.w500, fontSize: 14)
                        .appPadding(left: 16),
                    8.spaceH,
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
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              Icon(Icons.arrow_drop_down_outlined, color: Colors.black),
            ],
          ).appPadding(all: 4),
        ),
      ),
    );
  }

  Widget _graph(SleepSummaryState state) {
    return AppBarGraph(
      height: 200.h,
      titles: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      values: SleepLogRepo.instance.getWeeklySleepHoursOffline(
        state.sleepLogs,
        state.selectedWeek!,
      ),
      interval: 4,
      showBest: false,
      showTitles: true,
      textColor: Colors.black,
      hrTitlesWidget: (val, meta) {
        return val.toInt().toString().appText(
          color: Colors.black,
          fontSize: 12,
        );
      },
    );
  }
}
