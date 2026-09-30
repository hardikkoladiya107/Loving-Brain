import 'package:flutter/material.dart';
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
    this.padding = const EdgeInsets.only(left: 16, right: 16),
    this.isLoading = false,
    this.loaderColor,
  });

  final String? title;
  final double? height;
  final Widget? widget;
  final BorderRadius? borderRadius;
  final GestureTapCallback? onTap;
  final Color backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final Color? loaderColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: BaseButton(
        onTap: isLoading ? null : onTap,
        child: Container(
          height: height ?? 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(50),
            border: Border.all(color: borderColor ?? backgroundColor, width: 1),
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: loaderColor ?? textColor ?? Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : widget ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (title ?? "").appText(
                          color: textColor ?? Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
