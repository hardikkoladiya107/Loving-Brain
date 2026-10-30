import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/core/emergency_detector.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_choice_chip.dart';
import 'package:url_launcher/url_launcher.dart';
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
      "Breathing difficulty",
    ];

    return BlocConsumer<TodayCubit, TodayState>(
      listener: (BuildContext context, TodayState state) {
        state.saveStatus.whenOrNull(
          data: (dynamic data) {
            Navigator.pop(context);
            if (data == 'offline_queued') {
              showSnackBar(
                message: "Saved offline. Will sync when reconnected.",
                type: SnackBarType.SUCCESS,
              );
            } else {
              showSnackBar(
                message: LocaleKeys.healthSavedConfidenceNote.tr(),
                type: SnackBarType.SUCCESS,
              );
            }
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
        final bool isEmergency =
            state.selectedHealthIssues.contains("Breathing difficulty") ||
            EmergencyDetector.isEmergency(state.healthNotes) ||
            state.healthNotes.toLowerCase().contains("breath") ||
            state.healthNotes.toLowerCase().contains("chok");

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
                  runSpacing: 10.h,
                  children: List.generate(issues.length, (int index) {
                    final String issue = issues[index];
                    final bool isSelected = state.selectedHealthIssues.contains(
                      issue,
                    );
                    return AppChoiceChip(
                      label: issue,
                      isSelected: isSelected,
                      isError: isError && !isSelected,
                      onTap: () =>
                          context.read<TodayCubit>().toggleHealthIssue(issue),
                    );
                  }),
                ),
                if (isError) ...[
                  8.spaceH,
                  "Please select at least one health observation".appText(
                    fontSize: 12.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                  ),
                ],
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
                if (isEmergency)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFD32F2F)),
                    ),
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: const Color(0xFFD32F2F),
                              size: 20.sp,
                            ),
                            8.spaceW,
                            "Urgent safety concern".appText(
                              color: const Color(0xFFD32F2F),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ],
                        ),
                        8.spaceH,
                        "Breathing difficulties, chest retractions, or unresponsiveness require immediate medical evaluation. Loving Brain cannot assess clinical emergencies."
                            .appText(
                              color: const Color(0xFFB71C1C),
                              fontSize: 12.sp,
                              textAlign: TextAlign.start,
                            ),
                        12.spaceH,
                        InkWell(
                          onTap: () {
                            launchUrl(
                              Uri.parse(EmergencyDetector.getEmergencyPhone()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD32F2F),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                                6.spaceW,
                                "Call emergency services (${EmergencyDetector.getEmergencyDisplayNumber()})"
                                    .appText(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
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
                  title: isEmergency ? "Review safety guidance" : "Save update",
                  onTap: () {
                    if (isEmergency) {
                      final String notes = state.healthNotes.trim();
                      final bool isAcute =
                          EmergencyDetector.isEmergency(notes) ||
                          state.selectedHealthIssues.any(
                            (String issue) =>
                                EmergencyDetector.isEmergency(issue),
                          );
                      Navigator.pop(context);
                      context.push(
                        RoutePaths.safetyConcern,
                        extra: <String, dynamic>{
                          'mode': isAcute ? 'acute' : 'clinical',
                          'sourceMessage': notes.isNotEmpty
                              ? notes
                              : state.selectedHealthIssues.join(', '),
                        },
                      );
                      return;
                    }
                    if (state.selectedHealthIssues.isEmpty) {
                      context.read<TodayCubit>().triggerHealthUpdateErrors();
                    } else {
                      context.read<TodayCubit>().saveHealthLog();
                    }
                  },
                  backgroundColor: isEmergency
                      ? const Color(0xFFD32F2F)
                      : primaryColor,
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
