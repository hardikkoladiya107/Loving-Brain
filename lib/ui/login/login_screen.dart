import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/parent_profile/parent_profile_screen.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../home_screen/home_screen.dart';
import '../widget/base_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgLoginBg.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              156.spaceH,
              _loginIcon(),
              60.spaceH,
              _email(),
              12.spaceH,
              _password(),
              12.spaceH,
              _forgotPassword(),
              24.spaceH,
              _loginButton(),
              12.spaceH,
              _dontHaveAccount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              LocaleKeys.login.tr().appText(
                color: blueTextColor,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
              LocaleKeys.appName.tr().appText(
                color: blueTextColor,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ],
          ).appPadding(left: 16, right: 16, top: 8, bottom: 8),
        ),
      ],
    );
  }

  Widget _loginButton() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: blueButtonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.login.tr().appText(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ],
        ).appPadding(top: 10, bottom: 10),
      ),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
    ).appPadding(left: 24, right: 24);
  }

  Widget _dontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LocaleKeys.donHaveAnAccount.tr().appText(color: blackTextColor),
        10.spaceW,
        BaseButton(
          child: LocaleKeys.signUp.tr().appText(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ParentProfileScreen(),
              ),
            );
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChildProfileScreen(  )));
          },
        ),
      ],
    );
  }

  Widget _email() {
    return AppTextField(
      filled: false,
      tfType: TFTYPE.UNDELINED,
      prefixIcon: Assets.icons.icEmailPrefixIcon.image(),
    ).appPadding(left: 20, right: 20);
  }

  Widget _password() {
    return AppTextField(
      filled: false,
      tfType: TFTYPE.UNDELINED,
      prefixIcon: Assets.icons.icPasswordPrefixIcon.image(),
    ).appPadding(left: 20, right: 20);
  }

  Widget _forgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BaseButton(
          child: LocaleKeys.forgotPassword.tr().appText(
            fontWeight: FontWeight.w600,
          ),
          onTap: () {},
        ),
        20.spaceW,
      ],
    );
  }
}
