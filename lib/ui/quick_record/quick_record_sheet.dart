import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/ui/home/bloc/home_cubit.dart';
import 'package:loving_brain/ui/home/bloc/home_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

Future<void> showQuickRecordSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return const QuickRecordSheet();
    },
  );
}

class QuickRecordSheet extends StatefulWidget {
  const QuickRecordSheet({super.key});

  @override
  State<QuickRecordSheet> createState() => _QuickRecordSheetState();
}

class _QuickRecordSheetState extends State<QuickRecordSheet> {
  bool _sleepInProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final HomeState homeState = context.read<HomeCubit>().state;
      final String childId = homeState.childModel?.reference?.id ?? '';
      if (childId.isEmpty) {
        return;
      }
      final bool inProgress = await ChildRepo.instance.isSleepInProgress(
        childId: childId,
      );
      if (mounted) {
        setState(() {
          _sleepInProgress = inProgress;
        });
      }
    });
  }

  Future<void> _handleResult(ApiResultStatus result, String successKey) async {
    EasyLoading.dismiss();
    result.whenOrNull(
      data: (_) async {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pop();
        await showSnackBar(
          message: successKey.tr(),
          type: SnackBarType.SUCCESS,
        );
      },
      error: (Exception error) async {
        await showSnackBar(
          message: error.toString().replaceAll('Exception: ', ''),
          type: SnackBarType.ERROR,
        );
      },
    );
  }

  Future<void> _logFeed() async {
    final HomeState homeState = context.read<HomeCubit>().state;
    final String childId = homeState.childModel?.reference?.id ?? '';
    final String uid = homeState.userModel?.uid ?? '';
    if (childId.isEmpty || uid.isEmpty) {
      return;
    }
    EasyLoading.show();
    final ApiResultStatus result = await ChildRepo.instance.recordFeed(
      childId: childId,
      actorUid: uid,
    );
    await _handleResult(result, LocaleKeys.feedLoggedSuccess);
  }

  Future<void> _startSleep() async {
    final HomeState homeState = context.read<HomeCubit>().state;
    final String childId = homeState.childModel?.reference?.id ?? '';
    final String uid = homeState.userModel?.uid ?? '';
    if (childId.isEmpty || uid.isEmpty) {
      return;
    }
    EasyLoading.show();
    final ApiResultStatus result = await ChildRepo.instance.startSleep(
      childId: childId,
      actorUid: uid,
    );
    result.whenOrNull(
      data: (_) {
        setState(() {
          _sleepInProgress = true;
        });
      },
    );
    await _handleResult(result, LocaleKeys.sleepStartedSuccess);
  }

  Future<void> _endSleep() async {
    final HomeState homeState = context.read<HomeCubit>().state;
    final String childId = homeState.childModel?.reference?.id ?? '';
    final String uid = homeState.userModel?.uid ?? '';
    if (childId.isEmpty || uid.isEmpty) {
      return;
    }
    EasyLoading.show();
    final ApiResultStatus result = await ChildRepo.instance.endSleep(
      childId: childId,
      actorUid: uid,
    );
    result.whenOrNull(
      data: (_) {
        setState(() {
          _sleepInProgress = false;
        });
      },
    );
    await _handleResult(result, LocaleKeys.sleepEndedSuccess);
  }

  @override
  Widget build(BuildContext context) {
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
          LocaleKeys.quickRecord.tr().appText(
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
            color: const Color(0xFF2F2A44),
          ),
          6.h.spaceH,
          LocaleKeys.quickRecordSubtitle.tr().appText(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: const Color(0xFF6A5A9A),
          ),
          20.h.spaceH,
          _actionButton(
            icon: Icons.restaurant_rounded,
            label: LocaleKeys.logFeed.tr(),
            onTap: _logFeed,
          ),
          10.h.spaceH,
          if (!_sleepInProgress)
            _actionButton(
              icon: Icons.bedtime_rounded,
              label: LocaleKeys.startSleep.tr(),
              onTap: _startSleep,
            )
          else
            _actionButton(
              icon: Icons.wb_sunny_rounded,
              label: LocaleKeys.endSleep.tr(),
              onTap: _endSleep,
            ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F5FF),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFECE8F8)),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: const Color(0xFF6A24B8)),
            12.w.spaceW,
            label.tr().appText(
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
              color: const Color(0xFF2F2A44),
            ),
          ],
        ),
      ),
    );
  }
}
