import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/handover/bloc/handover_cubit.dart';
import 'package:loving_brain/ui/handover/bloc/handover_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

Future<void> showHandoverSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return BlocProvider<HandoverCubit>(
        create: (_) => HandoverCubit()..init(),
        child: const HandoverSheet(),
      );
    },
  );
}

class HandoverSheet extends StatelessWidget {
  const HandoverSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HandoverCubit, HandoverState>(
      listener: (BuildContext context, HandoverState state) {
        state.transferStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) async {
            EasyLoading.dismiss();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
            await showSnackBar(
              message: LocaleKeys.handoverSuccess.tr(),
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, HandoverState state) {
        final bool isActiveLogger = state.userModel?.isActiveLogger ?? true;
        return Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LocaleKeys.handoverTitle.tr().appText(
                fontWeight: FontWeight.w900,
                fontSize: 20.sp,
                color: const Color(0xFF2F2A44),
              ),
              10.h.spaceH,
              (isActiveLogger
                      ? LocaleKeys.handoverActiveLoggerBody
                      : LocaleKeys.handoverViewerBody)
                  .tr()
                  .appText(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: const Color(0xFF504A67),
                    textAlign: TextAlign.start,
                  ),
              20.h.spaceH,
              if (isActiveLogger)
                BaseButton(
                  onTap: () => _confirmHandover(context),
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFF6A24B8), Color(0xFF8F58D7)],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: LocaleKeys.handoverToCoParent.tr().appText(
                      fontWeight: FontWeight.w900,
                      fontSize: 15.sp,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1ECFF),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: LocaleKeys.handoverViewerBadge.tr().appText(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.sp,
                    color: const Color(0xFF6A24B8),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmHandover(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: LocaleKeys.handoverConfirmTitle.tr().appText(
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
          ),
          content: LocaleKeys.handoverConfirmBody.tr().appText(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: LocaleKeys.cancel.tr().appText(),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: LocaleKeys.handoverToCoParent.tr().appText(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF6A24B8),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed == true && context.mounted) {
      await context.read<HandoverCubit>().transferToPartner();
    }
  }
}
