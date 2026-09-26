import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';
import 'instant_result_sheet.dart';

void showAddHealthUpdateSheet(BuildContext context) {
  final cubit = context.read<TodayCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    builder: (context) =>
        BlocProvider.value(value: cubit, child: const AddHealthUpdateSheet()),
  );
}

class AddHealthUpdateSheet extends StatelessWidget {
  const AddHealthUpdateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> issues = [
      "Fever",
      "Teething",
      "Medication",
      "Low appetite",
      "Illness",
      "Rash",
    ];

    return BlocConsumer<TodayCubit, TodayState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pop(context);
          showInstantResultSheet(context);
        }
      },
      builder: (context, state) {
        final isError =
            state.showHealthUpdateErrors && state.selectedHealthIssues.isEmpty;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 2,
                    width: 60.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: greyColor7,
                    ),
                  ),
                ],
              ),
              12.spaceH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Health update".appText(
                    fontSize: 28.sp,
                    fraunces: true,
                    textAlign: TextAlign.start,
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
                children: List.generate(issues.length, (index) {
                  final issue = issues[index];
                  final isSelected = state.selectedHealthIssues.contains(issue);
                  return GestureDetector(
                    onTap: () =>
                        context.read<TodayCubit>().toggleHealthIssue(issue),
                    child: Chip(
                      label: issue.appText(
                        color: isSelected ? secondaryColor : Colors.black,
                      ),
                      backgroundColor: isSelected ? indigoLight : Colors.white,
                      side: BorderSide(
                        color: (isError && !isSelected)
                            ? Colors.red
                            : (isSelected ? secondaryColor : greyColor12),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  );
                }),
              ),
              24.spaceH,
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: greyColor12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "NOTES".appText(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: greyColor,
                      letterSpacing: 1.2,
                    ),
                    4.spaceH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (val) =>
                                context.read<TodayCubit>().setHealthNotes(val),
                            decoration: InputDecoration(
                              hintText: "Warm cheeks since this afternoon",
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
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
                    context.read<TodayCubit>().saveUpdate();
                  }
                },
                backgroundColor: primaryColor,
                textColor: Colors.white,
              ),
              24.spaceH,
            ],
          ).appPadding(all: 16),
        );
      },
    );
  }
}
