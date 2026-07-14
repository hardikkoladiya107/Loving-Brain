import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/timeline/bloc/timeline_cubit.dart';
import 'package:loving_brain/ui/timeline/bloc/timeline_state.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TimelineCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimelineCubit, TimelineState>(
      listener: (BuildContext context, TimelineState state) {
        state.loadStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) => EasyLoading.dismiss(),
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, TimelineState state) {
        final String childName = state.childModel?.childName ?? '';
        return Scaffold(
          backgroundColor: const Color(0xFFF8F7FC),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF2F2A44),
            title: LocaleKeys.todaysTimeline.tr().appText(
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
              color: const Color(0xFF2F2A44),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<TimelineCubit>().loadToday(),
              child: state.events.isEmpty
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
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      itemCount: state.events.length,
                      separatorBuilder: (_, __) => 10.h.spaceH,
                      itemBuilder: (BuildContext context, int index) {
                        final TimelineEventModel event = state.events[index];
                        return _TimelineRow(
                          event: event,
                          childName: childName,
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.childName});

  final TimelineEventModel event;
  final String childName;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF1ECFF),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(_iconFor(event.type), color: const Color(0xFF6A24B8)),
          ),
          12.w.spaceW,
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

  IconData _iconFor(String type) {
    switch (type) {
      case 'feed':
        return Icons.restaurant_rounded;
      case 'sleep_start':
      case 'sleep_end':
        return Icons.bedtime_rounded;
      case 'smart_moment':
        return Icons.favorite_rounded;
      case 'help_flow':
        return Icons.support_agent_rounded;
      default:
        return Icons.timeline_rounded;
    }
  }
}
