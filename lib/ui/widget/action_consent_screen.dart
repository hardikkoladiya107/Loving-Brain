import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

class ActionConsentScreen extends StatelessWidget {
  final Widget headerImage;
  final String title;
  final String? subtitle;
  final List<String> checklist;
  final String footerNote;
  final String primaryButtonText;
  final VoidCallback onPrimaryAction;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryAction;

  const ActionConsentScreen({
    super.key,
    required this.headerImage,
    required this.title,
    this.subtitle,
    required this.checklist,
    required this.footerNote,
    required this.primaryButtonText,
    required this.onPrimaryAction,
    this.secondaryButtonText,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              Color(0xFFFFE0E0), // Light red/pink
              Color(0xFFFFF8F0), // Very light orange/white
              Color(0xFFF9FAFB),
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        40.spaceH,
                        headerImage,
                        24.spaceH,
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: const Color(0xFF1E293B),
                            fontFamily: 'Fraunces',
                            height: 1.2,
                          ),
                        ),
                        if (subtitle != null) ...[
                          12.spaceH,
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                        ],
                        32.spaceH,
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: checklist.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: item == checklist.last ? 0 : 16.h,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: const Color(
                                        0xFF5C6BC0,
                                      ), // Purple check
                                      size: 24.sp,
                                    ),
                                    12.spaceW,
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: const Color(0xFF1E293B),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        16.spaceH,
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 16.h,
                            horizontal: 24.w,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF), // Light purple
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            footerNote,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ),
                        40.spaceH, // Spacing before sticky bottom
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.h, top: 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        title: primaryButtonText,
                        onTap: onPrimaryAction,
                      ),
                      if (secondaryButtonText != null) ...[
                        16.spaceH,
                        InkWell(
                          onTap: onSecondaryAction ?? () {},
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Text(
                              secondaryButtonText!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
