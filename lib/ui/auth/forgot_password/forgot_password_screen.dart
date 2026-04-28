import 'dart:ui';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        80.spaceH,
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 40),
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
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.lock_reset,
                                  size: 60,
                                  color: primaryColor,
                                ),
                              ),
                              24.spaceH,
                              LocaleKeys.forgotPassword.tr().appText(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                                letterSpacing: 1.0,
                              ),
                              12.spaceH,
                              "Enter your details to receive reset instructions"
                                  .appText(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    textAlign: TextAlign.center,
                                  )
                                  .appPadding(left: 30, right: 30),
                              32.spaceH,
                              _email(state),
                              40.spaceH,
                              _resetButton(),
                            ],
                          ),
                        ).appPadding(left: 20, right: 20),
                        40.spaceH,
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
                          onTap: () => Navigator.pop(context),
                        ),
                        40.spaceH,
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
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
            showSnackBar(
              message: LocaleKeys.weSentYouMailToResetYourPassword.tr(),
              type: SnackBarType.SUCCESS,
            );
            if (!mounted) return;
            Navigator.pop(context);
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll("Exception: ", ""),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
    );
  }

  Widget _email(ForgotPasswordState state) {
    return AppTextField(
      controller: emailTextEditingController,
      title: LocaleKeys.emailAddress.tr(),
      hint: LocaleKeys.enterEmailAddress.tr(),
      error: state.emailAddressError,
      keyboardType: TextInputType.emailAddress,
      fillColor: const Color(0xFFF9FAFB),
      prefixIcon: Assets.icons.icEmailPrefixIcon.image(
        height: 24,
        width: 24,
        color: Colors.grey.shade400,
      ),
      onChanged: (value) {
        context.read<ForgotPasswordCubit>().changeProps(emailAddress: value);
      },
    ).appPadding(left: 24, right: 24);
  }

  Widget _resetButton() {
    return BaseButton(
      child: Container(
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
            LocaleKeys.sendResetEmail.tr().appText(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ],
        ).appPadding(top: 14.h, bottom: 14.h),
      ),
      onTap: () {
        context.read<ForgotPasswordCubit>().performForgotPassword();
      },
    ).appPadding(left: 32, right: 32);
  }
}
