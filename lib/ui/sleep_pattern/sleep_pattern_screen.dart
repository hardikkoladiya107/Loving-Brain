import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/program_recommendation/program_recommendation_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/sleep_pattern_cubit.dart';
import 'bloc/sleep_pattern_state.dart';

class SleepPatternScreen extends StatelessWidget {
  const SleepPatternScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(context),
              16.spaceH,
              _buildCircularProgressCard(),
              16.spaceH,
              _buildWeeklySleepChart(),
              16.spaceH,
              _buildNoticeCard(),
              100.spaceH,
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: AppButton(
              title: "Try this change",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProgramRecommendationScreen(),
                  ),
                );
              },
              backgroundColor: primaryColor,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 350,
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
          bottom: 16,
          right: 16,
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(Assets.v2.images.imgNoriSleepPattern.path),
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: darkBlue, size: 24.sp),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: "Sleep pattern".appText(
            fontSize: 28.sp,
            color: Colors.white,
            fraunces: true,
            textAlign: TextAlign.start,
          ),
        ),

        SafeArea(bottom: false, child: 160.spaceH),
      ],
    );
  }

  Widget _buildCircularProgressCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: orangeLightColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProgressCircle("Wd", "5h", 5 / 8),
          _buildProgressCircle("Th", "5h", 5 / 8),
          _buildProgressCircle("Sn", "3h", 3 / 8),
          _buildProgressCircle("Mn", "5h", 5 / 8),
          _buildProgressCircle("Tu", "2h", 2 / 8),
          _buildProgressCircle("Wd", "6h", 6 / 8),
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
                  value: value,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  color: primaryColor,
                  strokeWidth: 10,
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

  Widget _buildWeeklySleepChart() {
    return Container(
      width: double.infinity,
      height: 250.h,
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF16152A), // Dark blue like screenshot
        borderRadius: BorderRadius.circular(24),
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
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
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
                      getTitlesWidget: (value, meta) {
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
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 4),
                      FlSpot(1, 5),
                      FlSpot(2, 3),
                      FlSpot(3, 5),
                      FlSpot(4, 2),
                      FlSpot(5, 6),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE081F0), Color(0xFF4FA0F6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
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

  Widget _buildNoticeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          "Naps have been shorter this week".appText(
            fontSize: 20.sp,
            fraunces: true,
            textAlign: TextAlign.start,
          ),
          12.spaceH,
          "Four of the last five ended early, which tends to show up as harder evenings."
              .appText(
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

Widget _buildTimeframeToggles(BuildContext context, SleepPatternState state) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: greyColor12),
      ),
      child: Row(
        children: [
          _buildToggleOption(context, 'Day', 0, state.selectedToggleIndex),
          _buildToggleOption(context, 'Week', 1, state.selectedToggleIndex),
          _buildToggleOption(context, 'Month', 2, state.selectedToggleIndex),
        ],
      ),
    ),
  );
}

Widget _buildToggleOption(
  BuildContext context,
  String title,
  int index,
  int selectedIndex,
) {
  final isSelected = index == selectedIndex;
  return Expanded(
    child: GestureDetector(
      onTap: () => context.read<SleepPatternCubit>().setToggleIndex(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: title.appText(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : greyColor4,
          ),
        ),
      ),
    ),
  );
}
