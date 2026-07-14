import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/content/milestone_content.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/home/bloc/home_cubit.dart';
import 'package:loving_brain/ui/home/bloc/home_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

/// Returns selected milestone key, or null if dismissed.
Future<String?> showMilestonePickerSheet(BuildContext context) async {
  final HomeState homeState = context.read<HomeCubit>().state;
  final String childName = homeState.childModel?.childName ?? 'your child';
  final String parentName = homeState.userModel?.parentName ?? 'Parent';
  final int ageInMonths = AgeUtils.resolvedAgeInMonths(
    dob: homeState.childModel?.childDob,
    legacyAgeText: homeState.childModel?.childAge ?? '',
  );
  final List<MilestoneDefinition> options =
      await MilestoneContent.catalogForAge(
    childName: childName,
    parentName: parentName,
    ageInMonths: ageInMonths,
  );
  if (!context.mounted) {
    return null;
  }
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return MilestonePickerSheet(options: options);
    },
  );
}

class MilestonePickerSheet extends StatelessWidget {
  const MilestonePickerSheet({super.key, required this.options});

  final List<MilestoneDefinition> options;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      constraints: BoxConstraints(maxHeight: 0.7.sh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LocaleKeys.milestonePickerTitle.tr().appText(
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
            color: const Color(0xFF2F2A44),
          ),
          8.h.spaceH,
          LocaleKeys.milestonePickerSubtitle.tr().appText(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: const Color(0xFF6A5A9A),
          ),
          16.h.spaceH,
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: options.length,
              separatorBuilder: (_, __) => 8.h.spaceH,
              itemBuilder: (BuildContext context, int index) {
                final MilestoneDefinition item = options[index];
                return BaseButton(
                  onTap: () => Navigator.of(context).pop(item.key),
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5FF),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: const Color(0xFFECE8F8)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              item.title.appText(
                                fontWeight: FontWeight.w900,
                                fontSize: 14.sp,
                                color: const Color(0xFF2F2A44),
                              ),
                              4.h.spaceH,
                              LocaleKeys.journeyChapterLabel
                                  .tr(
                                    namedArgs: <String, String>{
                                      'chapter': '${item.chapter}',
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
                        Icon(
                          Icons.chevron_right_rounded,
                          color: const Color(0xFF6A24B8),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
