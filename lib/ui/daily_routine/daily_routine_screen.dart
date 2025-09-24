import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import 'bloc/daily_routine_cubit.dart';
import 'bloc/daily_routine_state.dart';

class DailyRoutineScreen extends StatefulWidget {
  const DailyRoutineScreen({super.key});

  @override
  State<DailyRoutineScreen> createState() => _DailyRoutineScreenState();
}

class _DailyRoutineScreenState extends State<DailyRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyRoutineCubit, DailyRoutineState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgDailyRoutineBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  100.spaceH,
                  _header(),
                  80.spaceH,
                  Container(
                    decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.spaceH,
                        Row(),
                        "${LocaleKeys.addNewActivityFor.tr()} Rohan"
                            .appText(fontWeight: FontWeight.w900, fontSize: 14)
                            .appPadding(left: 20),
                        20.spaceH,
                        AppTextField(
                          title: LocaleKeys.time.tr(),
                          titleFontSize: 12,
                          height: 35,
                        ).appPadding(left: 20, right: 20),
                        10.spaceH,
                        AppTextField(
                          title: LocaleKeys.description.tr(),
                          titleFontSize: 12,
                          height: 35,
                        ).appPadding(left: 20, right: 20),
                        10.spaceH,
                        AppTextField(
                          title: LocaleKeys.type.tr(),
                          height: 35,
                          titleFontSize: 12,
                        ).appPadding(left: 20, right: 20),
                        30.spaceH,

                        BaseButton(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: yellowColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                "+ ${LocaleKeys.addActivity.tr()}"
                                    .appText(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    )
                                    .appPadding(top: 4, bottom: 4),
                              ],
                            ),
                          ),
                        ).appPadding(left: 80, right: 80),
                        20.spaceH,
                      ],
                    ),
                  ).appPadding(left: 30, right: 30),
                  20.spaceH,
                  "Rohan's ${LocaleKeys.currentDailyRoutine.tr()}"
                      .appText(fontWeight: FontWeight.w700, fontSize: 14)
                      .appPadding(left: 30),
                  20.spaceH,
                  _currentRoutingItem(label: "PLAY"),
                  10.spaceH,
                  _currentRoutingItem(label: ""),
                  80.spaceH,
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: LocaleKeys.dailyRoutine
              .tr()
              .appText(fontWeight: FontWeight.w900, fontSize: 18)
              .appPadding(left: 8, right: 8, top: 2, bottom: 2),
        ),
      ],
    );
  }

  Widget _currentRoutingItem({required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(),
          6.spaceH,
          "1:pm Lunch & Outdoor Play".appText(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          8.spaceH,
          if (label == "PLAY") _playButton() else _feedButton(),
          6.spaceH,
        ],
      ),
    ).appPadding(left: 30, right: 30);
  }

  Widget _playButton() {
    return Container(
      decoration: BoxDecoration(
        color: greenPlayButtonColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          6.spaceW,
          "Play".appText(fontSize: 12, fontWeight: FontWeight.w600),
          6.spaceW,
          Assets.icons.icPlayActivityIcon.image(height: 14),
          6.spaceW,
        ],
      ).appPadding(left: 6, right: 6, top: 2, bottom: 2),
    );
  }

  Widget _feedButton() {
    return Container(
      decoration: BoxDecoration(
        color: purpleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          6.spaceW,
          LocaleKeys.feed.tr().appText(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          6.spaceW,
          Assets.icons.icFeedIcon.image(height: 14),
          6.spaceW,
        ],
      ).appPadding(left: 6, right: 6, top: 2, bottom: 2),
    );
  }
}
