import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/extra_methods.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_cubit.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_state.dart';
import 'package:loving_brain/ui/sleep_summary/widget/add_sleep_log_dialog.dart';
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
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [sleepSummaryBackgroundColor, const Color(0xFF1E2841)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      20.spaceH,
                      "${LocaleKeys.sleepSummaryFor.tr()} ${state.childModel?.childName ?? ""}"
                          .appText(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                      20.spaceH,
                      if (state.sleepLogs.isEmpty) ...[
                        _noSleepSummary(),
                      ] else ...[
                        _sleepSummaryChart(state),
                      ],
                    ],
                  ),
                ),
                _appBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _addButton({bool isDataState = false}) {
    return BaseButton(
      onTap: () {
        AddSleepLogDialog.show(context);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueColor2, const Color(0xFF5D7AFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: blueColor2.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            8.spaceW,
            (isDataState ? LocaleKeys.addSleepLog.tr() : LocaleKeys.addFirstSleepLog.tr()).appText(
              color: Colors.white,
              fontSize: 15,
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
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC3D4FE).withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Assets.images.imgSleepTeddy.image(width: 140),
                ),
                32.spaceH,
                LocaleKeys.noSleepLogsYet.tr().appText(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
                16.spaceH,
                LocaleKeys.startByLoggingYourChildBedtime.tr().appText(
                  fontSize: 15,
                  color: const Color(0xFF64748B),
                  textAlign: TextAlign.center,
                  height: 1.4,
                ),
                32.spaceH,
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
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                _addButton(isDataState: true),
                32.spaceH,

                // Weekly Trend Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: LocaleKeys.viewWeeklyTrend.tr().appText(
                              color: const Color(0xFF0F172A),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          16.spaceW,
                          _weeklyDropdown(state),
                        ],
                      ),
                      32.spaceH,
                      _graph(state),
                    ],
                  ),
                ),
                32.spaceH,

                // Well Done Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFFDE68A),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFDE68A).withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDE68A),
                          shape: BoxShape.circle,
                        ),
                        child: Assets.images.imgSleepMoon.image(width: 28),
                      ),
                      16.spaceW,
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${state.childModel?.childName} ",
                                style: const TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: LocaleKeys.slept.tr(),
                                style: const TextStyle(
                                  color: Color(0xFF334155),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " ${context.read<SleepSummaryCubit>().getTotalSleepStringForWeek()} ",
                                style: const TextStyle(
                                  color: Color(0xFFD97706),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const TextSpan(
                                text: "well done!",
                                style: TextStyle(
                                  color: Color(0xFF334155),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                32.spaceH,

                // Average Time Cards
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        LocaleKeys.averageBedTime.tr(),
                        context.read<SleepSummaryCubit>().getAverageBedTimeString(),
                        Icons.nights_stay_rounded,
                        const Color(0xFF4F46E5),
                      ),
                    ),
                    16.spaceW,
                    Expanded(
                      child: _statCard(
                        LocaleKeys.averageWakeUp.tr(),
                        context.read<SleepSummaryCubit>().getAverageWakeTimeString(),
                        Icons.wb_sunny_rounded,
                        const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                32.spaceH,

                _sleepLogsList(state),
                40.spaceH,
              ],
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          16.spaceH,
          title.appText(
            color: const Color(0xFF64748B),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          8.spaceH,
          value.appText(
            color: const Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _sleepLogsList(SleepSummaryState state) {
    if (state.selectedWeek == null) return const SizedBox();

    final weekStart = DateTime(
      state.selectedWeek!.start.year,
      state.selectedWeek!.start.month,
      state.selectedWeek!.start.day,
    );
    final weekEnd = DateTime(
      state.selectedWeek!.end.year,
      state.selectedWeek!.end.month,
      state.selectedWeek!.end.day,
      23,
      59,
      59,
    );

    final weeklyLogs = state.sleepLogs.where((log) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);
      return logDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          logDate.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();

    // Sort logs descending by date
    weeklyLogs.sort((a, b) => b.date.compareTo(a.date));

    if (weeklyLogs.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.list_alt_rounded, color: Color(0xFF64748B), size: 24),
            8.spaceW,
            "Sleep Logs".appText(
              color: const Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
        16.spaceH,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: weeklyLogs.length,
          separatorBuilder: (context, index) => 12.spaceH,
          itemBuilder: (context, index) {
            final log = weeklyLogs[index];
            return _sleepLogItem(log);
          },
        ),
      ],
    );
  }

  Widget _sleepLogItem(SleepLogModel log) {
    return Dismissible(
      key: Key(log.id ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_rounded, color: Colors.red, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Delete Sleep Log", style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text("Are you sure you want to delete this sleep log?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        if (log.id != null) {
          context.read<SleepSummaryCubit>().deleteSleepLog(log.id!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bedtime_rounded, color: Color(0xFF4F46E5), size: 24),
            ),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formatDate(log.date).appText(
                    color: const Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  4.spaceH,
                  "${coParentScheduleTime(log.bedTime)} - ${coParentScheduleTime(log.wakeTime)}".appText(
                    color: const Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  if ((log.notes ?? "").isNotEmpty) ...[
                    8.spaceH,
                    "Notes: ${log.notes}".appText(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      child: BaseButton(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
        ),
        onTap: () {
          context.pop();
        },
      ),
    );
  }

  Widget _weeklyDropdown(SleepSummaryState state) {
    return Flexible(
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
                    8.spaceH,
                    week.getFormattedRange
                        .appText(fontWeight: FontWeight.w600, fontSize: 13, color: const Color(0xFF1E293B))
                        .appPadding(left: 16),
                    8.spaceH,
                    const Divider(height: 0.1, thickness: 0.5, color: Color(0xFFE2E8F0)),
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
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: (state.selectedWeek?.getFormattedRange ?? "").appText(
                  color: const Color(0xFF334155),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _graph(SleepSummaryState state) {
    if (state.selectedWeek == null) return const SizedBox();

    final values = SleepLogRepo.instance.getWeeklySleepHoursOffline(
      state.sleepLogs,
      state.selectedWeek!,
    );

    double maxVal = 0;
    for (var v in values) {
      if (v > maxVal) maxVal = v;
    }
    
    // Dynamic interval to prevent overlapped labels when values are high
    double interval = maxVal / 5;
    if (interval < 2) interval = 2; // minimum threshold

    return AppBarGraph(
      height: 220.h,
      titles: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      values: values,
      interval: interval.ceilToDouble(),
      showBest: false,
      showTitles: true,
      textColor: const Color(0xFF64748B),
      hrTitlesWidget: (val, meta) {
        return val.toInt().toString().appText(
          color: const Color(0xFF94A3B8),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
      },
    );
  }
}
