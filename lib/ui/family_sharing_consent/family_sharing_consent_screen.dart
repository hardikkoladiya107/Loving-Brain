import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/ui/invite_caregiver/invite_caregiver_screen.dart';
import 'package:loving_brain/ui/widget/action_consent_screen.dart';

import 'bloc/family_sharing_consent_cubit.dart';
import 'bloc/family_sharing_consent_state.dart';

class FamilySharingConsentScreen extends StatelessWidget {
  const FamilySharingConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FamilySharingConsentCubit()..init(),
      child: BlocBuilder<FamilySharingConsentCubit, FamilySharingConsentState>(
        builder: (context, state) {
          final childName = context.read<FamilySharingConsentCubit>().childName;
          return ActionConsentScreen(
            headerImage: Image.asset(
              Assets.v2.images.imgHumi.path,
              width: 200.w,
              height: 200.w,
              fit: BoxFit.contain,
            ),
            title: "Before you invite someone",
            subtitle:
                "Sharing helps you and a partner see the same picture of $childName.",
            checklist: const [
              "You choose exactly what each person can see",
              "Health notes and mentorship summaries stay private by default",
              "Your own reflections are never shared with anyone",
            ],
            footerNote: "You can change this any time in Settings.",
            primaryButtonText: "Continue",
            onPrimaryAction: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const InviteCaregiverScreen(),
                ),
              );
            },
            secondaryButtonText: "Not now",
            onSecondaryAction: () => Navigator.pop(context),
          );
        },
      ),
    );
  }
}
