import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/action_consent_screen.dart';

import 'bloc/family_sharing_consent_cubit.dart';
import 'bloc/family_sharing_consent_state.dart';

/// Screen 74: Family Sharing Consent Explainer.
/// Conforms to AGENTS.md §5.1 and v2-doc/04_DATABASE_SCHEMA_AND_OFFLINE_RULES.md.
class FamilySharingConsentScreen extends StatefulWidget {
  const FamilySharingConsentScreen({super.key});

  @override
  State<FamilySharingConsentScreen> createState() =>
      _FamilySharingConsentScreenState();
}

class _FamilySharingConsentScreenState
    extends State<FamilySharingConsentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FamilySharingConsentCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilySharingConsentCubit, FamilySharingConsentState>(
      listener: (BuildContext context, FamilySharingConsentState state) {},
      builder: (BuildContext context, FamilySharingConsentState state) {
        final String childName = state.childName;
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
          checklist: const <String>[
            "You choose exactly what each person can see",
            "Health notes and mentorship summaries stay private by default",
            "Your own reflections are never shared with anyone",
          ],
          footerNote: "You can change this any time in Settings.",
          primaryButtonText: "Continue",
          onPrimaryAction: () {
            context.read<FamilySharingConsentCubit>().grantConsent();
            context.pushReplacement(RoutePaths.inviteCaregiver);
          },
          secondaryButtonText: "Not now",
          onSecondaryAction: () => context.pop(),
        );
      },
    );
  }
}
