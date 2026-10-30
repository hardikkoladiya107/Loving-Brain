import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../other/app_color.dart';
import 'base_button.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.title,
    required this.onTap,
    this.backgroundColor = primaryColor,
    this.borderColor,
    this.textColor,
    this.widget,
    this.borderRadius,
    this.height,
    this.width,
    this.padding = const EdgeInsets.only(left: 16, right: 16),
    this.isLoading = false,
    this.loaderColor,
    this.loaderSize,
    this.fontSize,
    this.contentPadding,
  });

  final String? title;
  final double? height;
  final double? width;
  final Widget? widget;
  final BorderRadius? borderRadius;
  final GestureTapCallback? onTap;
  final Color backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final Color? loaderColor;
  final double? loaderSize;
  final double? fontSize;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: BaseButton(
        onTap: isLoading ? null : onTap,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(50),
            border: Border.all(color: borderColor ?? backgroundColor, width: 1),
          ),
          child: isLoading
              ? Center(
                  child: SpinKitThreeBounce(
                    color: loaderColor ?? textColor ?? Colors.white,
                    size: loaderSize ?? 24.r,
                  ),
                )
              : Center(
                  child:
                      widget ??
                      Padding(
                        padding:
                            contentPadding ??
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: (title ?? "").appText(
                          color: textColor ?? Colors.white,
                          fontSize: fontSize ?? 16,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                ),
        ),
      ),
    );
  }
}
