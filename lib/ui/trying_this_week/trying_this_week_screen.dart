import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_notes_update_sheet.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

import 'bloc/trying_this_week_cubit.dart';
import 'bloc/trying_this_week_state.dart';

class TryingThisWeekScreen extends StatefulWidget {
  const TryingThisWeekScreen({super.key});

  @override
  State<TryingThisWeekScreen> createState() => _TryingThisWeekScreenState();
}

class _TryingThisWeekScreenState extends State<TryingThisWeekScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TryingThisWeekCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TryingThisWeekCubit, TryingThisWeekState>(
      listener: (BuildContext context, TryingThisWeekState state) {
        final ApiResultStatus fetchStatus = state.fetchStatus;
        if (fetchStatus is Loging) {
          EasyLoading.show();
        } else if (fetchStatus is Data) {
          EasyLoading.dismiss();
        } else if (fetchStatus is Error) {
          EasyLoading.dismiss();
          showSnackBar(
            message: fetchStatus.error.toString().replaceAll('Exception: ', ''),
            type: SnackBarType.ERROR,
          );
        }

        final ApiResultStatus finishStatus = state.finishStatus;
        if (finishStatus is Loging) {
          EasyLoading.show();
        } else if (finishStatus is Data) {
          EasyLoading.dismiss();
          showSnackBar(
            message: LocaleKeys.journeyExperimentFinishedEarly.tr(),
            type: SnackBarType.SUCCESS,
          );
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        } else if (finishStatus is Error) {
          EasyLoading.dismiss();
          showSnackBar(
            message:
                finishStatus.error.toString().replaceAll('Exception: ', ''),
            type: SnackBarType.ERROR,
          );
        }
      },
      builder: (BuildContext context, TryingThisWeekState state) {
        if (!state.hasExperiment) {
          return Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.spaceH,
                    InkWell(
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
                    const Spacer(),
                    LocaleKeys.journeyNoActiveExperimentTitle.tr().appText(
                      fontSize: 28.sp,
                      color: greyColor9,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    12.spaceH,
                    LocaleKeys.journeyNoActiveExperimentBody.tr().appText(
                      fontSize: 14.sp,
                      color: greyColor,
                      textAlign: TextAlign.start,
                      height: 1.4,
                    ),
                    24.spaceH,
                    AppButton(
                      title: LocaleKeys.journeyBackToJourney.tr(),
                      onTap: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        }

        final String changeTitle = state.experiment?.changeTitle ?? '';
        final String observeTarget = state.experiment?.observeTarget ?? '';
        final DateTime reviewDate =
            state.experiment?.reviewDate ?? DateTime.now();
        final String reviewDateStr = DateFormat(
          'EEEE d MMMM',
        ).format(reviewDate);

        final int currentDay = state.currentDay;
        final int totalDays = state.totalDays <= 0 ? 7 : state.totalDays;
        final double progress = (currentDay / totalDays).clamp(0.0, 1.0);

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
                          "What we're trying this week".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                            height: 1.2,
                          ),
                          24.spaceH,
                          _buildChangeCard(
                            changeTitle,
                            currentDay,
                            totalDays,
                            progress,
                          ),
                          16.spaceH,
                          _buildObserveCard(observeTarget),
                          16.spaceH,
                          _buildReviewDateCard(reviewDateStr),
                          180.spaceH,
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

  Widget _buildChangeCard(
    String changeTitle,
    int currentDay,
    int totalDays,
    double progress,
  ) {
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
            chipTitle: 'The change being tried',
            iconData: Icons.info,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          changeTitle.appText(
            fontSize: 20.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          12.spaceH,
          () {
            final int daysAgo = currentDay - 1;
            final String startLabel = daysAgo <= 0
                ? 'Started today'
                : daysAgo == 1
                ? 'Started 1 day ago'
                : 'Started $daysAgo days ago';
            return '$startLabel · day $currentDay of $totalDays'.appText(
              fontSize: 12.sp,
              color: greyColor,
              textAlign: TextAlign.start,
            );
          }(),
          16.spaceH,
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: orangeLightColor,
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              minHeight: 6.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObserveCard(String observeTarget) {
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
            chipTitle: 'What to observe',
            iconData: Icons.info,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          observeTarget.appText(
            fontSize: 20.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          12.spaceH,
          "You don't need to log anything extra your usual check-ins are enough."
              .appText(
                fontSize: 12.sp,
                color: greyColor,
                textAlign: TextAlign.start,
                height: 1.4,
              ),
        ],
      ),
    );
  }

  Widget _buildReviewDateCard(String reviewDateStr) {
    return CommonInfoCard(
      chipTitle: 'Review date',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: reviewDateStr,
      titleFontSize: 20.sp,
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
            top: 40.h,
            bottom: 32.h,
            left: 20.w,
            right: 20.w,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFEF8F4).withValues(alpha: 0.0),
                const Color(0xFFFEF8F4),
                const Color(0xFFFEF8F4),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                title: 'Add update',
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    builder: (BuildContext ctx) => const AddNotesUpdateSheet(),
                  );
                },
              ),
              12.spaceH,
              GestureDetector(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierColor: Colors.black.withValues(alpha: 0.4),
                    builder: (BuildContext ctx) => Dialog(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56.w,
                                height: 56.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF0E5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.flag_outlined,
                                  color: primaryColor,
                                  size: 28.sp,
                                ),
                              ),
                              18.spaceH,
                              'Finish early?'.appText(
                                fontSize: 22.sp,
                                color: greyColor9,
                                fraunces: true,
                              ),
                              10.spaceH,
                              'Are you sure you want to end this recommendation early?'
                                  .appText(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                    height: 1.4,
                                  ),
                              24.spaceH,
                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      height: 48.h,
                                      padding: EdgeInsets.zero,
                                      title: 'Cancel',
                                      backgroundColor: const Color(0xFFF8F5F2),
                                      borderColor: const Color(0xFFE9E2DC),
                                      textColor: greyColor9,
                                      onTap: () => Navigator.pop(ctx),
                                    ),
                                  ),
                                  12.spaceW,
                                  Expanded(
                                    child: AppButton(
                                      height: 48.h,
                                      padding: EdgeInsets.zero,
                                      title: 'Finish',
                                      backgroundColor: primaryColor,
                                      borderColor: primaryColor,
                                      textColor: Colors.white,
                                      onTap: () async {
                                        Navigator.pop(ctx);
                                        await context
                                            .read<TryingThisWeekCubit>()
                                            .finishEarly(
                                              'Ended early by parent',
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: 'Finish early'.appText(
                    fontSize: 16.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
