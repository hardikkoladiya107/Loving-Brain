import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/ui/widget/action_consent_screen.dart';

import 'bloc/notifications_permission_cubit.dart';
import 'bloc/notifications_permission_state.dart';

class NotificationsPermissionScreen extends StatelessWidget {
  const NotificationsPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsPermissionCubit()..init(),
      child:
          BlocBuilder<
            NotificationsPermissionCubit,
            NotificationsPermissionState
          >(
            builder: (context, state) {
              final childName = context
                  .read<NotificationsPermissionCubit>()
                  .childName;
              return ActionConsentScreen(
                headerImage: Image.asset(
                  Assets.v2.images.imgSprout.path,
                  width: 200.w,
                  height: 200.w,
                  fit: BoxFit.contain,
                ),
                title: "Would you like to turn on notifications?",
                subtitle: "Get timely nudges for bedtime routines and insights.",
                checklist: [
                  "Receive gentle bedtime reminders",
                  "Get notified when a new mentorship summary is ready",
                  "Stay up to date with $childName's changing patterns",
                ],
                footerNote: "You can change this any time in Settings.",
                primaryButtonText: "Allow notifications",
                onPrimaryAction: () => Navigator.pop(context),
                secondaryButtonText: "Not now",
                onSecondaryAction: () => Navigator.pop(context),
              );
            },
          ),
    );
  }
}
