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
        final String childName = state.childName;
        return ActionConsentScreen(
          headerImage: Image.asset(
            Assets.v2.images.imgSprout.path,
            width: 200.w,
            height: 200.w,
            fit: BoxFit.contain,
          ),
          title: "Would you like to turn on notifications?",
          subtitle: "Get timely nudges for bedtime routines and insights.",
          checklist: <String>[
            "Receive gentle bedtime reminders",
            "Get notified when a new mentorship summary is ready",
            "Stay up to date with $childName's changing patterns",
          ],
          footerNote: "You can change this any time in Settings.",
          primaryButtonText: "Allow notifications",
          onPrimaryAction: () {
            context.read<NotificationsPermissionCubit>().grantPermission();
            Navigator.pop(context);
          },
          secondaryButtonText: "Not now",
          onSecondaryAction: () => Navigator.pop(context),
        );
      },
    );
  }
}
