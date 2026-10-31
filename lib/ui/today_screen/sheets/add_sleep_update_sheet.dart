import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';
import 'instant_result_sheet.dart';

Future<void> showAddSleepUpdateSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) => const AddSleepUpdateSheet(),
  );
}

class AddSleepUpdateSheet extends StatelessWidget {
  const AddSleepUpdateSheet({super.key});

  Future<void> _pickTime({
    required BuildContext context,
    required void Function(String formatted) onPicked,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      final DateTime now = DateTime.now();
      final DateTime dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      onPicked(DateFormat('hh:mm a').format(dt));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodayCubit, TodayState>(
      listener: (BuildContext context, TodayState state) {
        if (state.duplicateSleepLogDetected != null) {
          final SleepLogModel dup = state.duplicateSleepLogDetected!;
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: 'Overlapping sleep entry'.appText(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              content:
                  'An existing sleep entry was already logged around ${dup.fellAsleepTime ?? 'this time'} \u2013 ${dup.wokeUpTime ?? ''}. Do you want to add a separate entry anyway?'
                      .appText(fontSize: 14.sp),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.read<TodayCubit>().clearDuplicateSleepAlert();
                  },
                  child: 'Cancel'.appText(color: greyColor4),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.read<TodayCubit>().updateDuplicateSleepLog();
                  },
                  child: 'Edit existing'.appText(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.read<TodayCubit>().saveSleepLog(forceSave: true);
                  },
                  child: 'Save as separate'.appText(
                    color: greyColor8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
          return;
        }

        state.saveStatus.whenOrNull(
          data: (dynamic data) {
            Navigator.pop(context);
            if (data == 'offline_queued') {
              showSnackBar(
                message: LocaleKeys.savedOfflineWillSync.tr(),
                type: SnackBarType.SUCCESS,
              );
            } else if (state.didForecastChangeSignificantly) {
              showInstantResultSheet(
                context,
                title: state.instantResultTitle.isNotEmpty
                    ? state.instantResultTitle
                    : LocaleKeys.bedtimeMayShiftEarlier.tr(),
                reason: state.forecastChangeReason.isNotEmpty
                    ? state.forecastChangeReason
                    : state.sleepForecastReason,
                action: state.instantResultAction.isNotEmpty
                    ? state.instantResultAction
                    : LocaleKeys.checkUpdatedSleepPlan.tr(),
                actionSubtitle: state.instantResultActionSubtitle.isNotEmpty
                    ? state.instantResultActionSubtitle
                    : LocaleKeys.windDownReflectsLatestRest.tr(),
                onActionTap: () {
                  context.push(RoutePaths.tonightsPlan);
                },
              );
            } else {
              showSnackBar(
                message: LocaleKeys.updateSavedQuietly.tr(),
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
        final bool nightStartMissing =
            state.fellAsleepTime == null ||
            state.fellAsleepTime!.trim().isEmpty;
        final bool nightEndMissing =
            state.wokeUpTime == null || state.wokeUpTime!.trim().isEmpty;
        final bool missingEverything =
            nightStartMissing && nightEndMissing && !state.includeNaps;

        return DraggableScrollableSheet(
          initialChildSize: 0.94,
          minChildSize: 0.45,
          maxChildSize: 0.96,
          expand: false,
          builder:
              (BuildContext sheetContext, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
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
                          'Sleep update'.appText(
                            fontSize: 28.sp,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          12.spaceH,
                          'Takes about twenty seconds'.appText(
                            color: greyColor,
                            fontSize: 14.sp,
                            textAlign: TextAlign.start,
                          ),
                          24.spaceH,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildTimeInput(
                                  label: 'FELL ASLEEP',
                                  time: state.fellAsleepTime,
                                  isError:
                                      state.showSleepUpdateErrors &&
                                      (missingEverything ||
                                          (nightStartMissing &&
                                              !nightEndMissing)),
                                  errorText: 'Required',
                                  onTap: () => _pickTime(
                                    context: context,
                                    onPicked: (String formatted) {
                                      context
                                          .read<TodayCubit>()
                                          .setFellAsleepTime(formatted);
                                    },
                                  ),
                                ),
                              ),
                              12.spaceW,
                              Expanded(
                                child: _buildTimeInput(
                                  label: 'WOKE UP',
                                  time: state.wokeUpTime,
                                  isError:
                                      state.showSleepUpdateErrors &&
                                      (missingEverything ||
                                          (nightEndMissing &&
                                              !nightStartMissing)),
                                  errorText: 'Required',
                                  onTap: () => _pickTime(
                                    context: context,
                                    onPicked: (String formatted) {
                                      context.read<TodayCubit>().setWokeUpTime(
                                        formatted,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          8.spaceH,
                          'Night sleep is enough on its own.'.appText(
                            fontSize: 12.sp,
                            color: greyColor6,
                            textAlign: TextAlign.start,
                          ),
                          24.spaceH,
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    'Add a nap'.appText(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                      textAlign: TextAlign.start,
                                    ),
                                    4.spaceH,
                                    'Daytime nap for today'.appText(
                                      fontSize: 12.sp,
                                      color: greyColor6,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              CupertinoSwitch(
                                key: const ValueKey<String>(
                                  'include_naps_switch',
                                ),
                                value: state.includeNaps,
                                onChanged: (bool value) => context
                                    .read<TodayCubit>()
                                    .setIncludeNaps(value),
                                activeTrackColor: primaryColor,
                              ),
                            ],
                          ),
                          if (state.includeNaps) ...[
                            16.spaceH,
                            for (
                              int index = 0;
                              index < state.napDrafts.length;
                              index++
                            )
                              _buildNapRow(context, state, index),
                            if (state.napDrafts.length <
                                TodayCubit.maxNapsPerUpdate) ...[
                              8.spaceH,
                              AppButton(
                                key: const ValueKey<String>('add_nap_button'),
                                title: 'Add nap',
                                onTap: () =>
                                    context.read<TodayCubit>().addNapDraft(),
                                backgroundColor: Colors.white,
                                borderColor: greyColor12,
                                textColor: greyColor9,
                              ),
                            ],
                          ],
                          24.spaceH,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              'Night waking'.appText(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                              CupertinoSwitch(
                                value: state.isNightWaking,
                                onChanged: (bool value) => context
                                    .read<TodayCubit>()
                                    .toggleNightWaking(value),
                                activeTrackColor: primaryColor,
                              ),
                            ],
                          ),
                          24.spaceH,
                          'SLEEP QUALITY'.appText(
                            color: secondaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.sp,
                            letterSpacing: 1.2,
                          ),
                          12.spaceH,
                          Row(
                            children: List.generate(
                              5,
                              (int index) => GestureDetector(
                                onTap: () => context
                                    .read<TodayCubit>()
                                    .setSleepQuality(index),
                                child: Container(
                                  height: 24.h,
                                  width: 24.w,
                                  margin: EdgeInsets.only(right: 12.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        (state.sleepQualityIndex >= 0 &&
                                            index <= state.sleepQualityIndex)
                                        ? secondaryColor
                                        : greyColor11,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          24.spaceH,
                          AppButton(
                            isLoading: state.isLoading,
                            title: 'Save update',
                            onTap: () {
                              context.read<TodayCubit>().saveSleepLog();
                            },
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                          ),
                          24.spaceH,
                        ],
                      ).appPadding(all: 16.r),
                    ),
                  ),
                );
              },
        );
      },
    );
  }

  Widget _buildNapRow(BuildContext context, TodayState state, int index) {
    final NapDraft draft = state.napDrafts[index];
    final bool showError =
        state.showSleepUpdateErrors && draft.error.trim().isNotEmpty;
    final bool bothFilled = draft.hasStart && draft.hasEnd;
    final bool startError = showError && (!draft.hasStart || bothFilled);
    final bool endError = showError && (!draft.hasEnd || bothFilled);
    final bool canDelete = index > 0;
    final bool showHeading = state.napDrafts.length > 1;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeading)
            Row(
              children: [
                Expanded(
                  child: 'Nap ${index + 1}'.appText(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.start,
                  ),
                ),
                if (canDelete)
                  IconButton(
                    key: ValueKey<String>('delete_nap_$index'),
                    onPressed: () =>
                        context.read<TodayCubit>().removeNapDraft(index),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: primaryColor,
                      size: 22.sp,
                    ),
                  ),
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTimeInput(
                  label: 'NAP STARTED',
                  time: draft.start,
                  isError: startError,
                  showErrorText: false,
                  errorText: draft.error,
                  onTap: () => _pickTime(
                    context: context,
                    onPicked: (String formatted) {
                      context.read<TodayCubit>().setNapDraftStart(
                        index,
                        formatted,
                      );
                    },
                  ),
                ),
              ),
              12.spaceW,
              Expanded(
                child: _buildTimeInput(
                  label: 'NAP ENDED',
                  time: draft.end,
                  isError: endError,
                  showErrorText: false,
                  errorText: draft.error,
                  onTap: () => _pickTime(
                    context: context,
                    onPicked: (String formatted) {
                      context.read<TodayCubit>().setNapDraftEnd(
                        index,
                        formatted,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (showError) ...[
            4.spaceH,
            draft.error.appText(
              fontSize: 12.sp,
              color: Colors.red,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeInput({
    required String label,
    required String? time,
    required bool isError,
    String? errorText,
    bool showErrorText = true,
    required VoidCallback onTap,
    String dummyText = 'HH:MM AM',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: isError ? Colors.red : greyColor12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: label.appText(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: isError ? Colors.red : greyColor,
                        letterSpacing: 1.2,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (isError)
                      Icon(Icons.error, color: Colors.red, size: 16.sp),
                  ],
                ),
                4.spaceH,
                (time ?? dummyText).appText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: time == null ? greyColor4 : blackTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        if (isError && showErrorText) ...[
          4.spaceH,
          (errorText ?? 'Please select time').appText(
            fontSize: 12.sp,
            color: Colors.red,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
          ),
        ],
      ],
    );
  }
}
