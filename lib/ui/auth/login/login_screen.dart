import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/child_profile/child_profile_screen.dart';
import 'package:loving_brain/ui/auth/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../main.dart';
import '../../../other/app_color.dart';
import '../../../other/snack_bar.dart';
import '../../base_screen/base_screen.dart';
import '../../parent_profile/parent_profile_screen.dart';
import '../../privacy_policy/privacy_policy_screen.dart';
import '../../terms_and_conditions/terms_and_conditions.dart';
import '../../widget/base_button.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../register/register_screen.dart';
import 'bloc/login_state.dart';
import 'package:flutter/gestures.dart';

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
                  80.spaceH,
                  _loginIcon(),
                  40.spaceH,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            _email(state),
                            12.spaceH,
                            _password(state),
                            4.spaceH,
                            _forgotPassword(),
                            16.spaceH,
                            _loginButton(),
                            16.spaceH,
                            _dontHaveAccount(),
                          ],
                        ),
                      ),
                    ),
                  ).appPadding(left: 20, right: 20),
                  30.spaceH,
                  _signUpWithGoogle(),
                  16.spaceH,
                  if (Platform.isIOS) _signUpWithApple(),
                  60.spaceH,
                  _buildTermsText(),
                  40.spaceH,
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
            showSnackBar(message: error.toString().replaceAll("Exception: ", ""), type: SnackBarType.ERROR);
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
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icGoogleIcon.image(height: 24, width: 24),
            20.spaceW,
            LocaleKeys.continueWithGoogle
                .tr()
                .appText(fontWeight: FontWeight.w700, fontSize: 14)
                .appPadding(top: 14, bottom: 14),
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
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icAppleIcon.image(height: 24, width: 24),
            20.spaceW,
            LocaleKeys.continueWithApple
                .tr()
                .appText(fontWeight: FontWeight.w700, fontSize: 14)
                .appPadding(top: 14, bottom: 14),
          ],
        ),
      ),
    );
  }

  Widget _loginIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: Column(
                children: [
                  LocaleKeys.login.tr().appText(
                    color: blueTextColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                  LocaleKeys.appName.tr().appText(
                    color: blueTextColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ],
              ).appPadding(left: 20, right: 20, top: 12, bottom: 12),
            ),
          ),
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
          boxShadow: [
            BoxShadow(
              color: blueButtonColor.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.login.tr().appText(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ],
        ).appPadding(top: 14, bottom: 14),
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
    EasyLoading.dismiss();
    var userModel = UserModel.fromJson(data);
    await preferences.saveUserModel(userModel);
    if (context.mounted) {
      context.read<LoginCubit>().clearFields();
      if (userModel.uid == null) {
        return;
      }
      if ((userModel.parentName ?? "").isEmpty ||
          (userModel.parentGender ?? "").isEmpty ||
          (userModel.parentEmail ?? "").isEmpty ||
          userModel.parentDateOfBirth == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ParentProfileScreen( ),
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
          MaterialPageRoute(builder: (context) => const BaseScreen()),
        );
      }
    }
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: getTextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(text: "By continuing, you agree to our\n"),
          TextSpan(
            text: "Terms & Conditions",
            style: getTextStyle(
               color: blueTextColor,
               fontSize: 12,
               fontWeight: FontWeight.bold,
               textDecoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsScreen(),
                ));
              },
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy",
            style: getTextStyle(
               color: blueTextColor,
               fontSize: 12,
               fontWeight: FontWeight.bold,
               textDecoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ));
              },
          ),
          TextSpan(text: "."),
        ],
      ),
    ).appPadding(left: 24, right: 24);
  }
}
