import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/ui/widget/action_consent_screen.dart';

class NotificationsPermissionScreen extends StatelessWidget {
  const NotificationsPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionConsentScreen(
      headerImage: Image.asset(
        Assets.v2.images.imgSprout.path,
        width: 200.w,
        height: 200.w,
        fit: BoxFit.contain,
      ),
      title: "Would you like to turn on notifications?",
      subtitle: "Get timely nudges for bedtime routines and insights.",
      checklist: const [
        "Receive gentle bedtime reminders",
        "Get notified when a new mentorship summary is ready",
        "Stay up to date with Ira's changing patterns",
      ],
      footerNote: "You can change this any time in Settings.",
      primaryButtonText: "Allow notifications",
      onPrimaryAction: () => Navigator.pop(context),
      secondaryButtonText: "Not now",
      onSecondaryAction: () => Navigator.pop(context),
    );
  }
}
