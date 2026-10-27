import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class AppChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isError;
  final Widget? leading;
  final Color? activeColor;
  final Color? activeBgColor;
  final Color? unselectedTextColor;
  final Color? unselectedBorderColor;
  final Color? unselectedBgColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const AppChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isError = false,
    this.leading,
    this.activeColor,
    this.activeBgColor,
    this.unselectedTextColor,
    this.unselectedBorderColor,
    this.unselectedBgColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveActiveColor = activeColor ?? secondaryColor;
    final Color effectiveActiveBg = activeBgColor ?? indigoLight;
    final Color effectiveUnselectedText = unselectedTextColor ?? darkBlue;
    final Color effectiveUnselectedBorder =
        unselectedBorderColor ?? const Color(0xFFE2DDD8);
    final Color effectiveUnselectedBg = unselectedBgColor ?? Colors.white;

    final Color borderColor = isError && !isSelected
        ? Colors.red
        : (isSelected ? effectiveActiveColor : effectiveUnselectedBorder);

    final Color backgroundColor = isSelected
        ? effectiveActiveBg
        : effectiveUnselectedBg;

    final double effectiveFontSize = fontSize ?? 14;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding:
              padding ??
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.5.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.4.w : 1.w,
            ),
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: effectiveActiveColor.withValues(alpha: 0.15),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ]
                : <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.025),
                      blurRadius: 4.r,
                      offset: Offset(0, 1.h),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (leading != null) ...<Widget>[leading!, 6.spaceW],
              label.appText(
                fontSize: effectiveFontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? effectiveActiveColor
                    : effectiveUnselectedText,
                letterSpacing: 0.15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
