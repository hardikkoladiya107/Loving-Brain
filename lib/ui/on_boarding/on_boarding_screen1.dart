import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/login/login_screen.dart';
import 'package:loving_brain/ui/on_boarding/on_boarding_screen2.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';

class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgOnBoardingBg1.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: []),
            110.spaceH,
            LocaleKeys.welcomeTo.tr().appText(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            LocaleKeys.lovingBrain.tr().appText(
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
            Spacer(),
            Column(
              children: [
                LocaleKeys.becauseEveryChildDeservesTheBestVersionOfYou
                    .tr()
                    .appText(fontWeight: FontWeight.w700, fontSize: 16)
                    .appPadding(left: 20, right: 20),
                40.spaceH,
                _getStartedButton(),
                20.spaceH,
                _loginButton(),
                60.spaceH,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStartedButton() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(color: yellowButtonColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.getStarted.tr().appText(fontWeight: FontWeight.w700),
          ],
        ).appPadding(top: 10, bottom: 10),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const OnBoardingScreen2()),
        );
      },
    ).appPadding(left: 30, right: 30);
  }

  Widget _loginButton() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.login.tr().appText(fontWeight: FontWeight.w700),
          ],
        ).appPadding(top: 10, bottom: 10),
      ),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
    ).appPadding(left: 30, right: 30);
  }
}
