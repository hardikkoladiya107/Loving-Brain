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
  const OtpScreen({
    super.key,
    this.destination,
    this.verificationId,
    this.resendToken,
    this.isPhoneAuth = false,
    this.linkedEmail,
    this.linkedPhone,
  });

  final String? destination;
  final String? verificationId;
  final int? resendToken;
  final bool isPhoneAuth;
  final String? linkedEmail;
  final String? linkedPhone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted) return;
      context.read<OtpCubit>().init(
        destination: widget.destination,
        verificationId: widget.verificationId,
        resendToken: widget.resendToken,
        isPhoneAuth: widget.isPhoneAuth,
        linkedEmail: widget.linkedEmail,
        linkedPhone: widget.linkedPhone,
      );
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
                  if (!context.mounted) return;
                  router.push(
                    RoutePaths.successScreen,
                    extra: LocaleKeys.coParentInvitationAcceptedSuccess.tr(),
                  );
                  return;
                } else {
                  String errMsg = '';
                  result.whenOrNull(
                    error: (Exception err) =>
                        errMsg = err.toString().replaceAll('Exception: ', ''),
                  );
                  if (errMsg.isNotEmpty) {
                    showSnackBar(message: errMsg, type: SnackBarType.ERROR);
                  }
                }
              } else {
                await PendingInvitationManager.clear();
              }
            } else {
              final String loggedEmail = (userModel.email ?? '')
                  .trim()
                  .toLowerCase();
              if (loggedEmail.isNotEmpty) {
                final String? pendingInviteId = await CoParentRepo.instance
                    .checkPendingInvitationForUser(loggedEmail);
                if (pendingInviteId != null && pendingInviteId.isNotEmpty) {
                  final ApiResultStatus result = await CoParentRepo.instance
                      .addUserAsCoParent(pendingInviteId);
                  bool invitationSuccess = false;
                  result.whenOrNull(data: (_) => invitationSuccess = true);
                  if (invitationSuccess) {
                    await preferences.putBool(SharedPreference.isLogin, true);
                    if (!context.mounted) return;
                    router.push(
                      RoutePaths.successScreen,
                      extra: LocaleKeys.coParentInvitationAcceptedSuccess.tr(),
                    );
                    return;
                  }
                }
              }
            }

            if (!context.mounted) return;
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
        final int codeLength = state.isPhoneAuth ? 6 : 4;
        final String subtitle = state.destination.isNotEmpty
            ? "We’ve sent a $codeLength digit verification code to ${state.destination}."
            : "We’ve sent a $codeLength digit verification code.";

        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF8F4),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(Assets.v2.images.imgBg.path),
              ),
            ),
            child: SafeArea(
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
                              length: codeLength,
                              boxWidth: state.isPhoneAuth ? 44.w : null,
                              boxHeight: state.isPhoneAuth ? 52.h : null,
                              spacing: state.isPhoneAuth ? 8.w : null,
                              value: state.otpCode,
                              hasError: state.otpError.isNotEmpty,
                              activeBorderColor: secondaryColor,
                              onChanged: (String value) {
                                context.read<OtpCubit>().onOtpChanged(value);
                              },
                              onCompleted: (String value) {
                                context.read<OtpCubit>().onOtpChanged(value);
                                context.read<OtpCubit>().verifyOtp();
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
                            if (state.isLocked)
                              "Locked for ${state.lockoutSeconds}s"
                                  .appText(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  )
                                  .appPadding(left: 20.r, right: 20.r)
                            else if (state.canResend)
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
                            (state.isPhoneAuth
                                    ? "Kindly check if mobile number entered is correct"
                                    : "Kindly check if email entered is correct")
                                .appText(
                                  textAlign: TextAlign.start,
                                  color: greyColor6,
                                  fontSize: 14,
                                )
                                .appPadding(left: 20.r, right: 20.r),
                            if ((state.isPhoneAuth &&
                                    state.linkedEmail.isNotEmpty) ||
                                (!state.isPhoneAuth &&
                                    state.linkedPhone.isNotEmpty)) ...<Widget>[
                              12.spaceH,
                              BaseButton(
                                onTap: () => context
                                    .read<OtpCubit>()
                                    .switchToAlternativeOtp(),
                                child:
                                    (state.isPhoneAuth
                                            ? "Didn't get SMS? Verify via email (${state.linkedEmail}) instead"
                                            : "Didn't get email? Verify via SMS (${state.linkedPhone}) instead")
                                        .appText(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: secondaryColor,
                                          textAlign: TextAlign.start,
                                        )
                                        .appPadding(left: 20.r, right: 20.r),
                              ),
                            ],
                            const Spacer(),
                            24.spaceH,
                            AppButton(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                context.read<OtpCubit>().verifyOtp();
                              },
                              title: state.isLocked
                                  ? "Locked (${state.lockoutSeconds}s)"
                                  : "Continue",
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
