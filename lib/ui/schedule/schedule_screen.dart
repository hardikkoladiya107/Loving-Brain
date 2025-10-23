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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ScheduleCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Assets.images.imgScheduleBg.image(
                      height: context.height,
                      width: context.width,
                      fit: BoxFit.cover,
                    ),
                    Container(height: context.height / 2),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(),
                    60.spaceH,
                    LocaleKeys.schedule.tr().appText(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    20.spaceH,
                    Container(
                      height: (context.height * 0.65).h,
                      width: (context.width - 60).w,
                      decoration: BoxDecoration(
                        color: scheduleBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          10.spaceH,
                          Row(
                            children: [
                              8.spaceW,
                              _tabItem(
                                label: LocaleKeys.dailyRoutine.tr(),
                                isSelected: state.tabIndex == 0,
                                onTap: () {
                                  context.read<ScheduleCubit>().changeProps(
                                    tabIndex: 0,
                                  );
                                },
                              ),
                              8.spaceW,
                              _tabItem(
                                label: LocaleKeys.coParentingSchedule.tr(),
                                isSelected: state.tabIndex == 1,
                                onTap: () {
                                  context.read<ScheduleCubit>().changeProps(
                                    tabIndex: 1,
                                  );
                                },
                              ),
                              8.spaceW,
                            ],
                          ),
                          Expanded(
                            child: IndexedStack(
                              index: state.tabIndex,
                              children: [
                                _dailyRoutine(state),
                                coParentingSchedule(state),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        state.deleteRoutineApiResultStatus.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
          },
          error: (error) {
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
            EasyLoading.dismiss();
          },
        );
      },
    );
  }

  Widget _tabItem({
    required String label,
    required bool isSelected,
    required GestureTapCallback? onTap,
  }) {
    return Expanded(
      child: BaseButton(
        onTap: onTap,
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: isSelected
                ? LinearGradient(
                    colors: [scheduleButtonColor1, scheduleButtonColor2],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              label.appText(fontWeight: FontWeight.w900, fontSize: 13),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dailyRoutine(ScheduleState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          10.spaceH,
          "${state.userModel?.childName}’s ${LocaleKeys.dailyRoutine.tr()}"
              .appText(
                color: blueTextColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              )
              .appPadding(left: 16),
          ListView.builder(
            itemCount: (state.childModel?.routinesList ?? []).length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              var routine = state.childModel?.routinesList?[index];
              return _routineItem(
                schedule: getStringTime(routine?.timeStamp),
                showProposeChange: false,
                label: routine?.description ?? "",
                onTap: () {},
                onDeleteIconTap: () {
                  if (routine != null) {
                    _showDeleteRoutineDialog(
                      onDelete: () {
                        Navigator.pop(context);
                        context.read<ScheduleCubit>().deleteRoutine(routine!);
                      },
                    );
                  }
                },
              );
            },
          ),
          16.spaceH,
          _scheduleButton(
            text: "+ ${LocaleKeys.addActivity.tr()}",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DailyRoutineScreen(),
                ),
              );
            },
          ),
          16.spaceH,
        ],
      ),
    );
  }

  Widget coParentingSchedule(ScheduleState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(),
        10.spaceH,
        LocaleKeys.coParentingColander
            .tr()
            .appText(
              color: blueTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            )
            .appPadding(left: 16),
        10.spaceH,

        ListView.builder(
          itemCount: state.sharedEventList.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var sharedEvent = state.sharedEventList[index];
            return _routineItem(
              schedule: coParentScheduleTime(sharedEvent.date),
              label: sharedEvent.title ?? "",
              status: sharedEvent.status,
              showProposeChange: true,
              onTap: () {
                if (sharedEvent.createdBy == state.userModel?.uid ||
                    ((sharedEvent.assignedTo?.any(
                              (element) => element == state.userModel?.uid,
                            ) ??
                            false) &&
                        (sharedEvent.status == "APPROVED" ||
                            sharedEvent.status == "NONE"))) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EventDetailScreen(sharedEvent: sharedEvent),
                    ),
                  );
                } else if ((sharedEvent.assignedTo?.any(
                          (element) => element == state.userModel?.uid,
                        ) ??
                        false) &&
                    sharedEvent.requiredApproval == true &&
                    sharedEvent.status == "REQUESTED") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EventApprovalScreen(sharedEvent: sharedEvent),
                    ),
                  );
                }
              },
              proposeChangeButtonTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ProposeChangeScreen(sharedEvent: sharedEvent),
                  ),
                );
              },
              showDeleteIcon: sharedEvent.createdBy == state.userModel?.uid,
              onDeleteIconTap: () {
                _showDeleteRoutineDialog(
                  onDelete: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),

        /* _routineItem(
          schedule: 'Aug 5 - 4:00 PM',
          label: 'School Pick-up (Priya)',
          status: LocaleKeys.approved.tr(),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EventDetailScreen(),
              ),
            );
          },
        ),
        _routineItem(
          schedule: 'Aug 5 - 4:00 PM',
          label: 'School Pick-up (Priya)',
          status: LocaleKeys.pending.tr(),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EventApprovalScreen(),
              ),
            );
          },
        ),*/
        16.spaceH,
        _scheduleButton(
          text: "+ ${LocaleKeys.addSharedEvent.tr()}",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddSharedEventScreen(),
              ),
            );
          },
        ),
        16.spaceH,
        _scheduleButton(
          text: "Link co-parent",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LinkCoParentScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _routineItem({
    required String schedule,
    required String label,
    required GestureTapCallback? onTap,
    required GestureTapCallback? onDeleteIconTap,
    GestureTapCallback? proposeChangeButtonTap,
    String? status,
    bool showProposeChange = false,
    bool showDeleteIcon = false,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            20.spaceW,
            Assets.icons.icCalenderIcon2.image(height: 30),
            16.spaceW,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  schedule.appText(fontSize: 12, fontWeight: FontWeight.w700),
                  2.spaceH,
                  label.appText(fontSize: 10, fontWeight: FontWeight.w600),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if ((status ?? "").isNotEmpty && status != "NONE")
                  Container(
                    decoration: BoxDecoration(
                      color: status == "APPROVED"
                          ? approvedColor
                          : status == "REQUESTED"
                          ? pendingColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: status!
                        .appText(fontSize: 9, fontWeight: FontWeight.w800)
                        .appPadding(left: 6, right: 6, top: 2, bottom: 2),
                  ),
                10.spaceH,
                if (showProposeChange)
                  BaseButton(
                    onTap: proposeChangeButtonTap,
                    child: "${LocaleKeys.proposeChange.tr()} >".appText(
                      fontSize: 9,
                      color: blueColor1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
            10.spaceW,
            if (showDeleteIcon)
              BaseButton(
                onTap: onDeleteIconTap,
                child: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red,
                ).appPadding(all: 5),
              ),
            10.spaceW,
          ],
        ),
      ),
    ).appPadding(left: 12, right: 12, top: 10);
  }

  Widget _scheduleButton({
    required String text,
    required GestureTapCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.appText(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ],
        ),
      ),
    ).appPadding(left: 15, right: 15);
  }

  void _showDeleteRoutineDialog({required GestureTapCallback? onDelete}) {
    showAppDialog(
      child: (context) {
        return Dialog(
          insetPadding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                20.h.spaceH,
                "${LocaleKeys.delete.tr()}?".appText(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                20.h.spaceH,
                LocaleKeys.areYouSureYouWantToRemoveRoutine.tr().appText(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                40.h.spaceH,
                Row(
                  children: [
                    20.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 10.h, bottom: 10.h),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    10.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        onTap: onDelete,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LocaleKeys.delete
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 10.h, bottom: 10.h),
                        ),
                      ),
                    ),
                    20.w.spaceW,
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
