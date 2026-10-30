import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/pending_invitation_nav.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/onboarding/bloc/onboarding_cubit.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../other/app_color.dart';
import '../../widget/app_text_field.dart';
import 'bloc/register_cubit.dart';
import 'bloc/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RegisterCubit>().init();
      if (PendingInvitationManager.hasPending()) {
        final String pendingEmail = PendingInvitationManager.getEmail();
        if (pendingEmail.isNotEmpty) {
          emailTextEditingController.text = pendingEmail;
          context.read<RegisterCubit>().changeProps(
            emailAddress: pendingEmail,
            emailAddressError: '',
          );
        }
      }
    });
  }

  @override
  void dispose() {
    phoneTextEditingController.dispose();
    emailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final String submittingMethod = context
            .read<RegisterCubit>()
            .submittingMethod;
        final bool isAppleLoading =
            state.isAuthSubmitting && submittingMethod == 'apple';
        final bool isGoogleLoading =
            state.isAuthSubmitting && submittingMethod == 'google';
        final bool isContinueLoading =
            state.isAuthSubmitting &&
            (submittingMethod == 'email' || submittingMethod == 'phone');

        if (phoneTextEditingController.value.text != state.phoneNumber) {
          phoneTextEditingController.value = phoneTextEditingController.value
              .copyWith(
                text: state.phoneNumber,
                selection: TextSelection.collapsed(
                  offset: min(
                    phoneTextEditingController.value.selection.start,
                    state.phoneNumber.length,
                  ),
                ),
              );
        }

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
          backgroundColor: const Color(0xFFFEF8F4),
          body: PopScope(
            canPop: true,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              context.read<RegisterCubit>().init();
            },
            child: Container(
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
                  builder: (context, constraints) {
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
                            children: [
                              BaseButton(
                                child: Assets.v2.icons.icBack.svg(),
                                onTap: () {
                                  context.read<RegisterCubit>().init();
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go(RoutePaths.welcome);
                                  }
                                },
                              ),
                              "Let’s get you set up"
                                  .appText(
                                    fraunces: true,
                                    fontSize: 28,
                                    textAlign: TextAlign.start,
                                  )
                                  .appPadding(left: 20.r, right: 20.r),
                              "We only ask for what we need to make your first suggestion useful."
                                  .appText(
                                    textAlign: TextAlign.start,
                                    fontSize: 14,
                                    color: greyColor,
                                  )
                                  .appPadding(left: 20.r, right: 20.r),
                              21.spaceH,
                              AppTextField(
                                controller: phoneTextEditingController,
                                title: "PHONE NUMBER",
                                hint: "Enter mobile number",
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9+]'),
                                  ),
                                ],
                                onChanged: (val) {
                                  context.read<RegisterCubit>().changeProps(
                                    phoneNumber: val,
                                    phoneNumberError: '',
                                  );
                                },
                                error: state.phoneNumberError.isNotEmpty
                                    ? state.phoneNumberError
                                    : null,
                              ).appPadding(left: 20.r, right: 20.r),
                              16.spaceH,
                              AppTextField(
                                controller: emailTextEditingController,
                                title: "EMAIL",
                                hint: "you@example.com",
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (val) {
                                  context.read<RegisterCubit>().changeProps(
                                    emailAddress: val,
                                    emailAddressError: '',
                                  );
                                },
                                error: state.emailAddressError.isNotEmpty
                                    ? state.emailAddressError
                                    : null,
                              ).appPadding(left: 20.r, right: 20.r),
                              28.spaceH,
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: greyColor2,
                                      height: 1.r,
                                    ),
                                  ),
                                  12.spaceW,
                                  "or".appText(
                                    textAlign: TextAlign.start,
                                    fontSize: 14,
                                    color: greyColor,
                                  ),
                                  12.spaceW,
                                  Expanded(
                                    child: Container(
                                      color: greyColor2,
                                      height: 1.r,
                                    ),
                                  ),
                                ],
                              ).appPadding(left: 20.r, right: 20.r),
                              24.spaceH,
                              if (Platform.isIOS) ...[
                                AppButton(
                                  onTap: state.isAuthSubmitting
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();
                                          context
                                              .read<RegisterCubit>()
                                              .signInWithApple();
                                        },
                                  backgroundColor: const Color(0xFF1F222A),
                                  isLoading: isAppleLoading,
                                  loaderColor: Colors.white,
                                  widget: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Assets.v2.icons.icAppleIcon.image(
                                        color: Colors.white,
                                        height: 24.r,
                                        width: 24.r,
                                      ),
                                      10.spaceW,
                                      "Continue with Apple".appText(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                                14.spaceH,
                              ],
                              AppButton(
                                onTap: state.isAuthSubmitting
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus();
                                        context
                                            .read<RegisterCubit>()
                                            .googleAuthenticate();
                                      },
                                backgroundColor: const Color(0xFF1F222A),
                                isLoading: isGoogleLoading,
                                loaderColor: Colors.white,
                                widget: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Assets.v2.icons.icGoogleIcon.image(
                                      height: 24.r,
                                      width: 24.r,
                                    ),
                                    10.spaceW,
                                    "Continue with Google".appText(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              24.spaceH,
                              AppButton(
                                onTap: state.isAuthSubmitting
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus();
                                        context.read<RegisterCubit>().sendOtp();
                                      },
                                title: "Continue",
                                isLoading: isContinueLoading,
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
          ),
        );
      },
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          data: (data) async {
            if (data is Map<String, dynamic> &&
                (data['uid']?.toString().trim().isNotEmpty ?? false)) {
              final UserModel userModel = UserModel.fromJson(data);
              await preferences.saveUserModel(userModel);
              if (!context.mounted) return;
              final GoRouter router = GoRouter.of(context);
              context.read<RegisterCubit>().changeProps(
                apiResultStatus: const ApiResultStatus.initial(),
              );

              await preferences.putBool(SharedPreference.isLogin, true);
              final bool handledInvite = await navigateForPendingInvitation(
                context: context,
                userModel: userModel,
                router: router,
              );
              if (handledInvite) return;

              if (!context.mounted) return;
              context.read<OnboardingCubit>().reset();
              if (userModel.isOnboardingCompleted) {
                router.go(RoutePaths.base);
              } else {
                router.go(RoutePaths.onboarding);
              }
            } else {
              final String destination = state.isPhoneAuth
                  ? state.phoneNumber.trim()
                  : state.emailAddress.trim();
              final bool isPhone = state.isPhoneAuth;
              final String verificationId = state.phoneVerificationId;
              final int? resendToken = state.phoneResendToken;
              final String linkedEmail = state.linkedEmail;
              final String linkedPhone = state.linkedPhone;

              context.read<RegisterCubit>().changeProps(
                apiResultStatus: const ApiResultStatus.initial(),
              );
              context.push(
                RoutePaths.otp,
                extra: <String, dynamic>{
                  'destination': destination,
                  'verificationId': verificationId,
                  'resendToken': resendToken,
                  'isPhoneAuth': isPhone,
                  'linkedEmail': linkedEmail,
                  'linkedPhone': linkedPhone,
                },
              );
            }
          },
          error: (error) {
            final String message = error.toString().replaceAll(
              "Exception: ",
              "",
            );
            final String normalized = message.toLowerCase();
            final bool isCancelled =
                normalized.contains('code=canceled') ||
                normalized.contains('cancelled by the user') ||
                normalized.contains('canceled') ||
                normalized.contains('empty account');
            context.read<RegisterCubit>().changeProps(
              apiResultStatus: const ApiResultStatus.initial(),
            );
            if (isCancelled) return;
            showSnackBar(message: message, type: SnackBarType.ERROR);
          },
        );
      },
    );
  }
}
