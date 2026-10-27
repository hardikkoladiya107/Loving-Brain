import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
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

void showAddMoodUpdateSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    builder: (BuildContext context) => const AddMoodUpdateSheet(),
  );
}

class AddMoodUpdateSheet extends StatelessWidget {
  const AddMoodUpdateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> parentMoods = <String>[
      "Calm",
      "Tired",
      "Overwhelmed",
      "Okay",
    ];
    final List<String> images = <String>[
      Assets.v2.images.imgMoodHappy.path,
      Assets.v2.images.imgMoodGood.path,
      Assets.v2.images.imgMoodStable.path,
      Assets.v2.images.imgMoodBad.path,
      Assets.v2.images.imgMoodSad.path,
    ];

    return BlocConsumer<TodayCubit, TodayState>(
      listener: (BuildContext context, TodayState state) {
        state.saveStatus.whenOrNull(
          data: (_) {
            Navigator.pop(context);
            showSnackBar(
              message: LocaleKeys.moodLogSaved.tr(),
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
            state.showMoodUpdateErrors && state.selectedChildMoodIndex == -1;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:
                        "How is ${state.childName.isNotEmpty ? state.childName : 'your child'} feeling?"
                            .appText(
                              fontSize: 28.sp,
                              fraunces: true,
                              textAlign: TextAlign.start,
                            ),
                  ),
                  if (isError) ...[
                    8.spaceW,
                    Icon(Icons.error, color: Colors.red, size: 24.sp),
                  ],
                ],
              ),
              if (isError) ...[
                6.spaceH,
                "Please select how your child is feeling".appText(
                  color: Colors.red,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
              ],
              12.spaceH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(images.length, (int index) {
                  final bool isSelected = state.selectedChildMoodIndex == index;
                  final List<String> moodLabels = <String>[
                    "Very happy",
                    "Content",
                    "Neutral",
                    "Unsettled",
                    "Upset",
                  ];
                  final String moodLabel = moodLabels[index];
                  return Semantics(
                    label: moodLabel,
                    selected: isSelected,
                    button: true,
                    child: GestureDetector(
                      onTap: () =>
                          context.read<TodayCubit>().setChildMood(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFEF8F5)
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: isSelected
                              ? const [
                                  BoxShadow(
                                    color: Color(0x6B6B6B40),
                                    spreadRadius: 1,
                                    blurRadius: 80,
                                  ),
                                ]
                              : [],
                          border: Border.all(
                            color: isError && !isSelected
                                ? Colors.red
                                : (isSelected
                                      ? secondaryColor
                                      : Colors.transparent),
                          ),
                        ),
                        padding: EdgeInsets.all(12.r),
                        child: Container(
                          height: 30.w,
                          width: 30.w,
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(images[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              12.spaceH,
              "AND HOW ARE YOU DOING? OPTIONAL".appText(
                color: secondaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 12.sp,
                letterSpacing: 1.2,
              ),
              12.spaceH,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(parentMoods.length, (int index) {
                  final String mood = parentMoods[index];
                  final bool isSelected = state.selectedParentMood == mood;
                  return GestureDetector(
                    onTap: () => context.read<TodayCubit>().setParentMood(mood),
                    child: Chip(
                      label: mood.appText(
                        color: isSelected ? secondaryColor : Colors.black,
                      ),
                      backgroundColor: isSelected ? indigoLight : Colors.white,
                      side: BorderSide(
                        color: isSelected ? secondaryColor : greyColor12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                    ),
                  );
                }),
              ),
              16.spaceH,
              AppButton(
                isLoading: state.isLoading,
                title: "Save update",
                onTap: () {
                  if (state.selectedChildMoodIndex == -1) {
                    context.read<TodayCubit>().triggerMoodUpdateErrors();
                    showSnackBar(
                      message: "Please select how your child is feeling",
                      type: SnackBarType.ERROR,
                    );
                  } else {
                    context.read<TodayCubit>().saveMoodLog();
                  }
                },
                backgroundColor: primaryColor,
                textColor: Colors.white,
              ),
              24.spaceH,
            ],
          ).appPadding(all: 16.r),
        );
      },
    );
  }
}
