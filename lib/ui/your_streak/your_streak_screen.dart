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
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';

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
            context.pop();
          },
        ),
        12.w.spaceW,
        "${LocaleKeys.yourStreak.tr()} !".appText(fontWeight: FontWeight.w700),
        Spacer(),
        BaseButton(
          child: Icon(Icons.bar_chart),
          onTap: () {
            context.push(RoutePaths.reflectYourEmotions);
          },
        ),
      ],
    );
  }

  Widget _youAreOnRole(YourStreakState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "${LocaleKeys.youreOnRoll.tr()}, ${state.userModel?.parentName}!".appText(
            fontWeight: FontWeight.w900,
            fontSize: 16
          ),
        ],
      ).appPadding(top: 12.h, bottom: 12.h, left: 16.w, right: 16.w),
    );
  }

  Widget _currentStreakCard(YourStreakState state) {
    return Container(
      height: 350.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgCurrentStreakCard.path),
        ),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ]
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
              (state.userModel?.displayStreak ?? 0).toString().appText(fontWeight: FontWeight.w900, fontSize: 48),
              8.w.spaceW,
              Assets.icons.icStreakIcon.image(height: 40, width: 40),
            ],
          ),
          Spacer(),
         
          BaseButton(
            onTap: () {
              context.push(RoutePaths.dailyMoodLog);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LocaleKeys.yourMoodHistory.tr().appText(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                       8.w.spaceW,
                       Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black54,)
                    ],
                  ),
                ],
              ).appPadding(all: 16),
            ).appPadding(left: 20.w, right: 20.w),
          ),
          25.h.spaceH,
          LocaleKeys.donMissYourDailyMoodToKeepTheStreakGoing
              .tr()
              .appText(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.black54, textAlign: TextAlign.center)
              .appPadding(left: 24, right: 24),
           20.h.spaceH,   
        ],
      ),
    );
  }

  Widget _logMood({required String text, required GestureTapCallback? onTap}) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
             BoxShadow(
              color: cardColor2.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.appText(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
