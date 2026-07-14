import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/journal/bloc/journal_cubit.dart';
import 'package:loving_brain/ui/journal/bloc/journal_state.dart';

class TodaysLogTab extends StatelessWidget {
  const TodaysLogTab({super.key, required this.state});

  final JournalState state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<JournalCubit>().reload(),
      child: state.todayEvents.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                SizedBox(height: 120.h),
                LocaleKeys.timelineEmpty.tr().appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: const Color(0xFF6A5A9A),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(20.w),
              itemCount: state.todayEvents.length,
              separatorBuilder: (_, __) => 10.h.spaceH,
              itemBuilder: (BuildContext context, int index) {
                final TimelineEventModel event = state.todayEvents[index];
                return _LogRow(event: event);
              },
            ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.event});

  final TimelineEventModel event;

  @override
  Widget build(BuildContext context) {
    final String timeText = DateFormat.jm().format(event.timestamp);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECE8F8)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                event.title.appText(
                  fontWeight: FontWeight.w900,
                  fontSize: 14.sp,
                  color: const Color(0xFF2F2A44),
                ),
                4.h.spaceH,
                event.subtitle.appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: const Color(0xFF6A5A9A),
                ),
              ],
            ),
          ),
          timeText.appText(
            fontWeight: FontWeight.w700,
            fontSize: 11.sp,
            color: const Color(0xFF9A8FB8),
          ),
        ],
      ),
    );
  }
}
