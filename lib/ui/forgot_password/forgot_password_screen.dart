import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/snack_bar.dart';
import '../widget/app_text_field.dart';
import '../widget/base_button.dart';
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
                  300.spaceH,
                  _email(state),
                  30.spaceH,
                  _resetButton(),
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
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.sendResetEmail.tr().appText(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ],
        ).appPadding(top: 10, bottom: 10),
      ),
      onTap: () {
        context.read<ForgotPasswordCubit>().performForgotPassword();
      },
    ).appPadding(left: 24, right: 24);
  }
}
