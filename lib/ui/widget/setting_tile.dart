import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class SettingTile extends StatelessWidget {
  final Widget icon;
  final Color iconBackgroundColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: icon),
            ),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.appText(
                    fontSize: 16.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  if (subtitle != null) ...[
                    4.spaceH,
                    subtitle!.appText(
                      fontSize: 14.sp,
                      color: greyColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ],
              ),
            ),
            16.spaceW,
            Icon(Icons.chevron_right, color: greyColor, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
