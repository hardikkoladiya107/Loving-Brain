import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/auth/co_parent_register/bloc/co_parent_register_cubit.dart';
import 'package:loving_brain/ui/auth/co_parent_register/bloc/co_parent_register_state.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';

class CoParentRegisterScreen extends StatefulWidget {
  const CoParentRegisterScreen({
    super.key,
    required this.email,
    required this.invitationId,
  });

  final String email;
  final String invitationId;

  @override
  State<CoParentRegisterScreen> createState() => _CoParentRegisterScreenState();
}

class _CoParentRegisterScreenState extends State<CoParentRegisterScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoParentRegisterCubit>(
      create: (_) => CoParentRegisterCubit(),
      child: BlocConsumer<CoParentRegisterCubit, CoParentRegisterState>(
        listener: (context, state) {
          state.apiResultStatus.whenOrNull(
            loading: () => EasyLoading.show(),
            data: (data) {
              EasyLoading.dismiss();
              // Navigate main screen location to parent profile and overlay Success Screen via GoRouter
              if (!mounted) return;
              context.go(RoutePaths.parentProfile);
              context.push(
                RoutePaths.successScreen,
                extra: LocaleKeys.coParentSuccessText.tr(),
              );
            },
            error: (error) {
              EasyLoading.dismiss();
              showSnackBar(
                message: error.toString().replaceAll('Exception: ', ''),
                type: SnackBarType.ERROR,
              );
            },
          );
        },
        builder: (context, state) {
          // Sync controllers from state
          if (_passwordController.text != state.password) {
            _passwordController.value = _passwordController.value.copyWith(
              text: state.password,
              selection: TextSelection.collapsed(
                offset: min(
                  _passwordController.value.selection.start,
                  state.password.length,
                ),
              ),
            );
          }
          if (_confirmPasswordController.text != state.confirmPassword) {
            _confirmPasswordController.value = _confirmPasswordController.value
                .copyWith(
                  text: state.confirmPassword,
                  selection: TextSelection.collapsed(
                    offset: min(
                      _confirmPasswordController.value.selection.start,
                      state.confirmPassword.length,
                    ),
                  ),
                );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            extendBodyBehindAppBar: true,
            // Custom standard transparent AppBar with circular pop button
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
                // Base background color
                Positioned.fill(
                  child: Container(color: const Color(0xFFFAFAFA)),
                ),
                // Premium Ambient Glow Background
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
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                // Main content
                Positioned.fill(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          16.spaceH,
                          _header(),
                          20.spaceH,
                          _heroCard(),
                          20.spaceH,
                          _formCard(context, state),
                          24.spaceH,
                        ],
                      ).appPadding(left: 20, right: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Brand and Invitation Screen Title Header
  Widget _header() {
    return Column(
      children: [
        Container(
          width: 58.r,
          height: 58.r,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Assets.icons.icBrainAi.image(
              height: 32.r,
              width: 32.r,
              fit: BoxFit.contain,
            ),
          ),
        ),
        16.spaceH,
        LocaleKeys.createYourAccount.tr().appText(
          fontWeight: FontWeight.w900,
          fontSize: 26,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
        8.spaceH,
        LocaleKeys.setPasswordToAcceptInvitation.tr().appText(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade600,
          fontSize: 14,
          textAlign: TextAlign.center,
          height: 1.4,
        ),
      ],
    );
  }

  // Hero Card showing the recipient email address details
  Widget _heroCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(Icons.email_rounded, color: Colors.white, size: 24.r),
          ),
          14.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocaleKeys.invitationAcceptedFor.tr().appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.82),
                  textAlign: TextAlign.start,
                ),
                4.spaceH,
                widget.email.appText(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Main Form Card wrapping inputs and terms checkbox
  Widget _formCard(BuildContext context, CoParentRegisterState state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFF0E5FC), width: 1.5),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Password Input Field
          AppTextField(
            controller: _passwordController,
            title: LocaleKeys.password.tr(),
            hint: LocaleKeys.enterPassword.tr(),
            keyboardType: TextInputType.visiblePassword,
            obscureText: state.obscurePassword,
            error: state.passwordError,
            maxLines: 1,
            fillColor: const Color(0xFFF9FAFB),
            prefixIcon: Assets.icons.icPasswordPrefixIcon
                .image(
                  height: 20.r,
                  width: 20.r,
                  color: primaryColor.withValues(alpha: 0.7),
                )
                .appPadding(all: 12),
            onChanged: (v) =>
                context.read<CoParentRegisterCubit>().changeProps(password: v),
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade400,
              ),
              onPressed: () => context
                  .read<CoParentRegisterCubit>()
                  .changeProps(obscurePassword: !state.obscurePassword),
            ),
          ).appPadding(left: 20, right: 20),

          // Password Requirement Checklist Indicator
          _passwordRequirements(state.password),

          16.spaceH,
          // Confirm Password Input Field
          AppTextField(
            controller: _confirmPasswordController,
            title: LocaleKeys.confirmPassword.tr(),
            hint: LocaleKeys.enterConfirmPassword.tr(),
            keyboardType: TextInputType.visiblePassword,
            obscureText: state.obscureConfirmPassword,
            error: state.confirmPasswordError,
            maxLines: 1,
            fillColor: const Color(0xFFF9FAFB),
            prefixIcon: Assets.icons.icPasswordPrefixIcon
                .image(
                  height: 20.r,
                  width: 20.r,
                  color: primaryColor.withValues(alpha: 0.7),
                )
                .appPadding(all: 12),
            onChanged: (v) => context.read<CoParentRegisterCubit>().changeProps(
              confirmPassword: v,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                state.obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey.shade400,
              ),
              onPressed: () =>
                  context.read<CoParentRegisterCubit>().changeProps(
                    obscureConfirmPassword: !state.obscureConfirmPassword,
                  ),
            ),
          ).appPadding(left: 20, right: 20),
          16.spaceH,
          // Terms and Conditions checkbox row
          _termsRow(context, state),
          30.spaceH,
          // Create Account and Accept Button
          _createButton(context, state),
        ],
      ),
    );
  }

  // Password requirement checklist indicator
  Widget _passwordRequirements(String password) {
    final bool hasLength = password.length >= 6;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(
            hasLength
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: hasLength ? Colors.green : Colors.grey.shade400,
            size: 14.r,
          ),
          6.spaceW,
          LocaleKeys.passwordMinSixCharacters.tr().appText(
            fontSize: 11,
            color: hasLength ? Colors.green.shade700 : Colors.grey.shade600,
            fontWeight: hasLength ? FontWeight.w600 : FontWeight.normal,
          ),
        ],
      ),
    );
  }

  // Checkbox row for Terms and Conditions
  Widget _termsRow(BuildContext context, CoParentRegisterState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1.0,
            child: SizedBox(
              width: 24.w,
              height: 24.h,
              child: Checkbox(
                value: state.isTermsAccepted,
                activeColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                onChanged: (v) => context
                    .read<CoParentRegisterCubit>()
                    .changeProps(isTermsAccepted: v ?? false),
              ),
            ),
          ),
          10.spaceW,
          Expanded(
            child: RichText(
              text: TextSpan(
                style: getTextStyle(fontSize: 12, color: Colors.grey.shade600),
                children: [
                  TextSpan(text: "${LocaleKeys.iAccept.tr()} "),
                  TextSpan(
                    text: LocaleKeys.termsConditions.tr(),
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                      textDecoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.push(RoutePaths.terms),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: LocaleKeys.privacyPolicy.tr(),
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                      textDecoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.push(RoutePaths.privacy),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).appPadding(left: 20, right: 20);
  }

  // Premium Create Account / Registration CTA button
  Widget _createButton(BuildContext context, CoParentRegisterState state) {
    final bool submitting = state.isSubmitting;
    return BaseButton(
      onTap: submitting
          ? null
          : () {
              context.read<CoParentRegisterCubit>().register(
                email: widget.email,
                invitationId: widget.invitationId,
              );
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
                  LocaleKeys.createAccountAndAcceptInvitation.tr().appText(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                  8.spaceW,
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ).appPadding(top: 14.h, bottom: 14.h),
          ],
        ),
      ),
    );
  }
}
