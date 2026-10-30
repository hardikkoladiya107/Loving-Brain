import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
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
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) {},
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF8F4),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          leading: Navigator.canPop(context)
              ? Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: darkBlue,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFFEF8F4),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFDFD4), // Soft warm peach glow at top
                Color(0xFFFFF9F5), // Warm cream center
                Color(0xFFFFF9F5),
                Color(0xFFFFDFD4), // Soft warm peach glow at bottom
              ],
              stops: [0.0, 0.22, 0.78, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          24.spaceH,
                          headerImage,
                          20.spaceH,
                          title.appText(
                            fraunces: true,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                            textAlign: TextAlign.center,
                            height: 1.25,
                          ),
                          if (subtitle != null) ...[
                            10.spaceH,
                            subtitle!.appText(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                              textAlign: TextAlign.center,
                              height: 1.4,
                            ),
                          ],
                          24.spaceH,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF1E293B,
                                  ).withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: checklist.map((String item) {
                                final bool isLast = item == checklist.last;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: isLast ? 0 : 16.h,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 22.sp,
                                        height: 22.sp,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF665FCE),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                      ),
                                      12.spaceW,
                                      Expanded(
                                        child: item.appText(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: darkBlue,
                                          textAlign: TextAlign.start,
                                          height: 1.35,
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
                              vertical: 12.h,
                              horizontal: 16.w,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F1FB),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: footerNote.appText(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          24.spaceH,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h, top: 12.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton(
                          title: primaryButtonText,
                          onTap: onPrimaryAction,
                        ),
                        if (secondaryButtonText != null) ...[
                          12.spaceH,
                          GestureDetector(
                            onTap:
                                onSecondaryAction ??
                                () => Navigator.of(context).pop(false),
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: secondaryButtonText!.appText(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                                textAlign: TextAlign.center,
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
      ),
    );
  }
}
