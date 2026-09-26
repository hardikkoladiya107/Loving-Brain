import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/ui/widget/action_consent_screen.dart';

class MicrophonePermissionScreen extends StatelessWidget {
  const MicrophonePermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionConsentScreen(
      headerImage: Image.asset(
        Assets.v2.images.imgCuteCloud.path,
        width: 200.w,
        height: 200.w,
        fit: BoxFit.contain,
      ),
      title: "Can we use the microphone?",
      subtitle:
          "So you can talk to Brainy and record notes with one hand free.",
      checklist: const [
        "Record a quick note without typing",
        "Ask Brainy a question out loud",
        "Recordings are only made while you're holding the button",
      ],
      footerNote: "You can change this any time in Settings.",
      primaryButtonText: "Allow microphone",
      onPrimaryAction: () => Navigator.pop(context),
      secondaryButtonText: "Not now",
      onSecondaryAction: () => Navigator.pop(context),
    );
  }
}
