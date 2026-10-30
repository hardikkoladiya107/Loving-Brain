import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_loading_indicator.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import 'bloc/sleep_pattern_cubit.dart';
import 'bloc/sleep_pattern_state.dart';

/// Screen 26 — Sleep Pattern view.
class SleepPatternScreen extends StatefulWidget {
  const SleepPatternScreen({super.key});

  @override
  State<SleepPatternScreen> createState() => _SleepPatternScreenState();
}

class _SleepPatternScreenState extends State<SleepPatternScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SleepPatternCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepPatternCubit, SleepPatternState>(
      listener: (BuildContext context, SleepPatternState state) {},
      builder: (BuildContext context, SleepPatternState state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xFFFEF8F4),
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: state.isLoading
                ? const AppLoadingIndicator()
                : Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildHeader(context),
                          16.spaceH,
                          _buildCircularProgressCard(state),
                          16.spaceH,
                          _buildWeeklySleepChart(state),
                          16.spaceH,
                          _buildNoticeCard(state),
                          100.spaceH,
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: 20.h,
                              left: 20.w,
                              right: 20.w,
                            ),
                            child: AppButton(
                              title: "Try this change",
                              onTap: () {
                                context.push(RoutePaths.programRecommendation);
                              },
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 350.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(Assets.v2.images.imgSleepBackground.path),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16.h,
          right: 16.w,
          child: Container(
            height: 150.h,
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(Assets.v2.images.imgNoriSleepPattern.path),
              ),
            ),
          ),
        ),
        // Positioned safely beneath the status bar
        Positioned(
          top: statusBarHeight > 0 ? statusBarHeight + 6.h : 20.h,
          left: 20.w,
          child: BaseButton(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Assets.v2.icons.icBack.svg(
                width: 24.w,
                height: 24.w,
                colorFilter: const ColorFilter.mode(darkBlue, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20.h,
          left: 20.w,
          child: "Sleep pattern".appText(
            fontSize: 28.sp,
            color: Colors.white,
            fraunces: true,
            textAlign: TextAlign.start,
          ),
        ),
        SafeArea(bottom: false, child: 180.spaceH),
      ],
    );
  }

  Widget _buildCircularProgressCard(SleepPatternState state) {
    final List<String> days = <String>["Wd", "Th", "Sn", "Mn", "Tu", "Wd"];
    final List<double> values = state.dailySleepHours;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: orangeLightColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < 6; i++)
            _buildProgressCircle(
              days[i],
              "${(i < values.length ? values[i] : 5.0).toInt()}h",
              (i < values.length ? values[i] : 5.0) / 8.0,
            ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(String day, String label, double value) {
    return Column(
      children: [
        SizedBox(
          width: 44.w,
          height: 44.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 44.w,
                height: 44.w,
                child: CircularProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  color: primaryColor,
                  strokeWidth: 10.w,
                ),
              ),
              label.appText(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: greyColor9,
              ),
            ],
          ),
        ),
        8.spaceH,
        day.appText(
          fontSize: 12.sp,
          color: greyColor4,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildWeeklySleepChart(SleepPatternState state) {
    final List<double> values = state.dailySleepHours;
    final List<FlSpot> spots = <FlSpot>[];
    for (int i = 0; i < 6; i++) {
      final double y = i < values.length ? values[i].clamp(0.0, 12.0) : 4.0;
      spots.add(FlSpot(i.toDouble(), y));
    }

    return Container(
      width: double.infinity,
      height: 250.h,
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF16152A),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Weekly sleep".appText(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          24.spaceH,
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (double value) {
                    return FlLine(
                      color: Colors.white.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const TextStyle style = TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Wd', style: style);
                            break;
                          case 1:
                            text = const Text('Th', style: style);
                            break;
                          case 2:
                            text = const Text('Sn', style: style);
                            break;
                          case 3:
                            text = const Text('Mn', style: style);
                            break;
                          case 4:
                            text = const Text('Tu', style: style);
                            break;
                          case 5:
                            text = const Text('Wd', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(meta: meta, child: text);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 20,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 8,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE081F0), Color(0xFF4FA0F6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(SleepPatternState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoChip(
            chipTitle: "What we noticed",
            iconData: Icons.info,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          state.patternInsight.appText(
            fontSize: 20.sp,
            fraunces: true,
            textAlign: TextAlign.start,
          ),
          12.spaceH,
          state.patternDetail.appText(
            fontSize: 14.sp,
            color: greyColor,
            height: 1.5,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
