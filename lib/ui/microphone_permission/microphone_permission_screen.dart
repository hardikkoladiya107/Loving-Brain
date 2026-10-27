import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/ui/widget/action_consent_screen.dart';

import 'bloc/microphone_permission_cubit.dart';
import 'bloc/microphone_permission_state.dart';

/// Screen 73: Microphone Permission Explainer.
/// Conforms to AGENTS.md §5.1.
class MicrophonePermissionScreen extends StatefulWidget {
  const MicrophonePermissionScreen({super.key});

  @override
  State<MicrophonePermissionScreen> createState() =>
      _MicrophonePermissionScreenState();
}

class _MicrophonePermissionScreenState
    extends State<MicrophonePermissionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MicrophonePermissionCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MicrophonePermissionCubit, MicrophonePermissionState>(
      listener: (BuildContext context, MicrophonePermissionState state) {},
      builder: (BuildContext context, MicrophonePermissionState state) {
        return ActionConsentScreen(
          headerImage: Image.asset(
            Assets.v2.images.imgCuteCloud.path,
            width: 140.w,
            height: 140.w,
            fit: BoxFit.contain,
          ),
          title: "Can we use the\nmicrophone?",
          subtitle:
              "So you can talk to Brainy and record notes with\none hand free.",
          checklist: const <String>[
            "Record a quick note without typing",
            "Ask Brainy a question out loud",
            "Recordings are only made while you're holding the button",
          ],
          footerNote: "You can change this any time in Settings.",
          primaryButtonText: "Allow microphone",
          onPrimaryAction: () async {
            final bool granted = await context
                .read<MicrophonePermissionCubit>()
                .grantPermission();
            if (context.mounted) {
              Navigator.of(context).pop(granted);
            }
          },
          secondaryButtonText: "Not now",
          onSecondaryAction: () => Navigator.of(context).pop(false),
        );
      },
    );
  }
}
