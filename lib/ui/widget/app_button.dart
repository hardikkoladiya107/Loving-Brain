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
    this.widget,
    this.borderRadius,
    this.height,
    this.padding = const EdgeInsets.only(left: 16, right: 16),
  });

  final String? title;
  final double? height;
  final Widget? widget;
  final BorderRadius? borderRadius;
  final GestureTapCallback? onTap;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: BaseButton(
        onTap: onTap,
        child: Container(
          height: height ?? 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(50),
          ),
          child:
              widget ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (title ?? "").appText(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
