import 'package:flutter/material.dart';
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
import 'package:loving_brain/ui/widget/app_otp_field.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted) return;
      context.read<OtpCubit>().init(destination: widget.destination);
    });
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
                  28.spaceH,
                  AppOtpField(
                    length: 4,
                    value: state.otpCode,
                    hasError: state.otpError.isNotEmpty,
                    onChanged: (String value) {
                      context.read<OtpCubit>().onOtpChanged(value);
                    },
                  ).appPadding(left: 20.r, right: 20.r),
                  if (state.otpError.isNotEmpty) ...<Widget>[
                    10.spaceH,
                    state.otpError
                        .appText(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                          textAlign: TextAlign.start,
                        )
                        .appPadding(left: 20.r, right: 20.r),
                  ],
                  16.spaceH,
                  "Retry in 10s".appText().appPadding(left: 20.r, right: 20.r),
                  "Kindly check if mobile number entered is correct"
                      .appText(
                        textAlign: TextAlign.start,
                        color: greyColor3,
                        fontSize: 14,
                      )
                      .appPadding(left: 20.r, right: 20.r),
                  const Spacer(),
                  AppButton(
                    onTap: () {
                        context.go(RoutePaths.onboarding);
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
