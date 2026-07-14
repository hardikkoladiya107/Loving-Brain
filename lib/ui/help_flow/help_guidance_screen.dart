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
import 'package:loving_brain/ui/help_flow/bloc/help_flow_cubit.dart';
import 'package:loving_brain/ui/help_flow/bloc/help_flow_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class HelpGuidanceScreen extends StatefulWidget {
  const HelpGuidanceScreen({super.key});

  @override
  State<HelpGuidanceScreen> createState() => _HelpGuidanceScreenState();
}

class _HelpGuidanceScreenState extends State<HelpGuidanceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HelpFlowCubit, HelpFlowState>(
      listener: (BuildContext context, HelpFlowState state) async {
        final status.ApiResultStatus saveStatus = state.saveApiResultStatus;
        if (saveStatus is status.Loging) {
          EasyLoading.show();
          return;
        }
        if (saveStatus is status.Data) {
          EasyLoading.dismiss();
          if (!context.mounted) {
            return;
          }
          context.pop();
          context.pop();
          await Future<void>.delayed(const Duration(milliseconds: 80));
          await showSnackBar(
            message: LocaleKeys.helpFlowSuccessMessage.tr(),
            type: SnackBarType.SUCCESS,
          );
          return;
        }
        if (saveStatus is status.Error) {
          EasyLoading.dismiss();
          await showSnackBar(
            message: saveStatus.error.toString().replaceAll('Exception: ', ''),
            type: SnackBarType.ERROR,
          );
          return;
        }
        EasyLoading.dismiss();
      },
      builder: (BuildContext context, HelpFlowState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F7FC),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF2F2A44),
            title: LocaleKeys.guidance.tr().appText(
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
                            state.contextLine.appText(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF57506E),
                              textAlign: TextAlign.start,
                            ),
                            12.h.spaceH,
                            state.primaryAction.appText(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF2F2A44),
                              textAlign: TextAlign.start,
                            ),
                            14.h.spaceH,
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
                            10.h.spaceH,
                            state.fallbackText.appText(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6A5A9A),
                              textAlign: TextAlign.start,
                            ),
                            if (state.showEscalationHint) ...<Widget>[
                              12.h.spaceH,
                              LocaleKeys.helpFlowEscalationHint.tr().appText(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFAB2D55),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  16.h.spaceH,
                  BaseButton(
                    onTap: () => context.read<HelpFlowCubit>().markHelped(),
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2DBE6C),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: LocaleKeys.thisHelped.tr().appText(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  10.h.spaceH,
                  BaseButton(
                    onTap: () =>
                        context.read<HelpFlowCubit>().stillNotWorking(),
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E9EE),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: LocaleKeys.stillNotWorking.tr().appText(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                        color: const Color(0xFF50505D),
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
}
