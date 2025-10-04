import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../widget/base_button.dart';
import 'bloc/new_behavior_cubit.dart';
import 'bloc/new_behavior_state.dart';

class NewBehaviorScreen extends StatefulWidget {
  const NewBehaviorScreen({super.key});

  @override
  State<NewBehaviorScreen> createState() => _NewBehaviorScreenState();
}

class _NewBehaviorScreenState extends State<NewBehaviorScreen> {
  TextEditingController tellUsMoreController = TextEditingController();

  @override
  void initState() {
    context.read<NewBehaviorCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewBehaviorCubit, NewBehaviorState>(
      builder: (context, state) {
        if (tellUsMoreController.text != state.tellUsMoreText) {
          tellUsMoreController.value = tellUsMoreController.value.copyWith(
            text: state.tellUsMoreText ?? '',
            selection: tellUsMoreController.selection,
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Assets.images.icNewBehaviorBg.image(
                  height: context.height,
                  width: context.width,
                ),
                Column(
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
                                child:
                                    "${LocaleKeys.logNewBehaviorFor.tr()} ${state.userModel?.childName ?? ""}"
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
                          _selectBehavior(state),
                          12.spaceH,
                          _tellUsMore(state),
                          12.spaceH,
                          _logBehaviorButton(),
                          12.spaceH,
                        ],
                      ).appPadding(left: 30, right: 30),
                    ).appPadding(left: 30, right: 30),
                    20.spaceH,
                    _lovingBrainInsight(state),
                    20.spaceH,
                    _childRecentMoments(state),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        state.addBehaviourApiResultStatus.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            showSnackBar(
              message: LocaleKeys.behaviourLogged.tr(),
              type: SnackBarType.SUCCESS,
            );
            EasyLoading.dismiss();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
        );
      },
    );
  }

  Widget _lovingBrainInsight(NewBehaviorState state) {
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
          "Get a personalized insight based on ${state.userModel?.parentName}'s recent logged behaviors."
              .appText(textAlign: TextAlign.start, fontSize: 14)
              .appPadding(left: 20, right: 20),
          15.spaceH,
          _getAIInsightForChildButton(state),
          15.spaceH,
        ],
      ),
    ).appPadding(left: 30, right: 30);
  }

  Widget _getAIInsightForChildButton(NewBehaviorState state) {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "${LocaleKeys.getAIInsightFor.tr()} ${state.userModel?.childName}".appText(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              maxLines: 1
            ),
          ],
        ).appPadding(top: 8, bottom: 8),
      ),
      onTap: () {},
    ).appPadding(left: 30, right: 30);
  }

  Widget _selectBehavior(NewBehaviorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.whatHappened.tr().appText(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        8.spaceH,
        AppDropDownButton(
          offset: Offset(0, 50),
          dropDownWidget: (close) {
            return Container(
              height: 190.h,
              decoration: BoxDecoration(
                color: aiQuestionCardColor2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: state.behaviourCategoryList.length,
                padding: EdgeInsets.only(top: 4, bottom: 4),
                itemBuilder: (context, index) {
                  var behaviour = state.behaviourCategoryList[index];
                  return BaseButton(
                    onTap: () {
                      close.call();
                      context.read<NewBehaviorCubit>().changeProps(
                        selectedBehaviour: behaviour.behaviour,
                      );
                    },
                    child: Column(
                      children: [
                        4.spaceH,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            12.spaceW,
                            Container(
                              child: behaviour.behaviour?.appText(
                                fontSize: 14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            12.spaceW,
                          ],
                        ),
                        4.spaceH,
                        if (index != state.behaviourList.length - 1) ...[
                          Divider(color: Colors.grey.shade300),
                        ],
                      ],
                    ),
                  );
                },
              ),
            );
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: aiQuestionCardColor2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                12.spaceW,
                Expanded(
                  child:
                      (state.selectedBehaviour.isNotEmpty
                              ? state.selectedBehaviour
                              : (LocaleKeys.selectBehavior.tr()))
                          .appText(
                            fontSize: 12,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w600,
                            color: state.selectedBehaviour.isNotEmpty
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                ),
                12.spaceW,
                Icon(Icons.arrow_drop_down),
                12.spaceW,
              ],
            ),
          ),
        ),
        if ((state.behaviourError ?? "").isNotEmpty) ...[
          4.spaceH,
          Row(
            children: [
              (state.behaviourError ?? "").appText(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _logBehaviorButton() {
    return BaseButton(
      child: Container(
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
      ),
      onTap: () {
        context.read<NewBehaviorCubit>().logBehaviour();
      },
    );
  }

  Widget _childRecentMoments(NewBehaviorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(),
        "${state.userModel?.childName}’s ${LocaleKeys.recentMoments.tr()}".appText(fontWeight: FontWeight.w700),
        10.spaceH,
        ListView.builder(
          itemCount: state.behaviourList.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 50.h),
          itemBuilder: (context, index) {
            var behaviour = state.behaviourList[index];
            return _momentItem(
              title: behaviour.behaviour.toString(),
              description: behaviour.note ?? "",
              date: 'Date: ${getStringDate(behaviour.timeStamp!)}',
              time: getStringTime(behaviour.timeStamp!),
              icon: Assets.icons.icTantrumIcon,
            ).appPadding(top: 10);
          },
        ),
        /*_momentItem(
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
        20.spaceH,*/
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
      height: 110,
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
          icon.image(width: 25),
          20.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: title.appText(
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    time.appText(fontSize: 10, fontWeight: FontWeight.w500),
                  ],
                ),
                description.appText(
                  textAlign: TextAlign.start,
                  fontSize: 12,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                date.appText(
                  textAlign: TextAlign.start,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),

          20.spaceW,
        ],
      ).padding(top: 8, bottom: 8),
    );
  }

  Widget _tellUsMore(NewBehaviorState state) {
    return AppTextField(
      controller: tellUsMoreController,
      fillColor: aiQuestionCardColor2,
      title: LocaleKeys.tellUsMore.tr(),
      hint: "Describe what happened, when, and where and how ${state.userModel?.childName} Felt? ....",
      maxLines: 4,
        contentPadding : EdgeInsets.symmetric(horizontal: 12,vertical: 6),
      onChanged: (value) {
        context.read<NewBehaviorCubit>().changeProps(tellUsMoreText: value);
      },
    );
  }
}
