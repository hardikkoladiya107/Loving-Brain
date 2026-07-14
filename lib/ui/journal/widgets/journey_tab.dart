import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/milestone_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/journal/bloc/journal_cubit.dart';
import 'package:loving_brain/ui/journal/bloc/journal_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class JourneyTab extends StatelessWidget {
  const JourneyTab({super.key, required this.state});

  final JournalState state;

  @override
  Widget build(BuildContext context) {
    final String childName = state.childModel?.childName ?? '';
    return RefreshIndicator(
      onRefresh: () => context.read<JournalCubit>().reload(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(20.w),
        children: <Widget>[
          if (state.readyNow) _readyNowCard(childName),
          if (state.readyNow) 12.h.spaceH,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: const Color(0xFFECE8F8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LocaleKeys.readinessScore.tr().appText(
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                  color: const Color(0xFF2F2A44),
                ),
                12.h.spaceH,
                '${state.readinessScore}'.appText(
                  fontWeight: FontWeight.w900,
                  fontSize: 42.sp,
                  color: const Color(0xFF6A24B8),
                ),
                8.h.spaceH,
                LocaleKeys.readinessScoreHint.tr().appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: const Color(0xFF6A5A9A),
                ),
              ],
            ),
          ),
          16.h.spaceH,
          LocaleKeys.journeyMilestonesTitle.tr().appText(
            fontWeight: FontWeight.w900,
            fontSize: 16.sp,
            color: const Color(0xFF2F2A44),
          ),
          10.h.spaceH,
          if (state.milestones.isEmpty)
            LocaleKeys.journeyMilestonesEmpty.tr().appText(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: const Color(0xFF6A5A9A),
            )
          else
            ...state.milestones.map(
              (MilestoneModel milestone) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _MilestoneRow(
                  milestone: milestone,
                  onTap: () => _showStory(context, milestone),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _readyNowCard(String childName) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF6A24B8), Color(0xFF8F58D7)],
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LocaleKeys.readyNow.tr().appText(
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
            color: Colors.white,
          ),
          8.h.spaceH,
          LocaleKeys.readyNowBody
              .tr(namedArgs: <String, String>{'childName': childName})
              .appText(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.9),
              ),
        ],
      ),
    );
  }

  Future<void> _showStory(BuildContext context, MilestoneModel milestone) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxHeight: 0.75.sh),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              milestone.title.appText(
                fontWeight: FontWeight.w900,
                fontSize: 20.sp,
                color: const Color(0xFF2F2A44),
              ),
              8.h.spaceH,
              DateFormat.yMMMd().format(milestone.timestamp).appText(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: const Color(0xFF9A8FB8),
              ),
              14.h.spaceH,
              Expanded(
                child: SingleChildScrollView(
                  child: milestone.storyText.appText(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: const Color(0xFF504A67),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              12.h.spaceH,
              BaseButton(
                onTap: () => Navigator.of(sheetContext).pop(),
                child: LocaleKeys.done.tr().appText(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                  color: const Color(0xFF6A24B8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({required this.milestone, required this.onTap});

  final MilestoneModel milestone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String dateText = DateFormat.MMMd().format(milestone.timestamp);
    return BaseButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFECE8F8)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF1ECFF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                color: const Color(0xFF6A24B8),
                size: 20.sp,
              ),
            ),
            12.w.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  milestone.title.appText(
                    fontWeight: FontWeight.w900,
                    fontSize: 14.sp,
                    color: const Color(0xFF2F2A44),
                  ),
                  4.h.spaceH,
                  LocaleKeys.journeyChapterLabel
                      .tr(
                        namedArgs: <String, String>{
                          'chapter': '${milestone.chapter}',
                        },
                      )
                      .appText(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: const Color(0xFF6A5A9A),
                      ),
                ],
              ),
            ),
            dateText.appText(
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
              color: const Color(0xFF9A8FB8),
            ),
          ],
        ),
      ),
    );
  }
}
