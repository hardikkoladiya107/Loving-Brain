import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

class AlertBottomSheet extends StatelessWidget {
  final Widget icon;
  final String title;
  final String message;
  final String? cardTitle;
  final String? cardMessage;
  final String primaryButtonText;
  final VoidCallback onPrimaryAction;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryAction;
  final String? tertiaryButtonText;
  final VoidCallback? onTertiaryAction;
  final Color alertColor;
  final String alertPillText;
  final IconData alertPillIcon;

  const AlertBottomSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.cardTitle,
    this.cardMessage,
    required this.primaryButtonText,
    required this.onPrimaryAction,
    this.secondaryButtonText,
    this.onSecondaryAction,
    this.tertiaryButtonText,
    this.onTertiaryAction,
    this.alertColor = const Color(0xFFD32F2F),
    required this.alertPillText,
    this.alertPillIcon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          24.spaceH,
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(alertPillIcon, color: alertColor, size: 16.sp),
                      6.spaceW,
                      Text(
                        alertPillText,
                        style: TextStyle(
                          color: alertColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                16.spaceH,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: alertColor,
                    fontFamily: 'Fraunces',
                  ),
                ),
                8.spaceH,
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: alertColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (cardTitle != null || cardMessage != null) ...[
            12.spaceH,
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cardTitle != null)
                    Text(
                      cardTitle!,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xFF1E293B),
                        fontFamily: 'Fraunces',
                      ),
                    ),
                  if (cardTitle != null && cardMessage != null) 8.spaceH,
                  if (cardMessage != null)
                    Text(
                      cardMessage!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
          ],
          24.spaceH,
          AppButton(title: primaryButtonText, onTap: onPrimaryAction),
          if (secondaryButtonText != null) ...[
            12.spaceH,
            AppButton(
              title: secondaryButtonText!,
              backgroundColor: Colors.transparent,
              textColor: const Color(0xFF1E293B),
              borderColor: const Color(0xFFE2E8F0),
              onTap: onSecondaryAction ?? () {},
            ),
          ],
          if (tertiaryButtonText != null) ...[
            16.spaceH,
            Center(
              child: InkWell(
                onTap: onTertiaryAction ?? () {},
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    tertiaryButtonText!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static void showError(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertBottomSheet(
        icon: const SizedBox.shrink(),
        alertPillText: "Didn't save",
        title: "Something went wrong",
        message:
            "We couldn't save that update just now. Nothing you typed has been lost.",
        cardTitle: "Your update",
        cardMessage: "Bedtime 8:10 PM Â· woke 6:45 AM Â· quality 3 of 5",
        primaryButtonText: "Try again",
        onPrimaryAction: () => Navigator.pop(context),
        secondaryButtonText: "Save on this device for now",
        onSecondaryAction: () => Navigator.pop(context),
      ),
    );
  }

  static void showSafetyConcern(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertBottomSheet(
        icon: const SizedBox.shrink(),
        alertPillText: "This may need professional attention",
        title: "Please contact a health professional",
        message:
            "A fever with reduced drinking in a child this age is something a clinician should look at. LovingBrain can't assess symptoms.",
        primaryButtonText: "Call emergency services",
        onPrimaryAction: () => Navigator.pop(context),
        secondaryButtonText: "Read safety information",
        onSecondaryAction: () => Navigator.pop(context),
        tertiaryButtonText: "Not now go back to Brainy",
        onTertiaryAction: () => Navigator.pop(context),
      ),
    );
  }
}
