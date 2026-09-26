import 'package:flutter/material.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';
import 'package:loving_brain/ui/trying_this_week/trying_this_week_screen.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';

class WeeklyFamilyReviewScreen extends StatelessWidget {
  const WeeklyFamilyReviewScreen({super.key});

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
                      "Sunday 12 May Ã¢â‚¬â€œ Saturday 18 May".appText(
                        fontSize: 14.sp,
                        color: greyColor9,
                        textAlign: TextAlign.start,
                      ),
                      24.spaceH,
                      _buildPositiveChangeCard(),
                      16.spaceH,
                      _buildContinuingDifficultyCard(),
                      16.spaceH,
                      _buildUsefulPatternCard(),
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

  Widget _buildPositiveChangeCard() {
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
            chipTitle: "One positive change",
            iconData: Icons.stars,
            color: yellowColor1,
            bgColor: lightYellowColor,
          ),
          16.spaceH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Image.asset(
                  Assets.v2.images.imgJourneyOnePositiveChange.path,
                  fit: BoxFit.contain,
                ),
              ),
              16.spaceW,
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Bedtime\nresistance eased\ntwice this week".appText(
                      fontSize: 20.sp,
                      color: greyColor9,
                      fraunces: true,
                      textAlign: TextAlign.start,
                      height: 1.2,
                    ),
                    8.spaceH,
                    "Settling took about 12 minutes on Tuesday and Friday, down from 20."
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

  Widget _buildContinuingDifficultyCard() {
    return CommonInfoCard(
      chipTitle: 'One continuing difficulty',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: 'Naps are still inconsistent',
      titleFontSize: 20.sp,
      subtitle: 'Four of seven ended early. This is the one to keep watching.',
    );
  }

  Widget _buildUsefulPatternCard() {
    return CommonInfoCard(
      chipTitle: 'One useful pattern',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: 'She sleeps better after active days',
      titleFontSize: 20.sp,
      subtitle: 'Days with outdoor park time resulted in fewer night wakings.',
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 20.h,
          bottom: 20.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: BoxDecoration(color: Color(0xffFEF2EA)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              title: "Try the recommendation",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TryingThisWeekScreen(),
                  ),
                );
              },
            ),
            16.spaceH,
            BaseButton(
              child: "Ask Brainy about this week".appText(
                fontSize: 14.sp,
                color: greyColor,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BrainyConversationScreen(),
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
