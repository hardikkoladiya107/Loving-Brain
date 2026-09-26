import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';
import 'instant_result_sheet.dart';

void showAddMoodUpdateSheet(BuildContext context) {
  final cubit = context.read<TodayCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    builder: (context) =>
        BlocProvider.value(value: cubit, child: const AddMoodUpdateSheet()),
  );
}

class AddMoodUpdateSheet extends StatelessWidget {
  const AddMoodUpdateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> parentMoods = ["Calm", "Tired", "Overwhelmed", "Okay"];
    List<String> images = [
      Assets.v2.images.imgMoodHappy.path,
      Assets.v2.images.imgMoodGood.path,
      Assets.v2.images.imgMoodStable.path,
      Assets.v2.images.imgMoodBad.path,
      Assets.v2.images.imgMoodSad.path,
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
                  "How is Ira feeling?".appText(
                    fontSize: 28.sp,
                    fraunces: true,
                    textAlign: TextAlign.start,
                  ),
                  if (isError)
                    Icon(Icons.error, color: Colors.red, size: 24.sp),
                ],
              ),
              12.spaceH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(images.length, (index) {
                  final isSelected = state.selectedChildMoodIndex == index;
                  return GestureDetector(
                    onTap: () => context.read<TodayCubit>().setChildMood(index),
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
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        height: 30,
                        width: 30,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(images[index]),
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
                children: List.generate(parentMoods.length, (index) {
                  final mood = parentMoods[index];
                  final isSelected = state.selectedParentMood == mood;
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
                        borderRadius: BorderRadius.circular(50),
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
