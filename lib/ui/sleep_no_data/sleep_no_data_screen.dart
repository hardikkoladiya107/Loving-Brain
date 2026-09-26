import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/person_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/sleep_no_data_cubit.dart';
import 'bloc/sleep_no_data_state.dart';

class SleepNoDataScreen extends StatelessWidget {
  const SleepNoDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1E293B)),
        title: Text(
          "Sleep",
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: 28.sp,
            fontFamily: 'Fraunces',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            24.spaceH,
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info,
                          color: const Color(0xFFD97706),
                          size: 16.sp,
                        ),
                        6.spaceW,
                        Text(
                          "No sleep data yet",
                          style: TextStyle(
                            color: const Color(0xFFD97706),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.spaceH,
                  Text(
                    "Typical for 17 months: bedtime around 8 PM",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: const Color(0xFF1E293B),
                      fontFamily: 'Fraunces',
                      height: 1.2,
                    ),
                  ),
                  12.spaceH,
                  Text(
                    "This is a general guide, not Ira's own pattern. One update starts personalising it.",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  16.spaceH,
                  PersonCard(
                    avatar: Image.asset(Assets.v2.images.imgHealth.path),
                    name: "Ira",
                    subtitle: "17 months old",
                    onTap: () {},
                  ),
                  24.spaceH,
                  AppButton(title: "Add a sleep update", onTap: () {}),
                ],
              ),
            ),
            16.spaceH,
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE), // Light red/pink
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                "Two or three updates is usually enough for us to show Ira's own window.",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1E293B),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
