import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/trying_this_week/trying_this_week_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

import 'bloc/weekly_family_review_cubit.dart';
import 'bloc/weekly_family_review_state.dart';

class WeeklyFamilyReviewScreen extends StatefulWidget {
  const WeeklyFamilyReviewScreen({super.key});

  @override
  State<WeeklyFamilyReviewScreen> createState() =>
      _WeeklyFamilyReviewScreenState();
}

class _WeeklyFamilyReviewScreenState extends State<WeeklyFamilyReviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeeklyFamilyReviewCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeeklyFamilyReviewCubit, WeeklyFamilyReviewState>(
      listener: (BuildContext context, WeeklyFamilyReviewState state) {},
      builder: (BuildContext context, WeeklyFamilyReviewState state) {
        final String dateLabel = state.insights?.dateRangeLabel ?? 'This week';

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Color(0xFFFEF8F4),
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: Stack(
              children: [
                // Top Left Glow
                Positioned(
                  left: -150,
                  top: -150,
                  child: Container(
                    width: 400.w,
                    height: 400.w,
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
                            'This week'.appText(
                              fontSize: 32.sp,
                              color: greyColor9,
                              fraunces: true,
                              textAlign: TextAlign.start,
                            ),
                            8.spaceH,
                            dateLabel.appText(
                              fontSize: 14.sp,
                              color: greyColor9,
                              textAlign: TextAlign.start,
                            ),
                            24.spaceH,
                            _buildPositiveChangeCard(state),
                            16.spaceH,
                            _buildContinuingDifficultyCard(state),
                            16.spaceH,
                            _buildUsefulPatternCard(state),
                            160.spaceH,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBottomActions(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPositiveChangeCard(WeeklyFamilyReviewState state) {
    final String title =
        state.insights?.positiveTitle ??
        'Bedtime\nresistance eased\ntwice this week';
    final String detail =
        state.insights?.positiveDetail ??
        'Settling took about 12 minutes on Tuesday and Friday, down from 20.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: 'One positive change',
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
                    title.appText(
                      fontSize: 20.sp,
                      color: greyColor9,
                      fraunces: true,
                      textAlign: TextAlign.start,
                      height: 1.2,
                    ),
                    8.spaceH,
                    detail.appText(
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

  Widget _buildContinuingDifficultyCard(WeeklyFamilyReviewState state) {
    final String title =
        state.insights?.difficultyTitle ?? 'Naps are still inconsistent';
    final String detail =
        state.insights?.difficultyDetail ??
        'Four of seven ended early. This is the one to keep watching.';

    return CommonInfoCard(
      chipTitle: 'One continuing difficulty',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: title,
      titleFontSize: 20.sp,
      subtitle: detail,
    );
  }

  Widget _buildUsefulPatternCard(WeeklyFamilyReviewState state) {
    final String title =
        state.insights?.patternTitle ?? 'She sleeps better after active days';
    final String detail =
        state.insights?.patternDetail ??
        'Days with outdoor park time resulted in fewer night wakings.';

    return CommonInfoCard(
      chipTitle: 'One useful pattern',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: title,
      titleFontSize: 20.sp,
      subtitle: detail,
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    WeeklyFamilyReviewState state,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 24.h,
            left: 20.w,
            right: 20.w,
          ),
          decoration: const BoxDecoration(color: Color(0xFFFEF2EA)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                title: 'Try the recommendation',
                onTap: () async {
                  await context
                      .read<WeeklyFamilyReviewCubit>()
                      .startRecommendedExperiment();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TryingThisWeekScreen(),
                      ),
                    );
                  }
                },
              ),
              16.spaceH,
              BaseButton(
                child: 'Ask Brainy about this week'.appText(
                  fontSize: 14.sp,
                  color: greyColor,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  final String prompt = context
                      .read<WeeklyFamilyReviewCubit>()
                      .buildBrainyPrompt();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BrainyConversationScreen(
                        topic: 'Weekly Review',
                        initialChat: prompt,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
