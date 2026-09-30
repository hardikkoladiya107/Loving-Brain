import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/auth/register/bloc/register_cubit.dart';
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
          data: (dynamic data) async {
            EasyLoading.dismiss();
            if (data == null) return;
            final UserModel userModel =
                preferences.getUserModel() ??
                UserModel.fromJson(data as Map<String, dynamic>);
            final GoRouter router = GoRouter.of(context);
            context.read<OtpCubit>().changeProps(
              verifyStatus: const ApiResultStatus.initial(),
            );
            context.read<RegisterCubit>().clearFields();

            if (PendingInvitationManager.hasPending()) {
              final String pendingId = PendingInvitationManager.getId();
              final String pendingEmail = PendingInvitationManager.getEmail();
              final String loggedEmail = (userModel.email ?? '')
                  .trim()
                  .toLowerCase();
              if (loggedEmail.isNotEmpty &&
                  loggedEmail == pendingEmail.trim().toLowerCase()) {
                final ApiResultStatus result = await CoParentRepo.instance
                    .addUserAsCoParent(pendingId);
                bool invitationSuccess = false;
                result.whenOrNull(data: (_) => invitationSuccess = true);
                if (invitationSuccess) {
                  await PendingInvitationManager.clear();
                  await preferences.putBool(SharedPreference.isLogin, true);
                  router.push(
                    RoutePaths.successScreen,
                    extra: LocaleKeys.coParentInvitationAcceptedSuccess.tr(),
                  );
                  return;
                }
              } else {
                await PendingInvitationManager.clear();
              }
            }

            if (!userModel.isOnboardingCompleted) {
              router.go(RoutePaths.onboarding);
            } else {
              router.go(RoutePaths.base);
            }
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
            : "We’ve sent a 4 digit verification code to your email.";

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
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
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
                                .appText2(
                                  fontSize: 28,
                                  textAlign: TextAlign.start,
                                )
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
                              activeBorderColor: secondaryColor,
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
                            if (state.canResend)
                              BaseButton(
                                onTap: () =>
                                    context.read<OtpCubit>().resendOtp(),
                                child: "Resend OTP"
                                    .appText(
                                      fontWeight: FontWeight.w700,
                                      color: secondaryColor,
                                    )
                                    .appPadding(left: 20.r, right: 20.r),
                              )
                            else
                              "Retry in ${state.resendCountdown}s"
                                  .appText()
                                  .appPadding(left: 20.r, right: 20.r),
                            "Kindly check if email entered is correct"
                                .appText(
                                  textAlign: TextAlign.start,
                                  color: greyColor6,
                                  fontSize: 14,
                                )
                                .appPadding(left: 20.r, right: 20.r),
                            const Spacer(),
                            24.spaceH,
                            AppButton(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                context.read<OtpCubit>().verifyOtp(
                                  onSuccess: () {},
                                );
                              },
                              title: "Continue",
                              isLoading: state.isSubmitting,
                            ),
                            32.spaceH,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
