import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/enrolled_journey_home/enrolled_journey_home_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

class SessionRequestConfirmationScreen extends StatelessWidget {
  const SessionRequestConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          // Top Left Glow
          Positioned(
            left: -150,
            top: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                    const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          // Bottom Right Glow
          Positioned(
            right: -150,
            bottom: 0,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                    const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      60.spaceH, // No back button
                      _buildConfirmationCard(),
                      16.spaceH,
                      _buildInTheMeantimeCard(),
                      24.spaceH,
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: softPeachOrange,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            "Nothing has been charged. Any fee is agreed with you before a session is confirmed."
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor9,
                                  textAlign: TextAlign.start,
                                ),
                      ),
                      120.spaceH,
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildConfirmationCard() {
    return CommonInfoCard(
      chipTitle: 'Request sent',
      chipIcon: Icons.check_circle,
      chipColor: const Color(0xFF29985E),
      chipBgColor: const Color(0xFFE7F2ED),
      title: 'We’ll be in touch soon',
      titleFontSize: 24.sp,
      subtitle: 'We’ll confirm Priya’s availability and contact you shortly.',
    );
  }

  Widget _buildInTheMeantimeCard() {
    return CommonInfoCard(
      chipTitle: 'In the meantime',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: 'Keep logging your updates',
      titleFontSize: 20.sp,
      subtitle:
          'It means Priya can see the last two weeks before you talk, so you won'
          't have to explain from scratch.',
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: 20.h,
          left: 20.w,
          right: 20.w,
        ),
        color: Color(0xffFEF2EA),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              title: "Back to Journey",
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EnrolledJourneyHomeScreen(),
                  ),
                  (route) => route.isFirst,
                );
              },
            ),
            16.spaceH,
            BaseButton(
              child: "View your request".appText(
                fontSize: 14.sp,
                color: greyColor,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
