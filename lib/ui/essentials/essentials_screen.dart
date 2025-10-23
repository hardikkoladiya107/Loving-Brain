import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../generated/locale_keys.g.dart';
import '../widget/base_button.dart';
import 'bloc/essentials_cubit.dart';
import 'bloc/essentials_state.dart';

class EssentialsScreen extends StatefulWidget {
  const EssentialsScreen({super.key});

  @override
  State<EssentialsScreen> createState() => _EssentialsScreenState();
}

class _EssentialsScreenState extends State<EssentialsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<EssentialsCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EssentialsCubit, EssentialsState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [_backgroundImage(), _essentialsBody(state)],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _backgroundImage() {
    return Column(
      children: [
        Assets.images.imgEssentialsBg.image(
          height: context.height,
          fit: BoxFit.cover,
        ),
        Container(height: context.height / 2),
      ],
    );
  }

  Widget _header(EssentialsState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: "${state.childModel?.childName ?? ""}'s Essentials"
          .appText(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          )
          .appPadding(left: 10, right: 10, top: 6, bottom: 6),
    );
  }

  Widget _essentialsBody(EssentialsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        45.h.spaceH,
        _appBar(),
        80.spaceH,
        _header(state),
        130.spaceH,
        Row(),
        LocaleKeys.sharedInformationBothParentsSamePage.tr().appText(
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ],
    ).appPadding(left: 20.w,right: 20.w);
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(height: 36, width: 36),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
