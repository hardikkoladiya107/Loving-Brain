import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class InfoBox extends StatelessWidget {
  final IconData? iconData;
  final String? title;
  final String body;
  final Color backgroundColor;
  final Color textColor;
  final Color? iconColor;

  const InfoBox({
    super.key,
    this.iconData,
    this.title,
    required this.body,
    required this.backgroundColor,
    required this.textColor,
    this.iconColor,
  });

  factory InfoBox.orange({
    IconData? iconData = Icons.info,
    String? title,
    required String body,
  }) {
    return InfoBox(
      iconData: iconData,
      title: title,
      body: body,
      backgroundColor: softPeachOrange,
      textColor: greyColor9,
      iconColor: primaryColor,
    );
  }

  factory InfoBox.white({
    IconData? iconData = Icons.info,
    String? title,
    required String body,
    Color? iconColor,
  }) {
    return InfoBox(
      iconData: iconData,
      title: title,
      body: body,
      backgroundColor: Colors.white,
      textColor: greyColor9,
      iconColor: iconColor ?? greyColor9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          if (title != null || iconData != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (iconData != null) ...[
                  Icon(iconData, color: iconColor ?? textColor, size: 20.sp),
                  8.spaceW,
                ],
                if (title != null)
                  Expanded(
                    child: title!.appText(
                      fontSize: 16.sp,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ),
                  ),
              ],
            ),
          if (title != null || iconData != null) 8.spaceH,
          body.appText(
            fontSize: 14.sp,
            color: textColor,
            textAlign: TextAlign.start,
            height: 1.4,
          ),
        ],
      ),
    );
  }
}
