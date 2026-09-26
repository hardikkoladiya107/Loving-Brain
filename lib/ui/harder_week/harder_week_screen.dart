import 'package:flutter/material.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/mentorship_landing/mentorship_landing_screen.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';

class HarderWeekScreen extends StatelessWidget {
  const HarderWeekScreen({super.key});

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
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: darkBlue,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      16.spaceH,
                      "This week".appText(
                        fontSize: 32.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      8.spaceH,
                      "Sunday 5 May ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã…â€œ Saturday 11 May"
                          .appText(
                            fontSize: 14.sp,
                            color: greyColor9,
                            textAlign: TextAlign.start,
                          ),
                      24.spaceH,
                      _buildThisWeekCard(),
                      16.spaceH,
                      _buildWhatWeNoticedCard(),
                      16.spaceH,
                      _buildSmallThingToTryCard(),
                      160.spaceH,
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

  Widget _buildThisWeekCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "This week",
            iconData: Icons.stars,
            color: secondaryColor,
            bgColor: const Color(0xFFF1EEFF),
          ),
          16.spaceH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Image.asset(
                  Assets.v2.images.imgJourneyThisWeek.path,
                  fit: BoxFit.contain,
                ),
              ),
              16.spaceW,
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "This week\nwas harder".appText(
                      fontSize: 20.sp,
                      color: greyColor9,
                      fraunces: true,
                      textAlign: TextAlign.start,
                      height: 1.2,
                    ),
                    8.spaceH,
                    "Travel disrupted the routine. That's expected, and it isn't a setback routines take a few days to settle again."
                        .appText(
                          fontSize: 12.sp,
                          color: greyColor,
                          textAlign: TextAlign.start,
                          height: 1.4,
                        ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhatWeNoticedCard() {
    return CommonInfoCard(
      chipTitle: 'What we noticed',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: 'Sleep windows shifted later most nights',
      titleFontSize: 20.sp,
      subtitle: 'Bedtime averaged 9:05 PM, about 50 minutes later than usual.',
    );
  }

  Widget _buildSmallThingToTryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "One small thing to try",
            iconData: Icons.stars,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          "Focus on morning sunlight".appText(
            fontSize: 20.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
        ],
      ),
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
        decoration: BoxDecoration(color: Color(0xffFEF2EA)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              title: "Talk to Brainy about this",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BrainyConversationScreen(),
                  ),
                );
              },
            ),
            12.spaceH,
            AppButton(
              title: "Talk to an expert mentor",
              backgroundColor: Colors.white,
              textColor: darkBlue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MentorshipLandingScreen(),
                  ),
                );
              },
            ),
            16.spaceH,
            BaseButton(
              child: "Back to Journey".appText(
                fontSize: 14.sp,
                color: greyColor,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                // Assuming we pop back to the Journey Screen
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
