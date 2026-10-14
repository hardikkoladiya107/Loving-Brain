import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/ui/invite_caregiver/invite_caregiver_screen.dart';
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
  late final FamilySharingConsentCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = FamilySharingConsentCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.init();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<FamilySharingConsentCubit, FamilySharingConsentState>(
        bloc: _cubit,
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
              _cubit.grantConsent();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
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
