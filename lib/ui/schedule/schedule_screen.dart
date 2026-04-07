/// Schedule screen: two tabs – [Daily Routine] and [Co‑parenting Schedule].
///
/// - Daily routine: shows child's routines from Firestore; add/delete; navigates
///   to [DailyRoutineScreen] to add an activity.
/// - Co‑parenting: shows shared events (created by or assigned to user); add,
///   link co‑parent, view detail / approval / propose change; delete if creator.
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../model/routine_model.dart';
import '../../model/shared_event_model.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../add_shared_event/add_shared_event_screen.dart';
import '../daily_routine/daily_routine_screen.dart';
import '../event_approval/event_approval_screen.dart';
import '../event_detail/event_detail_screen.dart';
import '../link_co_parent/link_co_parent_screen.dart';
import '../propose_change/propose_change_screen.dart';
import '../widget/app_dialogs.dart';
import 'bloc/schedule_cubit.dart';
import 'bloc/schedule_state.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleCubit, ScheduleState>(
      listener: (context, state) {
        state.deleteRoutineApiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: 'routineRemoved'.tr(),
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
        state.deleteSharedEventApiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: 'successMessage'.tr(),
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              // 1. Foundation Image
              Positioned.fill(
                child: Assets.images.imgScheduleBg.image(
                  fit: BoxFit.cover,
                  width: context.width,
                  height: context.height,
                ),
              ),
              // 2. Glassmorphic Blur Effect covering the screen
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    color: scheduleBgColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
              // 3. Main Content
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    20.h.spaceH,
                    _buildHeader(),
                    24.h.spaceH,
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.r),
                            topRight: Radius.circular(32.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 30,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.r),
                            topRight: Radius.circular(32.r),
                          ),
                          child: Column(
                            children: [
                              24.h.spaceH,
                              _tabBar(context, state),
                              16.h.spaceH,
                              Expanded(
                                child: IndexedStack(
                                  index: state.tabIndex,
                                  children: [
                                    _dailyRoutineContent(context, state),
                                    _coParentingContent(context, state),
                                  ],
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_month_rounded, 
              color: Colors.white, 
              size: 26.sp,
            ),
          ),
          12.w.spaceW,
          LocaleKeys.schedule.tr().appText(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ],
      ),
    );
  }

  Widget _tabBar(BuildContext context, ScheduleState state) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      height: 52.h,
      decoration: BoxDecoration(
        color: greyColor3.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _tabItem(
              label: LocaleKeys.dailyRoutine.tr(),
              isSelected: state.tabIndex == 0,
              onTap: () =>
                  context.read<ScheduleCubit>().changeProps(tabIndex: 0),
            ),
          ),
          Expanded(
            child: _tabItem(
              label: LocaleKeys.coParentingSchedule.tr(),
              isSelected: state.tabIndex == 1,
              onTap: () =>
                  context.read<ScheduleCubit>().changeProps(tabIndex: 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required String label,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected ? null : Colors.transparent,
          gradient: isSelected
              ? const LinearGradient(
                  colors: [scheduleButtonColor1, scheduleButtonColor2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: scheduleButtonColor1.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : greyColor1,
          ),
        ),
      ),
    );
  }

  Widget _dailyRoutineContent(BuildContext context, ScheduleState state) {
    final List<RoutineModel> routines =
        state.childModel?.routinesList ?? const [];
    final String childName =
        state.childModel?.childName ?? state.userModel?.childName ?? '';
    final bool hasDefaultChild = state.childModel != null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (childName.isNotEmpty)
            Row(
              children: [
                Icon(Icons.child_care_rounded, color: blueTextColor, size: 20.sp),
                8.w.spaceW,
                "$childName's ${LocaleKeys.dailyRoutine.tr()}".appText(
                  color: blueTextColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ],
            ),
          if (childName.isNotEmpty) 16.h.spaceH,
          if (routines.isEmpty)
            _emptyState(
              title: hasDefaultChild
                  ? 'noRoutinesYet'.tr()
                  : 'selectDefaultChildForRoutine'.tr(),
              subtitle: hasDefaultChild
                  ? 'addFirstRoutine'.tr()
                  : 'pleaseSelectChild'.tr(),
              icon: Icons.schedule_rounded,
            )
          else
            ...routines.asMap().entries.map((entry) {
              final RoutineModel routine = entry.value;
              return _routineItem(
                schedule: getStringTime(routine.timeStamp),
                label: routine.description ?? '',
                showProposeChange: false,
                onTap: () {}, // Navigate to edit routine if needed
                onDeleteIconTap: () {
                  _showDeleteRoutineDialog(
                    onDelete: () {
                      Navigator.pop(context);
                      context.read<ScheduleCubit>().deleteRoutine(routine);
                    },
                  );
                },
              );
            }),
          16.h.spaceH,
          _scheduleButton(
            text: "+ ${LocaleKeys.addActivity.tr()}",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const DailyRoutineScreen(),
                ),
              );
            },
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _coParentingContent(BuildContext context, ScheduleState state) {
    final List<SharedEventModel> events = state.sharedEventList;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_alt_rounded, color: blueTextColor, size: 20.sp),
              8.w.spaceW,
              LocaleKeys.coParentingCalendar.tr().appText(
                color: blueTextColor,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ],
          ),
          16.h.spaceH,
          if (events.isEmpty)
            _emptyState(
              title: 'noSharedEventsYet'.tr(),
              subtitle: 'addFirstSharedEvent'.tr(),
              icon: Icons.event_note_rounded,
            )
          else
            ...events.map((SharedEventModel sharedEvent) {
              final bool isCreator =
                  sharedEvent.createdBy == state.userModel?.uid;
              final bool isAssigned = sharedEvent.assignedTo
                      ?.any((String id) => id == state.userModel?.uid) ??
                  false;
              final bool canView = isCreator ||
                  (isAssigned &&
                      (sharedEvent.status == 'APPROVED' ||
                          sharedEvent.status == 'NONE'));
              final bool needsApproval = isAssigned &&
                  (sharedEvent.requiredApproval == true) &&
                  sharedEvent.status == 'REQUESTED';

              return _routineItem(
                schedule: coParentScheduleTime(
                  sharedEvent.date ?? sharedEvent.startTime,
                ),
                label: sharedEvent.title ?? '',
                status: sharedEvent.status,
                showProposeChange: true,
                showDeleteIcon: isCreator,
                onTap: () {
                  if (canView) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            EventDetailScreen(sharedEvent: sharedEvent),
                      ),
                    );
                  } else if (needsApproval) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            EventApprovalScreen(sharedEvent: sharedEvent),
                      ),
                    );
                  }
                },
                proposeChangeButtonTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          ProposeChangeScreen(sharedEvent: sharedEvent),
                    ),
                  );
                },
                onDeleteIconTap: () {
                  _showDeleteSharedEventDialog(
                    onDelete: () {
                      Navigator.pop(context);
                      context
                          .read<ScheduleCubit>()
                          .deleteSharedEvent(sharedEvent);
                    },
                  );
                },
              );
            }),
          16.h.spaceH,
          _scheduleButton(
            text: "+ ${LocaleKeys.addSharedEvent.tr()}",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AddSharedEventScreen(),
                ),
              );
            },
            isPrimary: true,
          ),
          12.h.spaceH,
          _scheduleButton(
            text: LocaleKeys.linkCoParent.tr(),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LinkCoParentScreen(),
                ),
              );
            },
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _emptyState({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 56.sp,
              color: primaryColor.withValues(alpha: 0.6),
            ),
          ),
          20.h.spaceH,
          title.appText(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: blackTextColor,
          ),
          12.h.spaceH,
          subtitle.appText(
            fontSize: 14,
            height: 1.5,
            color: greyColor1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _routineItem({
    required String schedule,
    required String label,
    required VoidCallback? onTap,
    required VoidCallback? onDeleteIconTap,
    VoidCallback? proposeChangeButtonTap,
    String? status,
    bool showProposeChange = false,
    bool showDeleteIcon = true,
  }) {
    final bool hasStatus = (status ?? '').isNotEmpty && status != 'NONE';
    
    // Choose accent color based on status
    Color leftAccentColor = primaryColor;
    if (status == 'APPROVED') {
       leftAccentColor = const Color(0xFF06CB5B); // explicit vibrant green
    } else if (status == 'REQUESTED') {
       leftAccentColor = orangeColor; // vibrant orange
    } else if (showProposeChange) {
       leftAccentColor = blueColor1; 
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: BaseButton(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Premium Left Accent Line
                Container(
                  width: 6.w,
                  decoration: BoxDecoration(
                    color: leftAccentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Soft rounded icon background
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: leftAccentColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Assets.icons.icCalenderIcon2.image(
                            height: 24.h,
                            width: 24.w,
                            color: leftAccentColor,
                          ),
                        ),
                        16.w.spaceW,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              schedule.appText(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: blueColor2, 
                              ),
                              4.h.spaceH,
                              label.appText(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: blackTextColor,
                                height: 1.3,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Actions & Statuses
                        if (hasStatus || showProposeChange || showDeleteIcon)
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (hasStatus) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: leftAccentColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(color: leftAccentColor, width: 1.5),
                                    ),
                                    child: (status ?? '').appText(
                                      fontSize: 10.sp, 
                                      fontWeight: FontWeight.w800,
                                      color: leftAccentColor
                                    ),
                                  ),
                                  8.h.spaceH,
                                ],
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (showProposeChange)
                                      BaseButton(
                                        onTap: proposeChangeButtonTap,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: blueColor1.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: "${LocaleKeys.proposeChange.tr()} >".appText(
                                            fontSize: 10.sp,
                                            color: blueColor1,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    if (showDeleteIcon) ...[
                                      if (showProposeChange) 8.w.spaceW,
                                      BaseButton(
                                        onTap: onDeleteIconTap,
                                        child: Container(
                                          padding: EdgeInsets.all(6.w),
                                          decoration: BoxDecoration(
                                            color: redColor.withValues(alpha: 0.08),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            size: 20.sp,
                                            color: redColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scheduleButton({
    required String text,
    required VoidCallback? onTap,
    bool isPrimary = true,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? null : Colors.white,
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [primaryColor, blueColor2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          border: isPrimary ? null : Border.all(color: greyColor.withValues(alpha: 0.5), width: 2),
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: isPrimary 
            ? [
                BoxShadow(
                  color: blueColor2.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ] 
            : null,
        ),
        child: text.appText(
          color: isPrimary ? Colors.white : blackTextColor,
          fontWeight: FontWeight.w800,
          fontSize: 15.sp,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showDeleteRoutineDialog({required VoidCallback? onDelete}) {
    _showDeleteConfirmDialog(
      message: LocaleKeys.areYouSureYouWantToRemoveRoutine.tr(),
      onDelete: onDelete,
    );
  }

  void _showDeleteSharedEventDialog({required VoidCallback? onDelete}) {
    _showDeleteConfirmDialog(
      message: 'areYouSureYouWantToRemoveSharedEvent'.tr(),
      onDelete: onDelete,
    );
  }

  void _showDeleteConfirmDialog({
    required String message,
    required VoidCallback? onDelete,
  }) {
    showAppDialog(
      child: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                )
              ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: redColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: redColor,
                    size: 32.sp,
                  ),
                ),
                20.h.spaceH,
                "${LocaleKeys.delete.tr()}?".appText(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: blackTextColor,
                ),
                16.h.spaceH,
                message.appText(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: greyColor1,
                  textAlign: TextAlign.center,
                  height: 1.4,
                ),
                32.h.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: greyColor3.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          alignment: Alignment.center,
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w800,
                                color: blackTextColor,
                                fontSize: 15.sp,
                              ),
                        ),
                      ),
                    ),
                    16.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        onTap: onDelete,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: redColor,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: redColor.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ]
                          ),
                          alignment: Alignment.center,
                          child: LocaleKeys.delete
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 15.sp,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

