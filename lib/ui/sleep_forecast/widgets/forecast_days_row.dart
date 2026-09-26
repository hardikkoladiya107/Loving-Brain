import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/sleep_pattern/sleep_pattern_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sleep_forecast_cubit.dart';

class ForecastDaysRow extends StatelessWidget {
  const ForecastDaysRow({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final state = context.watch<SleepForecastCubit>().state;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(days.length, (index) {
        final isSelected = state.selectedDayIndex == index;
        return GestureDetector(
          onTap: () {
            context.read<SleepForecastCubit>().selectDay(index);
            // Close bottom sheet and navigate to Sleep Pattern
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SleepPatternScreen(),
              ),
            );
          },
          child: Column(
            children: [
              days[index].appText(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.grey,
              ),
              SizedBox(height: 8.h),
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : indigoLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.check,
                  size: 16.sp,
                  color: isSelected ? Colors.white : secondaryColor,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
