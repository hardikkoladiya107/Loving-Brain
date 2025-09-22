import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/activity_completed/activity_completed_screen.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../generated/locale_keys.g.dart';
import 'bloc/activity_cubit.dart';
import 'bloc/activity_state.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityCubit, ActivityState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.images.imgActivityBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(),
                250.spaceH,
                Assets.icons.icTimer.image(height: 60, width: 60),
                10.spaceH,
                "A simple, powerful hug to deepen connection and calm."
                    .appText(fontWeight: FontWeight.w700, fontSize: 14)
                    .appPadding(left: 20, right: 20),
                20.spaceH,
                "10 sec"
                    .appText(fontWeight: FontWeight.w900, fontSize: 24)
                    .appPadding(left: 20, right: 20),

                20.spaceH,
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(
                    Icons.pause_rounded,
                    size: 50,
                  ).appPadding(all: 10),
                ),
                8.spaceH,
                "The 20 Second Hug".appText(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                16.spaceH,
                _tipCard(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _tipCard() {
    return Container(
      height: 170.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgTipCardBg.path),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          20.spaceH,
          Row(
            children: [
              LocaleKeys.parentingTip.tr().appText(fontWeight: FontWeight.w800),
            ],
          ),
          4.spaceH,
          LocaleKeys.thisHugReleasesOxytocinTheBondingHormoneForBothOfYou
              .tr()
              .appText(
                textAlign: TextAlign.start,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
          20.spaceH,
          BaseButton(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LocaleKeys.markAsDone
                      .tr()
                      .appText(fontWeight: FontWeight.w500)
                      .appPadding(top: 5.h, bottom: 5.h),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ActivityCompletedScreen(),
                ),
              );
            },
          ).appPadding(left: 20, right: 20),
        ],
      ).appPadding(left: 20),
    ).appPadding(left: 30, right: 30);
  }
}
