import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class PersonCard extends StatelessWidget {
  final Widget avatar;
  final String name;
  final String subtitle;
  final Widget? statusPill;
  final bool showChevron;
  final VoidCallback? onTap;

  const PersonCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.subtitle,
    this.statusPill,
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(width: 56.w, height: 56.w, child: avatar),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  name.appText(
                    fontSize: 16.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w600,
                  ),
                  4.spaceH,
                  subtitle.appText(
                    fontSize: 14.sp,
                    color: greyColor,
                    textAlign: TextAlign.start,
                  ),
                  if (statusPill != null) ...[8.spaceH, statusPill!],
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, color: greyColor, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
