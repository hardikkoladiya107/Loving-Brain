import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';
import '../../../other/snack_bar.dart';
import '../../widget/app_text_field.dart';
import '../../widget/base_button.dart';
import 'bloc/forgot_password_cubit.dart';
import 'bloc/forgot_password_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ForgotPasswordCubit>().init();
    });
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        // Sync input field value from Bloc state
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

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFFFAFAFA),
          // Elegant transparent AppBar with standard circular back button
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leadingWidth: 70.w,
            leading: Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF0E5FC),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              // Background Base
              Positioned.fill(child: Container(color: const Color(0xFFFAFAFA))),
              // Premium Ambient Glow Orbs
              Positioned(
                top: -100.h,
                left: -100.w,
                child: Container(
                  width: 320.w,
                  height: 320.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE5D1FA).withValues(alpha: 0.4),
                  ),
                ),
              ),
              Positioned(
                top: 220.h,
                right: -120.w,
                child: Container(
                  width: 340.w,
                  height: 340.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFD4E5).withValues(alpha: 0.35),
                  ),
                ),
              ),
              Positioned(
                bottom: -120.h,
                left: -60.w,
                child: Container(
                  width: 280.w,
                  height: 280.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD6E4FF).withValues(alpha: 0.35),
                  ),
                ),
              ),
              // Gaussian blur overlay for soft background
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                  child: Container(color: Colors.transparent),
                ),
              ),
              // Main content layout scrollable to prevent overflow
              Positioned.fill(
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 28.h,
                              horizontal: 8.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28.r),
                              border: Border.all(
                                color: const Color(0xFFF0E5FC),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.03),
                                  blurRadius: 40,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Personalised Brand Reset Icon
                                Container(
                                  width: 58.r,
                                  height: 58.r,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withValues(
                                          alpha: 0.12,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.lock_reset_rounded,
                                      size: 32.r,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                20.spaceH,
                                LocaleKeys.forgotPassword.tr().appText(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 26,
                                  color: Colors.black87,
                                  letterSpacing: 0.5,
                                ),
                                8.spaceH,
                                LocaleKeys
                                    .enterDetailsToReceiveResetInstructions
                                    .tr()
                                    .appText(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                      textAlign: TextAlign.center,
                                      height: 1.4,
                                    )
                                    .appPadding(left: 20, right: 20),
                                28.spaceH,
                                _email(state),
                                32.spaceH,
                                _resetButton(state),
                              ],
                            ),
                          ).appPadding(left: 20, right: 20),
                          24.spaceH,
                          _backToLoginLink(),
                          20.spaceH,
                        ],
                      ),
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
            showSnackBar(
              message: LocaleKeys.weSentYouMailToResetYourPassword.tr(),
              type: SnackBarType.SUCCESS,
            );
            if (!mounted) return;
            context.pop();
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

  // Email input field widget
  Widget _email(ForgotPasswordState state) {
    return AppTextField(
      controller: emailTextEditingController,
      title: LocaleKeys.emailAddress.tr(),
      hint: LocaleKeys.enterEmailAddress.tr(),
      error: state.emailAddressError,
      keyboardType: TextInputType.emailAddress,
      fillColor: const Color(0xFFF9FAFB),
      prefixIcon: Assets.icons.icEmailPrefixIcon
          .image(
            height: 20.r,
            width: 20.r,
            color: primaryColor.withValues(alpha: 0.7),
          )
          .appPadding(all: 12),
      onChanged: (value) {
        context.read<ForgotPasswordCubit>().changeProps(emailAddress: value);
      },
    ).appPadding(left: 20, right: 20);
  }

  // Premium Send Reset Link Button widget
  Widget _resetButton(ForgotPasswordState state) {
    final bool submitting = state.isAuthSubmitting;
    return BaseButton(
      onTap: submitting
          ? null
          : () {
              context.read<ForgotPasswordCubit>().performForgotPassword();
            },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: submitting
                ? [
                    primaryColor.withValues(alpha: 0.6),
                    primaryColor.withValues(alpha: 0.6),
                  ]
                : [primaryColor, primaryColor.withValues(alpha: 0.85)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: submitting
              ? []
              : [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.24),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (submitting)
              SizedBox(
                height: 20.r,
                width: 20.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ).appPadding(top: 14.h, bottom: 14.h)
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LocaleKeys.sendResetEmail.tr().appText(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                  8.spaceW,
                  const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                ],
              ).appPadding(top: 14.h, bottom: 14.h),
          ],
        ),
      ),
    );
  }

  // Back to login bottom link
  Widget _backToLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 13,
                color: primaryColor,
              ),
              6.spaceW,
              LocaleKeys.backToLogin.tr().appText(
                color: primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ],
          ),
          onTap: () => context.pop(),
        ),
      ],
    );
  }
}
