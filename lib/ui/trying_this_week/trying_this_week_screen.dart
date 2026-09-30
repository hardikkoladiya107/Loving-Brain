import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_notes_update_sheet.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

class TryingThisWeekScreen extends StatelessWidget {
  const TryingThisWeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          // Top Left Glow
          Positioned(
            left: -150,
            top: -150,
            child: Container(
              width: 400,
              height: 400,
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
                      "What we're trying this week".appText(
                        fontSize: 32.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                        height: 1.2,
                      ),
                      24.spaceH,
                      _buildChangeCard(),
                      16.spaceH,
                      _buildObserveCard(),
                      16.spaceH,
                      _buildReviewDateCard(),
                      160.spaceH,
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
  }

  Widget _buildChangeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "The change being tried",
            iconData: Icons.info,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          "An earlier, shorter\nafternoon nap".appText(
            fontSize: 20.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          12.spaceH,
          "Started 3 days ago · day 3 of 7".appText(
            fontSize: 12.sp,
            color: greyColor,
            textAlign: TextAlign.start,
          ),
          16.spaceH,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 3 / 7,
              backgroundColor: orangeLightColor,
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              minHeight: 6.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObserveCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "What to observe",
            iconData: Icons.info,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          "Evening mood and how easily\nbedtime goes".appText(
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

  Widget _buildReviewDateCard() {
    return CommonInfoCard(
      chipTitle: 'Review date',
      chipIcon: Icons.info,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: 'Saturday 25 May',
      titleFontSize: 20.sp,
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
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
              title: "Add update",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  builder: (context) => BlocProvider(
                    create: (_) => TodayCubit(),
                    child: const AddNotesUpdateSheet(),
                  ),
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
                          "Finish early?".appText(
                            fontSize: 22.sp,
                            color: greyColor9,
                            fraunces: true,
                          ),
                          10.spaceH,
                          "Are you sure you want to end this recommendation early?"
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
                                  onTap: () {
                                    Navigator.pop(ctx); // Close dialog
                                    Navigator.pop(
                                      context,
                                    ); // Close TryingThisWeekScreen
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
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
                  borderRadius: BorderRadius.circular(30),
                ),
                child: "Finish early".appText(
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
    );
  }
}
