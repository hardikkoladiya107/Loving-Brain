import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import 'bloc/otp_cubit.dart';
import 'bloc/otp_state.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, this.destination});

  final String? destination;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted) return;
      context.read<OtpCubit>().init(destination: widget.destination);
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (BuildContext context, OtpState state) {
        state.verifyStatus.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (dynamic _) {
            EasyLoading.dismiss();
            context.go(RoutePaths.base);
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );

        state.resendStatus.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (dynamic _) {
            EasyLoading.dismiss();
            showSnackBar(
              message: 'Verification code resent successfully',
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, OtpState state) {
        if (_otpController.text != state.otpCode) {
          _otpController.value = _otpController.value.copyWith(
            text: state.otpCode,
            selection: TextSelection.collapsed(
              offset: min(_otpController.selection.start, state.otpCode.length),
            ),
          );
        }

        final String subtitle = state.destination.isNotEmpty
            ? "We’ve sent a 4 digit verification code to ${state.destination}."
            : "We’ve sent a 4 digit verification code to your mobile number.";

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.v2.images.imgBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BaseButton(
                    child: Assets.v2.icons.icBack.svg(),
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                  ),
                  "Enter OTP"
                      .appText2(fontSize: 28, textAlign: TextAlign.start)
                      .appPadding(left: 20.r, right: 20.r),
                  subtitle
                      .appText(
                        textAlign: TextAlign.start,
                        fontSize: 14,
                        color: greyColor,
                      )
                      .appPadding(left: 20.r, right: 20.r),
                  21.spaceH,
                  AppTextField(
                    controller: _otpController,
                    title: "Verification code",
                    hint: "Enter 6-digit code",
                    keyboardType: TextInputType.number,
                    error: state.otpError,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    onChanged: (String value) {
                      context.read<OtpCubit>().onOtpChanged(value);
                    },
                  ).appPadding(left: 20.r, right: 20.r),
                  16.spaceH,
                  const Spacer(),
                  AppButton(
                    onTap: () {
                      context.read<OtpCubit>().verifyOtp(
                        onSuccess: () {
                          context.go(RoutePaths.base);
                        },
                      );
                    },
                    title: "Continue",
                  ),
                  32.spaceH,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
