import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

/// One-time bottom sheet when parent logs High Energy for the first time.
Future<void> showEnergyBridgeExplainerIfNeeded(BuildContext context) async {
  final bool seen =
      preferences.getBool(
        SharedPreference.energyBridgeExplainerSeen,
        defValue: false,
      ) ??
      false;
  if (seen || !context.mounted) {
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return const EnergyBridgeExplainerSheet();
    },
  );
  await preferences.putBool(SharedPreference.energyBridgeExplainerSeen, true);
}

class EnergyBridgeExplainerSheet extends StatelessWidget {
  const EnergyBridgeExplainerSheet({super.key});

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
          Row(
            children: <Widget>[
              Icon(Icons.bolt_rounded, color: const Color(0xFF6A24B8), size: 28.sp),
              10.w.spaceW,
              Expanded(
                child: LocaleKeys.energyBridgeExplainerTitle.tr().appText(
                  fontWeight: FontWeight.w900,
                  fontSize: 20.sp,
                  color: const Color(0xFF2F2A44),
                ),
              ),
            ],
          ),
          14.h.spaceH,
          LocaleKeys.energyBridgeExplainerBody.tr().appText(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: const Color(0xFF504A67),
            textAlign: TextAlign.start,
          ),
          20.h.spaceH,
          BaseButton(
            onTap: () => Navigator.of(context).pop(),
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
              child: LocaleKeys.energyBridgeExplainerGotIt.tr().appText(
                fontWeight: FontWeight.w900,
                fontSize: 15.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
