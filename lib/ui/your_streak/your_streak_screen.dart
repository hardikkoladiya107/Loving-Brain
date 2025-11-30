import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/reflect_your_emotions/reflect_your_emotions.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../daily_mood_log/daily_mood_log.dart';
import '../widget/base_button.dart';
import 'bloc/your_streak_cubit.dart';
import 'bloc/your_streak_state.dart';

class YourStreakScreen extends StatefulWidget {
  const YourStreakScreen({super.key});

  @override
  State<YourStreakScreen> createState() => _YourStreakScreenState();
}

class _YourStreakScreenState extends State<YourStreakScreen> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<YourStreakCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<YourStreakCubit, YourStreakState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Assets.images.imgYourStreakBg.image(
                      height: context.height,
                      width: context.width,
                    ),
                    Container(height: context.height),
                  ],
                ),
                Column(
                  children: [
                    45.h.spaceH,
                    _appBar(),
                    140.h.spaceH,
                    _youAreOnRole(state),
                    40.h.spaceH,
                    _currentStreakCard(state),
                    40.h.spaceH,
                    _logMood(text: LocaleKeys.logMood.tr(), onTap: () {}),
                  ],
                ).appPadding(left: 20.w, right: 20.w),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(
            height: 36,
            width: 36,
            color: Colors.black.withValues(alpha: 0.8),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        12.w.spaceW,
        "${LocaleKeys.yourStreak.tr()} !".appText(fontWeight: FontWeight.w700),
        Spacer(),
        BaseButton(
          child: Icon(Icons.bar_chart),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ReflectYourEmotions(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _youAreOnRole(YourStreakState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "${LocaleKeys.youreOnRoll.tr()}, ${state.userModel?.parentName}!".appText(
            fontWeight: FontWeight.w900,
          ),
        ],
      ).appPadding(top: 6.h, bottom: 6.h),
    );
  }

  Widget _currentStreakCard(YourStreakState state) {
    return Container(
      height: 350.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgCurrentStreakCard.path),
        ),
      ),
      child: Column(
        children: [
          18.h.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LocaleKeys.currentStreak.tr().appText(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ],
          ),
          10.h.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (state.userModel?.streak ??"").toString().appText(fontWeight: FontWeight.w900, fontSize: 32),
              Assets.icons.icStreakIcon.image(height: 35, width: 35),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     "${LocaleKeys.bestStreak.tr()}: 12 days".appText(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 14,
          //     ),
          //   ],
          // ),
          20.h.spaceH,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Assets.icons.icFlagIcon.image(height: 24, width: 24),
                    10.w.spaceW,
                    LocaleKeys.nextMilestone.tr().appText(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                12.h.spaceH,
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: SliderComponentShape.noThumb,
                    trackShape: const RoundedRectSliderTrackShape(),
                    activeTrackColor: cardColor2,
                    inactiveTrackColor: greyColor3,
                  ),
                  child: Slider(value: 8, onChanged: (value) {}, max: 10),
                ),
              ],
            ).appPadding(all: 12),
          ).appPadding(left: 16.w, right: 16.w),
          20.h.spaceH,
          BaseButton(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DailyMoodLog()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      LocaleKeys.yourMoodHistory.tr().appText(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ],
              ).appPadding(all: 12),
            ).appPadding(left: 16.w, right: 16.w),
          ),
          20.h.spaceH,
          LocaleKeys.donMissYourDailyMoodToKeepTheStreakGoing
              .tr()
              .appText(fontWeight: FontWeight.w700, fontSize: 10)
              .appPadding(left: 20, right: 20),
        ],
      ),
    );
  }

  Widget _logMood({required String text, required GestureTapCallback? onTap}) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.appText(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
