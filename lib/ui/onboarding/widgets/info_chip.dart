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
  });
  final String chipTitle;
  final IconData iconData;
  final Color color;
  final Color bgColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(70),
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
