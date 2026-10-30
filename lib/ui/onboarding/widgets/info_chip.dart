import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.chipTitle,
    this.iconData = Icons.info,
    this.color = primaryColor,
    this.bgColor = orangeLightColor,
    this.padding,
    this.borderColor,
    this.fontWeight = FontWeight.w500,
    this.letterSpacing,
  });
  final String chipTitle;
  final IconData iconData;
  final Color color;
  final Color bgColor;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final FontWeight fontWeight;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(70),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: color, size: 24),
          6.spaceW,
          Flexible(
            child: chipTitle.appText(
              fontSize: 14,
              color: color,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
            ),
          ),
        ],
      ),
    );
  }
}
