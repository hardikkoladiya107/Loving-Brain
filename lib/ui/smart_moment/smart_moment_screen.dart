import 'package:easy_localization/easy_localization.dart';
import '../../generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart' as status;
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/smart_moment/bloc/smart_moment_cubit.dart';
import 'package:loving_brain/ui/smart_moment/bloc/smart_moment_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class SmartMomentScreen extends StatefulWidget {
  const SmartMomentScreen({super.key});

  @override
  State<SmartMomentScreen> createState() => _SmartMomentScreenState();
}

class _SmartMomentScreenState extends State<SmartMomentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SmartMomentCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SmartMomentCubit, SmartMomentState>(
      listener: (BuildContext context, SmartMomentState state) async {
        final status.ApiResultStatus saveStatus = state.saveApiResultStatus;
        if (saveStatus is status.Loging) {
          EasyLoading.show();
          return;
        }
        if (saveStatus is status.Data) {
          EasyLoading.dismiss();
          final bool? isMilestone = await _showMilestonePrompt(context);
          if (!context.mounted) {
            return;
          }
          if (isMilestone == null) {
            return;
          }
          if (isMilestone == true) {
            await showSnackBar(
              message: 'Milestone flow will open in Sprint 3.',
              type: SnackBarType.None,
            );
          } else {
            await showSnackBar(
              message: 'Nice timing - this builds connection.',
              type: SnackBarType.SUCCESS,
            );
          }
          if (!context.mounted) {
            return;
          }
          context.pop();
          return;
        }
        if (saveStatus is status.Error) {
          EasyLoading.dismiss();
          showSnackBar(
            message: saveStatus.error.toString().replaceAll('Exception: ', ''),
            type: SnackBarType.ERROR,
          );
          return;
        }
        EasyLoading.dismiss();
      },
      builder: (BuildContext context, SmartMomentState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F7FC),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF2F2A44),
            title: LocaleKeys.smartMoment.tr().appText(
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
              color: const Color(0xFF2F2A44),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22.r),
                          border: Border.all(
                            color: const Color(0xFFECE8F8),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            state.activityTitle.appText(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF2F2A44),
                              textAlign: TextAlign.start,
                            ),
                            8.h.spaceH,
                            state.subtitle.appText(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6A5A9A),
                              textAlign: TextAlign.start,
                            ),
                            14.h.spaceH,
                            state.message.appText(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF504A67),
                              textAlign: TextAlign.start,
                            ),
                            18.h.spaceH,
                            LocaleKeys.steps.tr().appText(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF2F2A44),
                            ),
                            10.h.spaceH,
                            ...state.steps.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final String step = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 22.w,
                                      height: 22.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1ECFF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: '${index + 1}'.appText(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF6A24B8),
                                      ),
                                    ),
                                    8.w.spaceW,
                                    Expanded(
                                      child: step.appText(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF504A67),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  16.h.spaceH,
                  BaseButton(
                    onTap: () =>
                        context.read<SmartMomentCubit>().markTriedThis(),
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xFF6A24B8), Color(0xFF8F58D7)],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: LocaleKeys.iTriedThis.tr().appText(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  14.h.spaceH,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showMilestonePrompt(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LocaleKeys.didSomethingSpecialHappen.tr().appText(
                  fontWeight: FontWeight.w900,
                  fontSize: 22.sp,
                  textAlign: TextAlign.center,
                  color: const Color(0xFF2F2A44),
                ),
                10.h.spaceH,
                LocaleKeys.markAsMilestoneIfNeeded.tr().appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                  color: const Color(0xFF5B5571),
                ),
                22.h.spaceH,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: BaseButton(
                        onTap: () => Navigator.of(context).pop(false),
                        child: Container(
                          height: 44.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEAF0),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: LocaleKeys.no.tr().appText(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF5B5571),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    10.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        onTap: () => Navigator.of(context).pop(true),
                        child: Container(
                          height: 44.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A24B8),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: LocaleKeys.yes.tr().appText(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
