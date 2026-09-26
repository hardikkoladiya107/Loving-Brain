import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';

class MentorshipUnavailableScreen extends StatelessWidget {
  const MentorshipUnavailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1E293B)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            16.spaceH,
            Text(
              "Available guides",
              style: TextStyle(
                fontSize: 32.sp,
                color: const Color(0xFF1E293B),
                fontFamily: 'Fraunces',
              ),
            ),
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
                  InfoBox(
                    title: "Fully booked",
                    body:
                        "Our sleep guides are booked for the next two weeks. We’ll let you know as soon as something opens up.",
                    backgroundColor: lightYellowColor,
                    textColor: yellowColor1,
                    iconColor: yellowColor1,
                  ),
                  24.spaceH,
                  Text(
                    "No suitable times right now",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: const Color(0xFF1E293B),
                      fontFamily: 'Fraunces',
                      height: 1.2,
                    ),
                  ),
                  12.spaceH,
                  Text(
                    "Our sleep guides are booked for the next two weeks. We'll let you know as soon as something opens up.",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            16.spaceH,
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoBox(
                    body: 'assets/v2/icons/ic_faqs.png', // Or checkmark icon
                    title: "Another option",
                    backgroundColor: const Color(0xFFD1FAE5), // Light green
                    textColor: const Color(0xFF059669),
                    iconColor: const Color(0xFF059669),
                  ),
                  24.spaceH,
                  Text(
                    "Two guides cover behaviour and general parenting",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: const Color(0xFF1E293B),
                      fontFamily: 'Fraunces',
                      height: 1.2,
                    ),
                  ),
                  12.spaceH,
                  Text(
                    "They can still help with evening routines.",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            16.spaceH,
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF), // Light purple
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                "Nothing has been charged, and joining the waitlist doesn't commit you to anything.",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1E293B),
                  height: 1.4,
                ),
              ),
            ),
            32.spaceH,
            AppButton(title: "Join the waitlist", onTap: () {}),
            12.spaceH,
            AppButton(
              title: "See other guides",
              backgroundColor: Colors.transparent,
              textColor: const Color(0xFF1E293B),
              borderColor: const Color(0xFFE2E8F0),
              onTap: () {},
            ),
            16.spaceH,
            Center(
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    "Ask Brainy instead",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            40.spaceH,
          ],
        ),
      ),
    );
  }
}
