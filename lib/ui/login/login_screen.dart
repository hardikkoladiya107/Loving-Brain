import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/child_profile/child_profile_screen.dart';
import 'package:loving_brain/ui/home_screen/home_screen.dart';
import 'package:loving_brain/ui/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/snack_bar.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../parent_profile/parent_profile_screen.dart';
import '../register/register_screen.dart';
import '../widget/base_button.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      builder: (context, state) {
        if (emailTextEditingController.value.text != state.emailAddress) {
          emailTextEditingController.value = emailTextEditingController.value
              .copyWith(
                text: state.emailAddress,
                selection: TextSelection.collapsed(
                  offset: min(
                    emailTextEditingController.value.selection.start,
                    state.emailAddress.length,
                  ),
                ),
              );
        }

        if (passwordTextEditingController.value.text != state.password) {
          passwordTextEditingController.value = passwordTextEditingController
              .value
              .copyWith(
                text: state.password,
                selection: TextSelection.collapsed(
                  offset: min(
                    passwordTextEditingController.value.selection.start,
                    state.password.length,
                  ),
                ),
              );
        }

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
                  _email(state),
                  12.spaceH,
                  _password(state),
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
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          initial: () {},
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            _loggedInSuccess(data);
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
          },
        );
      },
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
            context.read<LoginCubit>().clearFields();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _email(LoginState state) {
    return AppTextField(
      controller: emailTextEditingController,
      title: LocaleKeys.emailAddress.tr(),
      hint: LocaleKeys.enterEmailAddress.tr(),
      error: state.emailAddressError,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Assets.icons.icEmailPrefixIcon.image(
        height: 30,
        width: 30,
        color: Colors.grey,
      ),
      onChanged: (value) {
        context.read<LoginCubit>().changeProps(emailAddress: value);
      },
    ).appPadding(left: 20, right: 20);
  }

  Widget _password(LoginState state) {
    return AppTextField(
      controller: passwordTextEditingController,
      title: LocaleKeys.password.tr(),
      hint: LocaleKeys.enterPassword.tr(),
      error: state.passwordError,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: Assets.icons.icPasswordPrefixIcon.image(
        height: 30,
        width: 30,
        color: Colors.grey,
      ),
      obscureText: state.obscureTextPassword,
      maxLines: 1,
      suffixIcon: IconButton(
        icon: Icon(
          state.obscureTextPassword ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          context.read<LoginCubit>().changeProps(
            obscureTextPassword: !state.obscureTextPassword,
          );
        },
      ),
      onChanged: (value) {
        context.read<LoginCubit>().changeProps(password: value);
      },
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
          onTap: () {
            context.read<LoginCubit>().clearFields();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen(),
              ),
            );
          },
        ),
        20.spaceW,
      ],
    );
  }

  Future<void> _loggedInSuccess(Map<String, dynamic> data) async {
    var userModel = UserModel.fromJson(data);
    context.read<LoginCubit>().clearFields();
    EasyLoading.dismiss();

    if (userModel.uid == null) {
      return;
    }

    if ((userModel.parentName ?? "").isEmpty ||
        (userModel.parentGender ?? "").isEmpty ||
        (userModel.parentEmail ?? "").isEmpty ||
        userModel.parentDateOfBirth == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ParentProfileScreen(userId: userModel.uid!),
        ),
      );
    } else if ((userModel.childName ?? "").isEmpty ||
        (userModel.childAge ?? "").isEmpty ||
        (userModel.relationshipToChild ?? "").isEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChildProfileScreen(userId: userModel.uid!),
        ),
      );
    } else {
      await preferences.putBool(SharedPreference.isLogin, true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}
