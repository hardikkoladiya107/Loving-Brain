import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';

class CommonInfoCard extends StatelessWidget {
  final String chipTitle;
  final IconData? chipIcon;
  final Color? chipColor;
  final Color? chipBgColor;
  final String? title;
  final double? titleFontSize;
  final String? subtitle;
  final Widget? content;

  const CommonInfoCard({
    super.key,
    required this.chipTitle,
    this.chipIcon = Icons.info,
    this.chipColor,
    this.chipBgColor,
    this.title,
    this.titleFontSize,
    this.subtitle,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: chipTitle,
            iconData: chipIcon ?? Icons.info,
            color: chipColor ?? primaryColor,
            bgColor: chipBgColor ?? orangeLightColor,
          ),
          if (title != null) ...[
            16.spaceH,
            title!.appText(
              fontSize: titleFontSize ?? 22.sp,
              color: greyColor9,
              fraunces: true,
              textAlign: TextAlign.start,
            ),
          ],
          if (subtitle != null) ...[
            12.spaceH,
            subtitle!.appText(
              fontSize: 14.sp,
              color: greyColor6,
              textAlign: TextAlign.start,
            ),
          ],
          if (content != null) ...[
            if (title != null || subtitle != null) 16.spaceH else 24.spaceH,
            content!,
          ],
        ],
      ),
    );
  }
}
