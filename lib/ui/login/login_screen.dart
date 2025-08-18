import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/parent_profile/parent_profile_screen.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../widget/base_button.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      builder: (context, state) {
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
                  24.spaceH,
                  _signUpWithGoogle(),

                  24.spaceH,
                  if (Platform.isIOS) _signUpWithApple(),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _signUpWithGoogle() {
    return BaseButton(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icGoogleIcon.image(height: 24, width: 24),
            20.spaceW,
            LocaleKeys.signUpWithGoogle
                .tr()
                .appText(fontWeight: FontWeight.w700, fontSize: 14)
                .appPadding(top: 8, bottom: 8),
          ],
        ),
      ),
      onTap: () {
        context.read<LoginCubit>().googleAuthenticate();
      },
    );
  }

  Widget _signUpWithApple() {
    return BaseButton(
      onTap: () {
        context.read<LoginCubit>().signInWithApple();
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icAppleIcon.image(height: 24, width: 24),
            20.spaceW,
            LocaleKeys.signInWithApple
                .tr()
                .appText(fontWeight: FontWeight.w700, fontSize: 14)
                .appPadding(top: 10, bottom: 10),
          ],
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
        context.read<LoginCubit>().performLogin();
        // Navigator.of(
        //   context,
        // ).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
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
          },
        ),
      ],
    );
  }

  Widget _email() {
    return AppTextField(
      prefixIcon: Assets.icons.icEmailPrefixIcon.image(
        height: 30,
        width: 30,
        color: Colors.grey,
      ),
      keyboardType: TextInputType.emailAddress,
      hint: "Enter Email",
    ).appPadding(left: 20, right: 20);
  }

  Widget _password() {
    return AppTextField(
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: Assets.icons.icPasswordPrefixIcon.image(
        height: 30,
        width: 30,
        color: Colors.grey,
      ),
      hint: "Enter password",
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
