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

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RegisterCubit>().init();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onStepChanged(int newStep) {
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      builder: (context, state) {
        // Sync controllers
        _syncController(emailController, state.emailAddress);
        _syncController(passwordController, state.password);
        _syncController(confirmPasswordController, state.confirmPassword);

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFFFAFAFA),
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFF6F0FF),
                        Color(0xFFFFF0F5),
                        Color(0xFFF9FAFB),
                        Color(0xFFF9FAFB),
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
                  child: Column(
                    children: [
                      40.spaceH,
                      _header(state),
                      20.spaceH,
                      _stepIndicator(state.currentStep),
                      20.spaceH,
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: FadeTransition(
                            opacity: _fadeAnim,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.08),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: state.currentStep == 0
                                  ? _step0(state)
                                  : _step1(state),
                            ),
                          ).appPadding(left: 20, right: 20),
                        ),
                      ),
                      40.spaceH,
                    ],
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
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
    );
  }

  void _syncController(TextEditingController ctrl, String stateValue) {
    if (ctrl.text != stateValue) {
      ctrl.value = ctrl.value.copyWith(
        text: stateValue,
        selection: TextSelection.collapsed(
          offset: min(ctrl.value.selection.start, stateValue.length),
        ),
      );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Shared Widgets
  // ──────────────────────────────────────────────────────────────────────────

  Widget _header(RegisterState state) {
    final String title = state.currentStep == 0
        ? LocaleKeys.createYourAccount.tr()
        : LocaleKeys.createYourAccount.tr();
    final String subtitle = state.currentStep == 0
        ? 'Enter your email to get started'
        : 'Set a secure password for your account';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: title.appText(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: Colors.black87,
            letterSpacing: 1.0,
          ),
        ),
        16.spaceH,
        subtitle
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

  Widget _stepIndicator(int step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(active: step == 0, done: step > 0),
        Container(
          width: 40,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: step > 0
                ? primaryColor
                : primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        _dot(active: step == 1, done: false),
      ],
    );
  }

  Widget _dot({required bool active, required bool done}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active ? 14 : 10,
      height: active ? 14 : 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active || done
            ? primaryColor
            : primaryColor.withValues(alpha: 0.2),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Step 0 — Email
  // ──────────────────────────────────────────────────────────────────────────

  Widget _step0(RegisterState state) {
    return Column(
      children: [
        AppTextField(
          controller: emailController,
          title: LocaleKeys.emailAddress.tr(),
          hint: LocaleKeys.enterEmailAddress.tr(),
          error: state.emailAddressError,
          fillColor: const Color(0xFFF9FAFB),
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) =>
              context.read<RegisterCubit>().changeProps(emailAddress: v),
        ).appPadding(left: 24, right: 24),
        32.spaceH,
        _nextButton(state),
        20.spaceH,
        BaseButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey.shade600),
              4.spaceW,
              'Back to Login'.appText(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          onTap: () => context.pop(),
        ),
      ],
    );
  }

  Widget _nextButton(RegisterState state) {
    final bool busy = state.isEmailChecking;
    return BaseButton(
      onTap: busy
          ? null
          : () {
              context.read<RegisterCubit>().nextStep().then((_) {
                _onStepChanged(1);
              });
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
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (busy)
              SizedBox(
                height: 22.r,
                width: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            else
              'Continue'.appText(
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

  // ──────────────────────────────────────────────────────────────────────────
  // Step 1 — Password + Confirm + Terms
  // ──────────────────────────────────────────────────────────────────────────

  Widget _step1(RegisterState state) {
    return Column(
      children: [
        // Email display (read-only)
        Container(
          margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.email_outlined,
                  color: primaryColor, size: 18.sp),
              10.spaceW,
              Expanded(
                child: state.emailAddress.appText(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: primaryColor,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
        AppTextField(
          controller: passwordController,
          title: LocaleKeys.password.tr(),
          hint: LocaleKeys.enterPassword.tr(),
          keyboardType: TextInputType.visiblePassword,
          obscureText: state.obscureTextPassword,
          error: state.passwordError,
          maxLines: 1,
          fillColor: const Color(0xFFF9FAFB),
          onChanged: (v) =>
              context.read<RegisterCubit>().changeProps(password: v),
          suffixIcon: IconButton(
            icon: Icon(
              state.obscureTextPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.grey.shade400,
            ),
            onPressed: () => context.read<RegisterCubit>().changeProps(
              obscureTextPassword: !state.obscureTextPassword,
            ),
          ),
        ).appPadding(left: 24, right: 24),
        16.spaceH,
        AppTextField(
          maxLines: 1,
          controller: confirmPasswordController,
          title: LocaleKeys.confirmPassword.tr(),
          hint: LocaleKeys.enterConfirmPassword.tr(),
          keyboardType: TextInputType.visiblePassword,
          obscureText: state.obscureTextConfirmPassword,
          error: state.confirmPasswordError,
          fillColor: const Color(0xFFF9FAFB),
          onChanged: (v) =>
              context.read<RegisterCubit>().changeProps(confirmPassword: v),
          suffixIcon: IconButton(
            icon: Icon(
              state.obscureTextConfirmPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.grey.shade400,
            ),
            onPressed: () => context.read<RegisterCubit>().changeProps(
              obscureTextConfirmPassword: !state.obscureTextConfirmPassword,
            ),
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
              Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey.shade600),
              4.spaceW,
              'Change email'.appText(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          onTap: () {
            context.read<RegisterCubit>().previousStep();
            _onStepChanged(0);
          },
        ),
      ],
    );
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
              offset: const Offset(0, 6),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  const TextSpan(text: 'I accept '),
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
                  TextSpan(text: ' ${LocaleKeys.and.tr()} '),
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
