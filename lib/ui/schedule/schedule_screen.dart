import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../add_shared_event/add_shared_event_screen.dart';
import '../daily_routine/daily_routine_screen.dart';
import '../link_co_parent/link_co_parent_screen.dart';
import 'bloc/schedule_cubit.dart';
import 'bloc/schedule_state.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgScheduleBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(),
                Spacer(),
                "Schedule".appText(
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
                          children: [_dailyRoutine(), coParentingSchedule()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
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

  Widget _dailyRoutine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(),
        10.spaceH,
        "Rohan’s ${LocaleKeys.dailyRoutine.tr()}"
            .appText(
              color: blueTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            )
            .appPadding(left: 16),
        _routineItem(schedule: '7:am', label: 'Morning Nap'),
        _routineItem(schedule: '9.30 am', label: 'Morning Nap'),
        _routineItem(schedule: '9.30 am', label: 'Morning Nap'),
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
      ],
    );
  }

  Widget coParentingSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(),
        10.spaceH,
        "Co- parenting Colander"
            .appText(
              color: blueTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            )
            .appPadding(left: 16),
        10.spaceH,
        _routineItem(
          schedule: 'Aug 5 - 4:00 PM',
          label: 'School Pick-up (Priya)',
          status: LocaleKeys.approved.tr(),
        ),
        _routineItem(
          schedule: 'Aug 5 - 4:00 PM',
          label: 'School Pick-up (Priya)',
          status: LocaleKeys.pending.tr(),
        ),
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
    String? status,
  }) {
    return Container(
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
          if (status != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: status == LocaleKeys.approved.tr()
                        ? approvedColor
                        : status == LocaleKeys.pending.tr()
                        ? pendingColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: status
                      .appText(fontSize: 9, fontWeight: FontWeight.w800)
                      .appPadding(left: 6, right: 6, top: 2, bottom: 2),
                ),
                10.spaceH,
                BaseButton(
                  child: "${LocaleKeys.proposeChange.tr()} >".appText(
                    fontSize: 9,
                    color: blueColor1,
                    fontWeight: FontWeight.w800,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          10.spaceW,
        ],
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
}
