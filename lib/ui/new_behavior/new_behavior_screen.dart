import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/behaviour_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/extra_methods.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../generated/locale_keys.g.dart';
import 'bloc/new_behavior_cubit.dart';
import 'bloc/new_behavior_state.dart';

class NewBehaviorScreen extends StatefulWidget {
  const NewBehaviorScreen({super.key});

  @override
  State<NewBehaviorScreen> createState() => _NewBehaviorScreenState();
}

class _NewBehaviorScreenState extends State<NewBehaviorScreen> {
  final TextEditingController _tellUsMoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewBehaviorCubit>().init();
    });
  }

  @override
  void dispose() {
    _tellUsMoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewBehaviorCubit, NewBehaviorState>(
      listener: (BuildContext context, NewBehaviorState state) {
        state.addBehaviourApiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (dynamic data) {
            EasyLoading.dismiss();
            showSnackBar(
              message: LocaleKeys.behaviourLogged.tr(),
              type: SnackBarType.SUCCESS,
            );
            UserRepo.instance.updateUserStreak();
          },
          error: (dynamic error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll("Exception: ", ""),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, NewBehaviorState state) {
        if (_tellUsMoreController.text != state.tellUsMoreText) {
          _tellUsMoreController.value = _tellUsMoreController.value.copyWith(
            text: state.tellUsMoreText,
            selection: TextSelection.collapsed(
              offset: state.tellUsMoreText.length,
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: Stack(
            children: <Widget>[
              _buildAuroraBackground(),
              _buildGlassOverlay(),
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      sliver: SliverToBoxAdapter(child: _topBar()),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _heroCard(state),
                            18.h.spaceH,
                            _logCard(state),
                            16.h.spaceH,
                            _insightCard(state),
                            18.h.spaceH,
                            _momentsSection(state),
                            90.h.spaceH,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuroraBackground() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -110.h,
          left: -60.w,
          child: Container(
            width: 360.w,
            height: 360.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF894BCD).withValues(alpha: 0.18),
            ),
          ),
        ),
        Positioned(
          top: 170.h,
          right: -120.w,
          child: Container(
            width: 290.w,
            height: 290.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF66C4).withValues(alpha: 0.10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
        child: Container(color: Colors.white.withValues(alpha: 0.35)),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: <Widget>[
        BaseButton(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.3),
            ),
            child: Icon(
              LucideIcons.chevronLeft,
              color: Colors.black87,
              size: 22.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _heroCard(NewBehaviorState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF894BCD), Color(0xFFB185DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF894BCD).withValues(alpha: 0.24),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(LucideIcons.activity, color: Colors.white, size: 22.sp),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                "${LocaleKeys.logNewBehaviorFor.tr()} ${state.userModel?.childName ?? ''}"
                    .appText(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                    ),
                4.h.spaceH,
                "Capture moments quickly to discover behavior patterns."
                    .appText(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logCard(NewBehaviorState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _selectBehavior(state),
              12.h.spaceH,
              _tellUsMore(state),
              14.h.spaceH,
              _logBehaviorButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _insightCard(NewBehaviorState state) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LocaleKeys.lovingBrainInsight.tr().appText(
            fontWeight: FontWeight.w800,
            fontSize: 16.sp,
          ),
          8.h.spaceH,
          "Get a personalized insight based on ${state.userModel?.parentName ?? ''}'s recent logged behaviors."
              .appText(
                textAlign: TextAlign.start,
                fontSize: 12.sp,
                color: Colors.grey.shade700,
              ),
          12.h.spaceH,
          BaseButton(
            onTap: () {},
            child: Container(
              height: 46.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[primaryColor, Color(0xFFB185DB)],
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child:
                    "${LocaleKeys.getAIInsightFor.tr()} ${state.userModel?.childName ?? ''}"
                        .appText(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.sp,
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectBehavior(NewBehaviorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LocaleKeys.whatHappened.tr().appText(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        8.h.spaceH,
        AppDropDownButton(
          offset: Offset(0, 50.h),
          dropDownWidget: (Function close) {
            return Container(
              height: 190.h,
              decoration: BoxDecoration(
                color: aiQuestionCardColor2,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: ListView.builder(
                itemCount: state.behaviourCategoryList.length,
                padding: EdgeInsets.symmetric(vertical: 4.h),
                itemBuilder: (BuildContext context, int index) {
                  final behaviour = state.behaviourCategoryList[index];
                  return BaseButton(
                    onTap: () {
                      close.call();
                      context.read<NewBehaviorCubit>().changeProps(
                        selectedBehaviour: behaviour.behaviour,
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: (behaviour.behaviour ?? "").appText(
                                  fontSize: 13.sp,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index != state.behaviourCategoryList.length - 1)
                          Divider(color: Colors.grey.shade300, height: 1),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: aiQuestionCardColor2,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: <Widget>[
                12.w.spaceW,
                Expanded(
                  child:
                      (state.selectedBehaviour.isNotEmpty
                              ? state.selectedBehaviour
                              : LocaleKeys.selectBehavior.tr())
                          .appText(
                            fontSize: 12.sp,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w700,
                            color: state.selectedBehaviour.isNotEmpty
                                ? Colors.black
                                : Colors.grey.shade500,
                          ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded, size: 22.sp),
                10.w.spaceW,
              ],
            ),
          ),
        ),
        if (state.behaviourError.isNotEmpty) ...<Widget>[
          6.h.spaceH,
          state.behaviourError.appText(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ],
      ],
    );
  }

  Widget _tellUsMore(NewBehaviorState state) {
    return AppTextField(
      controller: _tellUsMoreController,
      fillColor: aiQuestionCardColor2,
      title: LocaleKeys.tellUsMore.tr(),
      hint:
          "Describe what happened, when and where. How did ${state.userModel?.childName ?? ''} feel?",
      maxLines: 4,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      onChanged: (String value) {
        context.read<NewBehaviorCubit>().changeProps(tellUsMoreText: value);
      },
    );
  }

  Widget _logBehaviorButton() {
    return BaseButton(
      onTap: () => context.read<NewBehaviorCubit>().logBehaviour(),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF5271FF), Color(0xFF6C8BFF)],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF5271FF).withValues(alpha: 0.24),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(LucideIcons.camera, color: Colors.white, size: 18.sp),
            8.w.spaceW,
            LocaleKeys.logBehavior.tr().appText(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _momentsSection(NewBehaviorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        "${state.userModel?.childName ?? ''}'s ${LocaleKeys.recentMoments.tr()}"
            .appText(
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
              color: Colors.black87,
            ),
        10.h.spaceH,
        if (state.behaviourList.isEmpty) ...<Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Center(
              child: "No behavior logs yet".appText(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ] else ...<Widget>[
          ListView.builder(
            itemCount: state.behaviourList.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final BehaviourModel behaviour = state.behaviourList[index];
              return _momentItem(
                title: behaviour.behaviour.toString(),
                description: behaviour.note ?? "",
                date: "Date: ${getStringDate(behaviour.timeStamp!)}",
                time: getStringTime(behaviour.timeStamp!),
              ).appPadding(bottom: 10);
            },
          ),
        ],
      ],
    );
  }

  Widget _momentItem({
    required String title,
    required String description,
    required String date,
    required String time,
  }) {
    final String firstChar = title.characters.isNotEmpty
        ? title.characters.first
        : "";
    final String restText = title.characters.isNotEmpty
        ? title.characters.skip(1).toString()
        : "";

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[yellowButtonStartColor, yellowButtonEndColor],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: firstChar.appText(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: restText.appText(
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                    time.appText(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),
                4.h.spaceH,
                description.appText(
                  textAlign: TextAlign.start,
                  fontSize: 11.sp,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.grey.shade700,
                ),
                4.h.spaceH,
                date.appText(
                  textAlign: TextAlign.start,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
