import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/sleep_pattern/sleep_pattern_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sleep_forecast_cubit.dart';
import '../bloc/sleep_forecast_state.dart';

class ForecastDaysRow extends StatelessWidget {
  const ForecastDaysRow({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> days = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final SleepForecastState state = context.watch<SleepForecastCubit>().state;

    final int todayIndex = (DateTime.now().weekday - 1) % 7;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(days.length, (int index) {
        final bool isSelected = state.selectedDayIndex == index;
        final bool hasLog = state.loggedDays.contains(index);
        final bool isToday = todayIndex == index;
        return GestureDetector(
          onTap: () {
            context.read<SleepForecastCubit>().selectDay(index);
            // Close bottom sheet and navigate to Sleep Pattern
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SleepPatternScreen(),
              ),
            );
          },
          child: Column(
            children: [
              days[index].appText(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? primaryColor
                    : (isToday ? darkBlue : Colors.grey),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor
                      : (hasLog ? indigoLight : Colors.transparent),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : (isToday
                              ? primaryColor.withValues(alpha: 0.5)
                              : const Color(0xFFEDE8E3)),
                    width: 1.w,
                  ),
                ),
                child: hasLog
                    ? Icon(
                        Icons.check,
                        size: 16.sp,
                        color: isSelected ? Colors.white : secondaryColor,
                      )
                    : null,
              ),
            ],
          ),
        );
      }),
    );
  }
}
