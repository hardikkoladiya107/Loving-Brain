import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../widget/base_button.dart';
import 'bloc/new_behavior_cubit.dart';
import 'bloc/new_behavior_state.dart';

class NewBehaviorScreen extends StatefulWidget {
  const NewBehaviorScreen({super.key});

  @override
  State<NewBehaviorScreen> createState() => _NewBehaviorScreenState();
}

class _NewBehaviorScreenState extends State<NewBehaviorScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewBehaviorCubit, NewBehaviorState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.icNewBehaviorBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  60.spaceH,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          offset: Offset(1, 1),
                          blurRadius: 5,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.spaceH,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: "Log New Behavior for Rohan"
                                  .appText(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  )
                                  .appPadding(top: 16),
                            ),
                            Assets.icons.icLogNewBehavior.image(
                              height: 70,
                              width: 70,
                            ),
                          ],
                        ),
                        12.spaceH,
                        _selectBehavior(),
                        12.spaceH,
                        AppTextField(
                          fillColor: aiQuestionCardColor2,
                          title: LocaleKeys.tellUsMore.tr(),
                          hint: LocaleKeys
                              .describeWhatHappenedWhenAndWhereAndHowRohanFelt
                              .tr(),
                          maxLines: 4,
                        ),
                        12.spaceH,
                        _logBehaviorButton(),
                        12.spaceH,
                      ],
                    ).appPadding(left: 30, right: 30),
                  ).appPadding(left: 30, right: 30),
                  20.spaceH,
                  _lovingBrainInsight(),
                  20.spaceH,
                  _childRecentMoments(),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _lovingBrainInsight() {
    return Container(
      decoration: BoxDecoration(
        color: buttonColor2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LocaleKeys.lovingBrainInsight.tr().appText(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ],
          ).appPadding(left: 20, right: 20),
          8.spaceH,
          LocaleKeys.getPersonalizedRecentLoggedBehaviors
              .tr()
              .appText(textAlign: TextAlign.start, fontSize: 14)
              .appPadding(left: 20, right: 20),
          15.spaceH,
          _getAIInsightForChildButton(),
          15.spaceH,
        ],
      ),
    ).appPadding(left: 30, right: 30);
  }

  Widget _getAIInsightForChildButton() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Get AI Insight for Rohan".appText(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ],
        ).appPadding(top: 8, bottom: 8),
      ),
      onTap: () {},
    ).appPadding(left: 30, right: 30);
  }

  Widget _selectBehavior() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.whatHappened.tr().appText(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        8.spaceH,
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: aiQuestionCardColor2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              12.spaceW,
              Expanded(
                child: LocaleKeys.selectBehavior.tr().appText(
                  fontSize: 12,
                  textAlign: TextAlign.start,
                  color: Colors.grey.shade400,
                ),
              ),
              12.spaceW,
              Icon(Icons.arrow_drop_down),
              12.spaceW,
            ],
          ),
        ),
      ],
    );
  }

  Widget _logBehaviorButton() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: blueButtonColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.icCameraIcon.image(height: 18),
          10.spaceW,
          LocaleKeys.logBehavior.tr().appText(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 14,
          ),
        ],
      ),
    );
  }

  Widget _childRecentMoments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(),
        "Rohan’s Recent Moments".appText(fontWeight: FontWeight.w700),
        10.spaceH,
        _momentItem(
          title: 'Tantrum',
          description: 'Scremed for candy at grocery store',
          date: 'Date: 31/2/2025',
          time: '2 :30PM',
          icon: Assets.icons.icTantrumIcon,
        ),
        10.spaceH,
        _momentItem(
          title: 'Sleep Issues',
          description: 'Woke up crying twice last night',
          date: 'Date: 31/2/2025',
          time: '2 :30PM',
          icon: Assets.icons.icSleepIssue,
        ),
        10.spaceH,
        _momentItem(
          title: 'Positive Behavior',
          description: 'shared toys with sister without prompting !',
          date: 'Date: 31/2/2025',
          time: '2 :30PM',
          icon: Assets.icons.icPositiveBehavior,
        ),
        20.spaceH,
      ],
    ).appPadding(left: 30, right: 30);
  }

  Widget _momentItem({
    required String title,
    required String description,
    required String date,
    required String time,
    required AssetGenImage icon,
  }) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 10,
            decoration: BoxDecoration(
              color: Colors.pink,
              gradient: LinearGradient(
                colors: [
                  yellowButtonStartColor,
                  yellowButtonEndColor,
                  yellowButtonEndColor,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          20.spaceW,
          icon.image(width: 30),
          20.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title.appText(
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w600,
                ),
                description.appText(textAlign: TextAlign.start, fontSize: 12),
                date.appText(
                  textAlign: TextAlign.start,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Column(children: [10.spaceH, time.appText(fontSize: 12)]),
          20.spaceW,
        ],
      ),
    );
  }
}
