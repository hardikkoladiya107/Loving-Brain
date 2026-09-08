import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/gen/assets.gen.dart';

import 'bloc/onboarding_snapshot_cubit.dart';
import 'bloc/onboarding_snapshot_state.dart';

class OnboardingSnapshotScreen extends StatefulWidget {
  const OnboardingSnapshotScreen({super.key});

  @override
  State<OnboardingSnapshotScreen> createState() =>
      _OnboardingSnapshotScreenState();
}

class _OnboardingSnapshotScreenState extends State<OnboardingSnapshotScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted) return;
      context.read<OnboardingSnapshotCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingSnapshotCubit, OnboardingSnapshotState>(
      listener: (BuildContext context, OnboardingSnapshotState state) {},
      builder: (BuildContext context, OnboardingSnapshotState state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.v2.images.imgBg.path),
            ),
          ),
          child: const Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(child: SizedBox.shrink()),
          ),
        );
      },
    );
  }
}
