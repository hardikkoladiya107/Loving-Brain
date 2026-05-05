import 'dart:math';
import 'package:flutter/gestures.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';
import '../../widget/app_text_field.dart';
import 'bloc/register_cubit.dart';
import 'bloc/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RegisterCubit>().init();
    });
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

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

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFFFAFAFA),
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF6F0FF),
                        const Color(0xFFFFF0F5),
                        const Color(0xFFF9FAFB),
                        const Color(0xFFF9FAFB),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        40.spaceH,
                        _header(),
                        40.spaceH,
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.08),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              AppTextField(
                                controller: emailTextEditingController,
                                title: LocaleKeys.emailAddress.tr(),
                                hint: LocaleKeys.enterEmailAddress.tr(),
                                error: state.emailAddressError,
                                fillColor: const Color(0xFFF9FAFB),
                                onChanged: (value) {
                                  context.read<RegisterCubit>().changeProps(
                                    emailAddress: value,
                                  );
                                },
                              ).appPadding(left: 24, right: 24),
                              16.spaceH,
                              AppTextField(
                                controller: passwordTextEditingController,
                                title: LocaleKeys.password.tr(),
                                hint: LocaleKeys.enterPassword.tr(),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: state.obscureTextPassword,
                                error: state.passwordError,
                                maxLines: 1,
                                fillColor: const Color(0xFFF9FAFB),
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
                                    color: Colors.grey.shade400,
                                  ),
                                  onPressed: () {
                                    context.read<RegisterCubit>().changeProps(
                                      obscureTextPassword:
                                          !state.obscureTextPassword,
                                    );
                                  },
                                ),
                              ).appPadding(left: 24, right: 24),
                              16.spaceH,
                              AppTextField(
                                maxLines: 1,
                                controller:
                                    confirmPasswordTextEditingController,
                                title: LocaleKeys.confirmPassword.tr(),
                                hint: LocaleKeys.enterConfirmPassword.tr(),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: state.obscureTextConfirmPassword,
                                error: state.confirmPasswordError,
                                fillColor: const Color(0xFFF9FAFB),
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
                                    color: Colors.grey.shade400,
                                  ),
                                  onPressed: () {
                                    context.read<RegisterCubit>().changeProps(
                                      obscureTextConfirmPassword:
                                          !state.obscureTextConfirmPassword,
                                    );
                                  },
                                ),
                              ).appPadding(left: 24, right: 24),
                              16.spaceH,
                              _termsAndConditions(state),
                              32.spaceH,
                              _registerButton(state),
                              20.spaceH,
                              BaseButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    4.spaceW,
                                    "Back to Login".appText(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                onTap: () => context.pop(),
                              ),
                            ],
                          ),
                        ).appPadding(left: 20, right: 20),
                        80.spaceH,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          initial: () {},
          loading: () {},
          data: (data) {
            context.read<RegisterCubit>().clearFields();
            if (!mounted) return;
            context.go(RoutePaths.parentProfile);
          },
          error: (Exception error) {
            showSnackBar(
              message: error.toString().replaceAll("Exception: ", ""),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
    );
  }

  Widget _header() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: LocaleKeys.createYourAccount.tr().appText(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: Colors.black87,
            letterSpacing: 1.0,
          ),
        ),
        16.spaceH,
        LocaleKeys.secureYourSpotLovingBrainCommunity
            .tr()
            .appText(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              fontSize: 14,
              textAlign: TextAlign.center,
              height: 1.4,
            )
            .appPadding(left: 20, right: 20),
      ],
    ).appPadding(left: 30, right: 30);
  }

  Widget _registerButton(RegisterState state) {
    final bool submitting = state.isAuthSubmitting;
    return BaseButton(
      onTap: submitting
          ? null
          : () {
              context.read<RegisterCubit>().register();
            },
      child: Container(
        width: 250.w,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (submitting)
              SizedBox(
                height: 22.r,
                width: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            else
              LocaleKeys.register.tr().appText(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
          ],
        ).appPadding(top: 14.h, bottom: 14.h),
      ),
    );
  }

  Widget _termsAndConditions(RegisterState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
              value: state.isTermsAndConditionAccepted,
              activeColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: BorderSide(color: Colors.grey.shade400, width: 1.5),
              onChanged: (value) {
                context.read<RegisterCubit>().changeProps(
                  isTermsAndConditionAccepted: value ?? false,
                );
              },
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: getTextStyle(fontSize: 13, color: Colors.grey.shade700),
                children: [
                  TextSpan(text: "I accept "),
                  TextSpan(
                    text: LocaleKeys.termsConditions.tr(),
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                      textDecoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.push(RoutePaths.terms);
                      },
                  ),
                  TextSpan(text: " ${LocaleKeys.and.tr()} "),
                  TextSpan(
                    text: LocaleKeys.privacyPolicy.tr(),
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                      textDecoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.push(RoutePaths.privacy);
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).appPadding(left: 20, right: 20);
  }
}
