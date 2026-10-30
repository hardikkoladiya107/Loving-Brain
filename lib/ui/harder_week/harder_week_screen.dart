import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/core/brainy_entry_context.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

import 'bloc/harder_week_cubit.dart';
import 'bloc/harder_week_state.dart';

class HarderWeekScreen extends StatefulWidget {
  const HarderWeekScreen({super.key});

  @override
  State<HarderWeekScreen> createState() => _HarderWeekScreenState();
}

class _HarderWeekScreenState extends State<HarderWeekScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HarderWeekCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HarderWeekCubit, HarderWeekState>(
      listener: (BuildContext context, HarderWeekState state) {},
      builder: (BuildContext context, HarderWeekState state) {
        final String dateLabel = state.insights?.dateRangeLabel ?? 'This week';

        return Scaffold(
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
                          onTap: () => context.pop(),
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
                          _buildThisWeekCard(state),
                          16.spaceH,
                          _buildWhatWeNoticedCard(state),
                          16.spaceH,
                          _buildSmallThingToTryCard(state),
                          200.spaceH,
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
      },
    );
  }

  Widget _buildThisWeekCard(HarderWeekState state) {
    final String explanation =
        state.insights?.harderExplanation ??
        "Travel disrupted the routine. That's expected, and it isn't a setback routines take a few days to settle again.";

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
            chipTitle: 'This week',
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
                    'This week\nwas harder'.appText(
                      fontSize: 20.sp,
                      color: greyColor9,
                      fraunces: true,
                      textAlign: TextAlign.start,
                      height: 1.2,
                    ),
                    8.spaceH,
                    explanation.appText(
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

  Widget _buildWhatWeNoticedCard(HarderWeekState state) {
    final String title =
        state.insights?.harderNoticedTitle ??
        'Sleep windows shifted later most nights';
    final String detail =
        state.insights?.harderNoticedDetail ??
        'Bedtime averaged later than usual during the disrupted days.';

    return CommonInfoCard(
      chipTitle: 'What we noticed',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: title,
      titleFontSize: 20.sp,
      subtitle: detail,
    );
  }

  Widget _buildSmallThingToTryCard(HarderWeekState state) {
    final String suggestion =
        state.insights?.harderSmallThingToTry ?? 'Focus on morning sunlight';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: greyColor.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: 'One small thing to try',
            iconData: Icons.stars,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          suggestion.appText(
            fontSize: 20.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          8.spaceH,
          "A small daily shift to help reset sleep timing naturally without pressure."
              .appText(
                fontSize: 14.sp,
                color: greyColor,
                textAlign: TextAlign.start,
                height: 1.4,
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
      child: SafeArea(
        top: false,
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
                title: 'Talk to Brainy about this',
                onTap: () {
                  final HarderWeekCubit cubit = context.read<HarderWeekCubit>();
                  final String prompt = cubit.buildBrainyDisruptionPrompt();
                  final String reason =
                      cubit.state.insights?.harderExplanation ??
                      'Travel or illness disrupted our usual routine';
                  final String name =
                      cubit.state.child?.childName ?? 'our family';
                  context.push(
                    RoutePaths.brainyConversation,
                    extra: BrainyEntryContext.fromHarderWeek(
                      prompt: prompt,
                      attachedSummary:
                          'Harder week context\n- Child/family: $name\n- Disruption: $reason',
                    ),
                  );
                },
              ),
              12.spaceH,
              AppButton(
                title: 'Talk to an expert mentor',
                backgroundColor: Colors.white,
                textColor: darkBlue,
                onTap: () {
                  context.push(RoutePaths.mentorshipLanding);
                },
              ),
              16.spaceH,
              BaseButton(
                child: 'Back to Journey'.appText(
                  fontSize: 14.sp,
                  color: greyColor,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
