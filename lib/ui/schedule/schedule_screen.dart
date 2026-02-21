/// Schedule screen: two tabs – [Daily Routine] and [Co‑parenting Schedule].
///
/// - Daily routine: shows child's routines from Firestore; add/delete; navigates
///   to [DailyRoutineScreen] to add an activity.
/// - Co‑parenting: shows shared events (created by or assigned to user); add,
///   link co‑parent, view detail / approval / propose change; delete if creator.
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
        // Delete routine / shared event: show loading and result snackbar
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
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Assets.images.imgScheduleBg.image(
                    fit: BoxFit.cover,
                    width: context.width,
                    height: context.height,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    24.h.spaceH,
                    LocaleKeys.schedule.tr().appText(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    16.h.spaceH,
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: scheduleBgColor,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: Column(
                            children: [
                              12.h.spaceH,
                              _tabBar(context, state),
                              8.h.spaceH,
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
                    16.h.spaceH,
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tabBar(BuildContext context, ScheduleState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
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
          8.w.spaceW,
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
    return BaseButton(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48.h,
        decoration: BoxDecoration(
          color: isSelected ? null : Colors.white,
          gradient: isSelected
              ? const LinearGradient(
                  colors: [scheduleButtonColor1, scheduleButtonColor2],
                )
              : null,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: scheduleButtonColor1.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : blackTextColor,
          ),
        ),
      ),
    );
  }

  /// Daily routine tab: list of routines for default child, add activity, delete.
  Widget _dailyRoutineContent(BuildContext context, ScheduleState state) {
    final List<RoutineModel> routines =
        state.childModel?.routinesList ?? const [];
    final String childName =
        state.childModel?.childName ?? state.userModel?.childName ?? '';
    final bool hasDefaultChild = state.childModel != null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (childName.isNotEmpty)
            "$childName's ${LocaleKeys.dailyRoutine.tr()}"
                .appText(
                  color: blueTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
          12.h.spaceH,
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
                onTap: () {}, // TODO: navigate to edit routine if screen supports it
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
          ),
        ],
      ),
    );
  }

  /// Co‑parenting tab: shared events (creator or assigned), add/link, view/approve/delete.
  Widget _coParentingContent(BuildContext context, ScheduleState state) {
    final List<SharedEventModel> events = state.sharedEventList;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocaleKeys.coParentingCalendar
              .tr()
              .appText(
                color: blueTextColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
          12.h.spaceH,
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
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48.sp,
            color: greyColor2,
          ),
          16.h.spaceH,
          title.appText(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: blackTextColor,
          ),
          8.h.spaceH,
          subtitle.appText(
            fontSize: 13,
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
    final bool hasStatus =
        (status ?? '').isNotEmpty && status != 'NONE';
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: BaseButton(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Assets.icons.icCalenderIcon2.image(
                height: 28.h,
                width: 28.w,
              ),
              14.w.spaceW,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    schedule.appText(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: blackTextColor,
                    ),
                    4.h.spaceH,
                    label.appText(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: blackTextColor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (hasStatus || showProposeChange || showDeleteIcon) ...[
                if (hasStatus)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: status == 'APPROVED'
                          ? approvedColor
                          : status == 'REQUESTED'
                              ? pendingColor
                              : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: (status ?? '')
                        .appText(fontSize: 10.sp, fontWeight: FontWeight.w800),
                  ),
                if (showProposeChange) ...[
                  8.w.spaceW,
                  BaseButton(
                    onTap: proposeChangeButtonTap,
                    child: "${LocaleKeys.proposeChange.tr()} >"
                        .appText(
                          fontSize: 10.sp,
                          color: blueColor1,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
                if (showDeleteIcon) ...[
                  4.w.spaceW,
                  BaseButton(
                    onTap: onDeleteIconTap,
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 22.sp,
                      color: redColor,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _scheduleButton({
    required String text,
    required VoidCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: blueColor2.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: text.appText(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 14.sp,
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
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                "${LocaleKeys.delete.tr()}?".appText(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: blackTextColor,
                ),
                16.h.spaceH,
                message.appText(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: greyColor1,
                  textAlign: TextAlign.center,
                ),
                28.h.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: greyColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          alignment: Alignment.center,
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                        ),
                      ),
                    ),
                    12.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        onTap: onDelete,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: redColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          alignment: Alignment.center,
                          child: LocaleKeys.delete
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 14.sp,
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
