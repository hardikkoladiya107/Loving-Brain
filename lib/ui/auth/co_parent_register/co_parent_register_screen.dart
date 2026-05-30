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
import 'package:loving_brain/ui/success_screen/success_screen.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

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

  static const List<Color> _gradient = [
    Color(0xFF6A24B8),
    Color(0xFF894BCD),
    Color(0xFFA96EE0),
  ];

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
              // Navigate to success screen then to parent profile
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SucessScreen(
                    successText:
                        "Your account has been created and you're now a co-parent! 🎉\n\nPlease complete your profile to get started.",
                  ),
                ),
              );
              // After success screen is popped, go to parent profile
              Future.delayed(const Duration(milliseconds: 100), () {
                if (context.mounted) {
                  context.go(RoutePaths.parentProfile);
                }
              });
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
          // Sync controllers
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
            _confirmPasswordController.value =
                _confirmPasswordController.value.copyWith(
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
            body: Stack(
              children: [
                // Ambient background
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF5F0FF),
                          Color(0xFFFFF8FB),
                          Color(0xFFFAFAFA),
                        ],
                      ),
                    ),
                  ),
                ),
                _softOrb(const Color(0xFF894BCD), 230.w,
                    top: -80.h, right: -45.w),
                _softOrb(const Color(0xFF5271FF), 200.w,
                    top: 160.h, left: -65.w),
                _softOrb(const Color(0xFFFF66C4), 210.w,
                    bottom: 120.h, right: -55.w),

                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 40.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _navHeader(context),
                        24.h.spaceH,
                        _heroCard(),
                        24.h.spaceH,
                        _formCard(context, state),
                      ],
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

  Widget _softOrb(
    Color color,
    double size, {
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.13),
        ),
      ),
    );
  }

  Widget _navHeader(BuildContext context) {
    return Row(
      children: [
        BaseButton(
          onTap: () => context.pop(),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.9),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              ),
            ),
          ),
        ),
        14.w.spaceW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              'Create Your Account'.appText(
                fontWeight: FontWeight.w900,
                fontSize: 22.sp,
                color: Colors.black87,
                textAlign: TextAlign.start,
                letterSpacing: -0.3,
              ),
              4.h.spaceH,
              'Set a password to accept the invitation'.appText(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withValues(alpha: 0.92),
              const Color(0xFFA96EE0).withValues(alpha: 0.88),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.email_rounded,
                color: Colors.white,
                size: 26.sp,
              ),
            ),
            14.w.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Invitation accepted for:'.appText(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.82),
                    textAlign: TextAlign.start,
                  ),
                  6.h.spaceH,
                  widget.email.appText(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                    color: Colors.white,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formCard(BuildContext context, CoParentRegisterState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.95),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Password
              AppTextField(
                controller: _passwordController,
                title: LocaleKeys.password.tr(),
                hint: LocaleKeys.enterPassword.tr(),
                keyboardType: TextInputType.visiblePassword,
                obscureText: state.obscurePassword,
                error: state.passwordError,
                maxLines: 1,
                fillColor: const Color(0xFFF9FAFB),
                onChanged: (v) =>
                    context.read<CoParentRegisterCubit>().changeProps(
                      password: v,
                    ),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: () =>
                      context.read<CoParentRegisterCubit>().changeProps(
                        obscurePassword: !state.obscurePassword,
                      ),
                ),
              ),
              16.h.spaceH,
              // Confirm Password
              AppTextField(
                controller: _confirmPasswordController,
                title: LocaleKeys.confirmPassword.tr(),
                hint: LocaleKeys.enterConfirmPassword.tr(),
                keyboardType: TextInputType.visiblePassword,
                obscureText: state.obscureConfirmPassword,
                error: state.confirmPasswordError,
                maxLines: 1,
                fillColor: const Color(0xFFF9FAFB),
                onChanged: (v) =>
                    context.read<CoParentRegisterCubit>().changeProps(
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
              ),
              16.h.spaceH,
              // Terms checkbox
              _termsRow(context, state),
              28.h.spaceH,
              // Create Account Button
              _createButton(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _termsRow(BuildContext context, CoParentRegisterState state) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.1,
          child: Checkbox(
            value: state.isTermsAccepted,
            activeColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: BorderSide(color: Colors.grey.shade400, width: 1.5),
            onChanged: (v) =>
                context.read<CoParentRegisterCubit>().changeProps(
                  isTermsAccepted: v ?? false,
                ),
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
                    ..onTap = () => context.push(RoutePaths.terms),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: LocaleKeys.privacyPolicy.tr(),
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
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
    );
  }

  Widget _createButton(BuildContext context, CoParentRegisterState state) {
    return BaseButton(
      onTap: state.isSubmitting
          ? null
          : () {
              context.read<CoParentRegisterCubit>().register(
                email: widget.email,
                invitationId: widget.invitationId,
              );
            },
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: _gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.42),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: state.isSubmitting
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : 'Create Account & Accept Invitation'.appText(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15.sp,
              ),
      ),
    );
  }
}
