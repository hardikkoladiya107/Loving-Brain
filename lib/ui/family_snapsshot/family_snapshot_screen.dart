import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/onboarding/widgets/app_card.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/family_snapshot_cubit.dart';
import 'bloc/family_snapshot_state.dart';

class FamilySnapshotScreen extends StatefulWidget {
  const FamilySnapshotScreen({super.key});

  @override
  State<FamilySnapshotScreen> createState() => _FamilySnapshotScreenState();
}

class _FamilySnapshotScreenState extends State<FamilySnapshotScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FamilySnapshotCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilySnapshotCubit, FamilySnapshotState>(
      listener: (BuildContext context, FamilySnapshotState state) {},
      builder: (BuildContext context, FamilySnapshotState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Assets.v2.images.imgFamilySnapshotBg.path,
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: ListView(
                  children: [
                    260.spaceH,
                    "Here’s your\nfamily snapshot".appText(
                      textStyle: getTextStyle(
                        fraunces: true,
                        fontSize: 30,
                        height: 1.1,
                      ),
                    ),
                    10.spaceH,
                    "Based on what you’ve told us about ${state.childName}."
                        .appText(color: greyColor),
                    16.spaceH,
                    AppCard(
                      chipTitle: "What we noticed",
                      title: state.whatWeNoticed,
                      subtitle:
                          "We’ll shape your calm routines and daytime rhythms around this window.",
                    ),
                    16.spaceH,
                    AppCard(
                      chipTitle: "Try this first",
                      title: state.tryThisFirst,
                      subtitle:
                          "Small consistent shifts help bedtime and routines feel predictable.",
                    ),
                    24.spaceH,
                    AppButton(
                      onTap: () {
                        preferences.putBool(SharedPreference.isLogin, true);
                        context.go(RoutePaths.base);
                      },
                      title: "Go to Today",
                    ),
                    32.spaceH,
                  ],
                ).appPadding(left: 20.r, right: 20.r),
              ),
            ],
          ),
        );
      },
    );
  }
}
