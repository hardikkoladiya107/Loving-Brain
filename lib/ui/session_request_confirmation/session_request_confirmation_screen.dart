import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/enrolled_journey_home/enrolled_journey_home_screen.dart';
import 'package:loving_brain/ui/parent_success_guide/parent_success_guide_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

/// Screen 48: Session Request Confirmation.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class SessionRequestConfirmationScreen extends StatefulWidget {
  final String? guideName;

  const SessionRequestConfirmationScreen({super.key, this.guideName});

  @override
  State<SessionRequestConfirmationScreen> createState() =>
      _SessionRequestConfirmationScreenState();
}

class _SessionRequestConfirmationScreenState
    extends State<SessionRequestConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final String gName = widget.guideName ?? "Priya";

    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          // Top Left Glow
          Positioned(
            left: -150.w,
            top: -150.h,
            child: Container(
              width: 400.w,
              height: 400.h,
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
            right: -150.w,
            bottom: 0,
            child: Container(
              width: 400.w,
              height: 400.h,
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
                      60.spaceH,
                      _buildConfirmationCard(gName),
                      16.spaceH,
                      _buildInTheMeantimeCard(gName),
                      24.spaceH,
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: softPeachOrange,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child:
                            "Nothing has been charged. Any fee is agreed with you before a session is confirmed."
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor9,
                                  textAlign: TextAlign.start,
                                ),
                      ),
                      140.spaceH,
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

  Widget _buildConfirmationCard(String guideName) {
    return CommonInfoCard(
      chipTitle: 'Request sent',
      chipIcon: Icons.check_circle,
      chipColor: const Color(0xFF29985E),
      chipBgColor: const Color(0xFFE7F2ED),
      title: 'We’ll be in touch soon',
      titleFontSize: 24.sp,
      subtitle: "We’ll confirm $guideName’s availability and contact you shortly.",
    );
  }

  Widget _buildInTheMeantimeCard(String guideName) {
    return CommonInfoCard(
      chipTitle: 'In the meantime',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: 'Keep logging your updates',
      titleFontSize: 20.sp,
      subtitle:
          'It means $guideName can see the last two weeks before you talk, so you won\'t have to explain from scratch.',
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
          bottom: 24.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: const BoxDecoration(color: Color(0xFFFEF2EA)),
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
                  (Route<dynamic> route) => route.isFirst,
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentSuccessGuideScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
