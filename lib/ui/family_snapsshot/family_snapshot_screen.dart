import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/onboarding/widgets/app_card.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../other/app_color.dart';
import 'bloc/family_snapshot_cubit.dart';
import 'bloc/family_snapshot_state.dart';

class FamilySnapshotScreen extends StatelessWidget {
  const FamilySnapshotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FamilySnapshotCubit()..init(),
      child: BlocBuilder<FamilySnapshotCubit, FamilySnapshotState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(Assets.v2.images.imgFamilySnapshotBg.path),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: ListView(
                  children: [
                    180.spaceH,
                    "Here’s your\nfamily snapshot".appText(
                      textStyle: getTextStyle(
                        fraunces: true,
                        fontSize: 30,
                        height: 0.8,
                      ),
                    ),
                    10.spaceH,
                    "Based on what you’ve told us about ${state.childName}."
                        .appText(color: greyColor),
                    12.spaceH,
                    AppCard(
                      chipTitle: "What we noticed",
                      title: state.whatWeNoticed,
                    ),
                    24.spaceH,
                    AppCard(
                      chipTitle: "Try this first",
                      title: state.tryThisFirst,
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
            ),
          );
        },
      ),
    );
  }
}
