import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/snack_bar.dart';
import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';

void showAddHealthUpdateSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    builder: (BuildContext context) => const AddHealthUpdateSheet(),
  );
}

class AddHealthUpdateSheet extends StatelessWidget {
  const AddHealthUpdateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> issues = <String>[
      "Fever",
      "Teething",
      "Medication",
      "Low appetite",
      "Illness",
      "Rash",
    ];

    return BlocConsumer<TodayCubit, TodayState>(
      listener: (BuildContext context, TodayState state) {
        state.saveStatus.whenOrNull(
          data: (_) {
            Navigator.pop(context);
            showSnackBar(
              message: LocaleKeys.healthLogSaved.tr(),
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception error) {
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, TodayState state) {
        final bool isError =
            state.showHealthUpdateErrors && state.selectedHealthIssues.isEmpty;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: greyColor7,
                      ),
                    ),
                  ],
                ),
                12.spaceH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: "Health update".appText(
                        fontSize: 28.sp,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (isError)
                      Icon(Icons.error, color: Colors.red, size: 24.sp),
                  ],
                ),
                12.spaceH,
                "Anything that might affect sleep or mood today.".appText(
                  color: greyColor,
                  fontSize: 14.sp,
                  textAlign: TextAlign.start,
                ),
                24.spaceH,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(issues.length, (int index) {
                    final String issue = issues[index];
                    final bool isSelected = state.selectedHealthIssues.contains(
                      issue,
                    );
                    return GestureDetector(
                      onTap: () =>
                          context.read<TodayCubit>().toggleHealthIssue(issue),
                      child: Chip(
                        label: issue.appText(
                          color: isSelected ? secondaryColor : Colors.black,
                        ),
                        backgroundColor: isSelected
                            ? indigoLight
                            : Colors.white,
                        side: BorderSide(
                          color: (isError && !isSelected)
                              ? Colors.red
                              : (isSelected ? secondaryColor : greyColor12),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                    );
                  }),
                ),
                24.spaceH,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: greyColor12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "NOTES".appText(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: greyColor,
                        letterSpacing: 1.2,
                        textAlign: TextAlign.start,
                      ),
                      4.spaceH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (String val) => context
                                  .read<TodayCubit>()
                                  .setHealthNotes(val),
                              style: getTextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: greyColor9,
                              ),
                              decoration: InputDecoration(
                                hintText: "Warm cheeks since this afternoon",
                                hintStyle: getTextStyle(
                                  fontSize: 16.sp,
                                  color: greyColor4,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.add_box_outlined,
                            color: primaryColor,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                16.spaceH,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error, color: primaryColor, size: 16.sp),
                    8.spaceW,
                    Expanded(
                      child:
                          "This doesn't look like an emergency, but contact a health professional if you're worried."
                              .appText(
                                color: greyColor,
                                fontSize: 12.sp,
                                textAlign: TextAlign.start,
                              ),
                    ),
                  ],
                ),
                24.spaceH,
                AppButton(
                  isLoading: state.isLoading,
                  title: "Save update",
                  onTap: () {
                    if (state.selectedHealthIssues.isEmpty) {
                      context.read<TodayCubit>().triggerHealthUpdateErrors();
                    } else {
                      context.read<TodayCubit>().saveHealthLog();
                    }
                  },
                  backgroundColor: primaryColor,
                  textColor: Colors.white,
                ),
                24.spaceH,
              ],
            ).appPadding(all: 16.r),
          ),
        );
      },
    );
  }
}
