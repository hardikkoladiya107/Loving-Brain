import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/parent_profile/parent_profile_screen.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../widget/app_text_field.dart';
import 'bloc/register_cubit.dart';
import 'bloc/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
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

        if (confirmPasswordTextEditingController.value.text !=
            state.confirmPassword) {
          confirmPasswordTextEditingController.value =
              confirmPasswordTextEditingController.value.copyWith(
                text: state.confirmPassword,
                selection: TextSelection.collapsed(
                  offset: min(
                    confirmPasswordTextEditingController.value.selection.start,
                    state.confirmPassword.length,
                  ),
                ),
              );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgParentProfileBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  80.spaceH,
                  _header(),
                  180.spaceH,
                  AppTextField(
                    controller: emailTextEditingController,
                    title: LocaleKeys.emailAddress.tr(),
                    hint: LocaleKeys.enterEmailAddress.tr(),
                    error: state.emailAddressError,
                    onChanged: (value) {
                      context.read<RegisterCubit>().changeProps(
                        emailAddress: value,
                      );
                    },
                  ).appPadding(left: 30, right: 30),
                  10.spaceH,
                  AppTextField(
                    controller: passwordTextEditingController,
                    title: LocaleKeys.password.tr(),
                    hint: LocaleKeys.enterPassword.tr(),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: state.obscureTextPassword,
                    error: state.passwordError,
                    maxLines: 1,
                    onChanged: (value) {
                      context.read<RegisterCubit>().changeProps(
                        password: value,
                      );
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.obscureTextPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        context.read<RegisterCubit>().changeProps(
                          obscureTextPassword: !state.obscureTextPassword,
                        );
                      },
                    ),
                  ).appPadding(left: 30, right: 30),
                  10.spaceH,
                  AppTextField(
                    maxLines: 1,
                    controller: confirmPasswordTextEditingController,
                    title: LocaleKeys.confirmPassword.tr(),
                    hint: LocaleKeys.enterConfirmPassword.tr(),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: state.obscureTextConfirmPassword,
                    error: state.confirmPasswordError,
                    onChanged: (value) {
                      context.read<RegisterCubit>().changeProps(
                        confirmPassword: value,
                      );
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.obscureTextConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        context.read<RegisterCubit>().changeProps(
                          obscureTextConfirmPassword:
                              !state.obscureTextConfirmPassword,
                        );
                      },
                    ),
                  ).appPadding(left: 30, right: 30),
                  10.spaceH,
                  _termsAndConditions(state),
                  60.spaceH,
                  _registerButton(),
                  60.spaceH,
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
            context.read<RegisterCubit>().clearFields();
            EasyLoading.dismiss();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ParentProfileScreen()),
            );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
          },
        );
      },
    );
  }

  Widget _header() {
    return Column(
      children: [
        LocaleKeys.createYourAccount.tr().appText(
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
        LocaleKeys.secureYourSpotLovingBrainCommunity.tr().appText(
          fontWeight: FontWeight.w500,
        ),
      ],
    ).appPadding(left: 30, right: 30);
  }

  Widget _registerButton() {
    return BaseButton(
      child: Container(
        width: 250.w,
        decoration: BoxDecoration(
          color: pinkColor1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.register.tr().appText(fontWeight: FontWeight.w800),
          ],
        ).appPadding(top: 6, bottom: 6),
      ),
      onTap: () {
        context.read<RegisterCubit>().register();
      },
    );
  }

  Widget _termsAndConditions(RegisterState state) {
    return Row(
      children: [
        Checkbox(
          value: state.isTermsAndConditionAccepted,
          activeColor: pinkColor1,
          onChanged: (value) {
            context.read<RegisterCubit>().changeProps(
                  isTermsAndConditionAccepted: value,
                );
          },
        ),
        Expanded(
          child: Row(
            children: [
               "I accept ".appText(fontSize: 14),
              LocaleKeys.termsConditions.tr().appText(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ],
    ).appPadding(left: 20, right: 20);
  }
}
