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

void showAddNotesUpdateSheet(BuildContext context) {
  final cubit = context.read<TodayCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    builder: (context) =>
        BlocProvider.value(value: cubit, child: const AddNotesUpdateSheet()),
  );
}

class AddNotesUpdateSheet extends StatelessWidget {
  const AddNotesUpdateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodayCubit, TodayState>(
      listener: (BuildContext context, TodayState state) {
        state.saveStatus.whenOrNull(
          data: (_) {
            Navigator.pop(context);
            showSnackBar(
              message: LocaleKeys.noteSaved.tr(),
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
      builder: (context, state) {
        final isError =
            state.showNotesUpdateErrors && state.quickNoteText.trim().isEmpty;

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
                  "Quick note".appText(
                    fontSize: 28.sp,
                    fraunces: true,
                    textAlign: TextAlign.start,
                  ),
                  if (isError)
                    Icon(Icons.error, color: Colors.red, size: 24.sp),
                ],
              ),
              24.spaceH,
              Container(
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isError ? Colors.red : greyColor12),
                ),
                padding: EdgeInsets.all(16.w),
                child: TextField(
                  maxLines: null,
                  onChanged: (val) =>
                      context.read<TodayCubit>().setQuickNoteText(val),
                  decoration: InputDecoration(
                    hintText: "Anything you want to remember about today...",
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
              32.spaceH,
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: indigoLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mic,
                        color: secondaryColor,
                        size: 32.sp,
                      ),
                    ),
                    8.spaceH,
                    "Hold to record".appText(color: greyColor, fontSize: 12.sp),
                  ],
                ),
              ),
              32.spaceH,
              AppButton(
                isLoading: state.isLoading,
                title: "Save note",
                onTap: () {
                  if (state.quickNoteText.trim().isEmpty) {
                    context.read<TodayCubit>().triggerNotesUpdateErrors();
                  } else {
                    context.read<TodayCubit>().saveQuickNote();
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
