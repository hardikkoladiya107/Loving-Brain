import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../generated/locale_keys.g.dart';
import 'bloc/essentials_cubit.dart';
import 'bloc/essentials_state.dart';

class EssentialsScreen extends StatefulWidget {
  const EssentialsScreen({super.key});

  @override
  State<EssentialsScreen> createState() => _EssentialsScreenState();
}

class _EssentialsScreenState extends State<EssentialsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EssentialsCubit, EssentialsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgEssentialsBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                150.spaceH,
                _header(),
                130.spaceH,
                Row(),
                LocaleKeys.sharedInformationBothParentsSamePage.tr().appText(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: "Rohan's Essentials"
          .appText(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          )
          .appPadding(left: 10, right: 10, top: 6, bottom: 6),
    );
  }
}
