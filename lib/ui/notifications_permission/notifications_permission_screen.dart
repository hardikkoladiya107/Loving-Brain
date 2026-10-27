import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/ui/widget/action_consent_screen.dart';

import 'bloc/notifications_permission_cubit.dart';
import 'bloc/notifications_permission_state.dart';

/// Screen 72: Notification Permission Explainer.
/// Conforms to AGENTS.md §5.1.
class NotificationsPermissionScreen extends StatefulWidget {
  const NotificationsPermissionScreen({super.key});

  @override
  State<NotificationsPermissionScreen> createState() =>
      _NotificationsPermissionScreenState();
}

class _NotificationsPermissionScreenState
    extends State<NotificationsPermissionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsPermissionCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      NotificationsPermissionCubit,
      NotificationsPermissionState
    >(
      listener: (BuildContext context, NotificationsPermissionState state) {},
      builder: (BuildContext context, NotificationsPermissionState state) {
        return ActionConsentScreen(
          headerImage: Image.asset(
            Assets.v2.images.imgBrainyHome.path,
            width: 140.w,
            height: 140.w,
            fit: BoxFit.contain,
          ),
          title: "Can we send you a nudge?",
          subtitle: "Only when it's genuinely useful we'd rather send less.",
          checklist: const <String>[
            "A reminder as the wind-down window approaches",
            "A note when your weekly review is ready",
            "Never a message about a missed day or a broken streak",
          ],
          footerNote: "You can change this any time in Settings.",
          primaryButtonText: "Allow notifications",
          onPrimaryAction: () async {
            final bool granted = await context
                .read<NotificationsPermissionCubit>()
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
