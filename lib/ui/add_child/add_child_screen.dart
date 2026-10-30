import 'package:flutter/material.dart';
import 'package:loving_brain/ui/onboarding/onboarding_screen.dart';

/// Adds another child with the same child pages used in onboarding:
/// little one, usual day, and when things are hardest.
class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen(addAnotherChild: true);
  }
}
