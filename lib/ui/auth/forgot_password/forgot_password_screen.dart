import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  TextEditingController emailTextEditingController = TextEditingController();

  @override
  void initState() {
    context.read<ForgotPasswordCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        emailTextEditingController.text = state.emailAddress;

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
                  160.spaceH,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 40),
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
                            Icon(Icons.lock_reset, size: 60, color: blueButtonColor),
                            16.spaceH,
                            LocaleKeys.forgotPassword.tr().appText(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: blueTextColor,
                            ),
                            24.spaceH,
                            _email(state),
                            30.spaceH,
                            _resetButton(),
                          ],
                        ),
                      ),
                    ),
                  ).appPadding(left: 20, right: 20),
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
            EasyLoading.dismiss();
            showSnackBar(
              message: LocaleKeys.weSentYouMailToResetYourPassword.tr(),
              type: SnackBarType.SUCCESS,
            );
            Navigator.pop(context);
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
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
      prefixIcon: Assets.icons.icEmailPrefixIcon.image(
        height: 30,
        width: 30,
        color: Colors.grey,
      ),
      onChanged: (value) {
        context.read<ForgotPasswordCubit>().changeProps(emailAddress: value);
      },
    ).appPadding(left: 20, right: 20);
  }

  Widget _resetButton() {
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
            LocaleKeys.sendResetEmail.tr().appText(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ],
        ).appPadding(top: 14, bottom: 14),
      ),
      onTap: () {
        context.read<ForgotPasswordCubit>().performForgotPassword();
      },
    ).appPadding(left: 24, right: 24);
  }
}
