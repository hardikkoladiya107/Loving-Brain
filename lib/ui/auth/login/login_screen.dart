import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/auth/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';
import '../../../other/snack_bar.dart';
import '../../widget/base_button.dart';
import 'bloc/login_state.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LoginCubit>().init();
    });
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
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

        if (passwordTextEditingController.value.text != state.password) {
          passwordTextEditingController.value = passwordTextEditingController
              .value
              .copyWith(
                text: state.password,
                selection: TextSelection.collapsed(
                  offset: min(
                    passwordTextEditingController.value.selection.start,
                    state.password.length,
                  ),
                ),
              );
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) {
              return;
            }
            context.go(RoutePaths.welcome);
          },
          child: Scaffold(
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
                          40.spaceH,
                          _loginIcon(),
                          40.spaceH,
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 32),
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
                                _email(state),
                                16.spaceH,
                                _password(state),
                                8.spaceH,
                                _forgotPassword(),
                                24.spaceH,
                                _loginButton(state),
                                20.spaceH,
                                _dontHaveAccount(),
                              ],
                            ),
                          ).appPadding(left: 20, right: 20),
                          30.spaceH,
                          _signUpWithGoogle(state),
                          16.spaceH,
                          if (Platform.isIOS) _signUpWithApple(state),
                          60.spaceH,
                          _buildTermsText(),
                          40.spaceH,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          initial: () {},
          loading: () {},
          data: (data) {
            _loggedInSuccess(data);
          },
          error: (Exception error) {
            final String message = error.toString().replaceAll(
              "Exception: ",
              "",
            );
            final String normalizedMessage = message.toLowerCase();
            final bool isGoogleSignInCancelled =
                normalizedMessage.contains('code=canceled') ||
                normalizedMessage.contains('cancelled by the user') ||
                normalizedMessage.contains('canceled');
            if (isGoogleSignInCancelled) {
              return;
            }
            showSnackBar(message: message, type: SnackBarType.ERROR);
          },
        );
      },
    );
  }

  Widget _signUpWithGoogle(LoginState state) {
    final bool isLoading = state.submittingAction == LoginSubmitAction.google;
    final bool authBusy = state.submittingAction != LoginSubmitAction.idle;
    return BaseButton(
      onTap: authBusy
          ? null
          : () {
              context.read<LoginCubit>().googleAuthenticate();
            },
      child: Container(
        width: 310.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Assets.icons.icGoogleIcon.image(height: 24.w, width: 24.w),
            20.spaceW,
            if (isLoading)
              SizedBox(
                height: 20.r,
                width: 20.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              ).appPadding(top: 14.h, bottom: 14.h)
            else
              LocaleKeys.continueWithGoogle
                  .tr()
                  .appText(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black87,
                  )
                  .appPadding(top: 14.h, bottom: 14.h),
          ],
        ),
      ),
    );
  }

  Widget _signUpWithApple(LoginState state) {
    final bool isLoading = state.submittingAction == LoginSubmitAction.apple;
    final bool authBusy = state.submittingAction != LoginSubmitAction.idle;
    return BaseButton(
      onTap: authBusy
          ? null
          : () {
              context.read<LoginCubit>().signInWithApple();
            },
      child: Container(
        width: 310.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Assets.icons.icAppleIcon.image(height: 24.w, width: 24.w),
            20.spaceW,
            if (isLoading)
              SizedBox(
                height: 20.r,
                width: 20.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              ).appPadding(top: 14.h, bottom: 14.h)
            else
              LocaleKeys.continueWithApple
                  .tr()
                  .appText(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black87,
                  )
                  .appPadding(top: 14.h, bottom: 14.h),
          ],
        ),
      ),
    );
  }

  Widget _loginIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
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
              LocaleKeys.login.tr().appText(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              2.spaceH,
              LocaleKeys.appName.tr().appText(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ],
          ).appPadding(left: 40, right: 40, top: 20, bottom: 20),
        ),
      ],
    );
  }

  Widget _loginButton(LoginState state) {
    final bool isLoading = state.submittingAction == LoginSubmitAction.email;
    final bool authBusy = state.submittingAction != LoginSubmitAction.idle;
    return BaseButton(
      onTap: authBusy
          ? null
          : () {
              context.read<LoginCubit>().performLogin();
            },
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
            if (isLoading)
              SizedBox(
                height: 22.r,
                width: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            else
              LocaleKeys.login.tr().appText(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
          ],
        ).appPadding(top: 14.h, bottom: 14.h),
      ),
    ).appPadding(left: 32, right: 32);
  }

  Widget _dontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LocaleKeys.donHaveAnAccount.tr().appText(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        6.spaceW,
        BaseButton(
          child: LocaleKeys.signUp.tr().appText(
            color: primaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            textDecoration: TextDecoration.underline,
          ),
          onTap: () {
            context.read<LoginCubit>().clearFields();
            context.push(RoutePaths.register);
          },
        ),
      ],
    );
  }

  Widget _email(LoginState state) {
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
        context.read<LoginCubit>().changeProps(emailAddress: value);
      },
    ).appPadding(left: 24, right: 24);
  }

  Widget _password(LoginState state) {
    return AppTextField(
      controller: passwordTextEditingController,
      title: LocaleKeys.password.tr(),
      hint: LocaleKeys.enterPassword.tr(),
      error: state.passwordError,
      keyboardType: TextInputType.visiblePassword,
      fillColor: const Color(0xFFF9FAFB),
      prefixIcon: Assets.icons.icPasswordPrefixIcon.image(
        height: 24,
        width: 24,
        color: Colors.grey.shade400,
      ),
      obscureText: state.obscureTextPassword,
      maxLines: 1,
      suffixIcon: IconButton(
        icon: Icon(
          state.obscureTextPassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey.shade400,
        ),
        onPressed: () {
          context.read<LoginCubit>().changeProps(
            obscureTextPassword: !state.obscureTextPassword,
          );
        },
      ),
      onChanged: (value) {
        context.read<LoginCubit>().changeProps(password: value);
      },
    ).appPadding(left: 24, right: 24);
  }

  Widget _forgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BaseButton(
          child: LocaleKeys.forgotPassword.tr().appText(
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade700,
            fontSize: 12,
          ),
          onTap: () {
            context.read<LoginCubit>().clearFields();
            context.push(RoutePaths.forgotPassword);
          },
        ),
        30.spaceW,
      ],
    );
  }

  Future<void> _loggedInSuccess(Map<String, dynamic> data) async {
    final UserModel userModel = UserModel.fromJson(data);
    final GoRouter router = GoRouter.of(context);
    await preferences.saveUserModel(userModel);
    if (!mounted) return;
    context.read<LoginCubit>().clearFields();
    if (userModel.uid == null) return;

    // ── Pending co-parent invitation (saved by DeepLinkManager before login) ──
    if (PendingInvitationManager.hasPending()) {
      final String pendingId = PendingInvitationManager.getId();
      final String pendingEmail = PendingInvitationManager.getEmail();
      final String loggedEmail = (userModel.email ?? '').trim().toLowerCase();

      if (loggedEmail == pendingEmail.trim().toLowerCase()) {
        final ApiResultStatus result = await CoParentRepo.instance
            .addUserAsCoParent(pendingId);

        bool invitationSuccess = false;
        result.whenOrNull(data: (_) => invitationSuccess = true);

        if (invitationSuccess) {
          await PendingInvitationManager.clear();
        }

        if (!mounted) {
          return;
        }

        if (invitationSuccess) {
          await preferences.putBool(SharedPreference.isLogin, true);
          router.push(
            RoutePaths.successScreen,
            extra: LocaleKeys.coParentInvitationAcceptedSuccess.tr(),
          );
          return;
        }

        String errMsg = '';
        result.whenOrNull(
          error: (Exception err) =>
              errMsg = err.toString().replaceAll('Exception: ', ''),
        );
        if (errMsg.isNotEmpty) {
          showSnackBar(message: errMsg, type: SnackBarType.ERROR);
        }
      } else {
        await PendingInvitationManager.clear();
      }
    }
    // ─────────────────────────────────────────────────────────────────────────

    if (!mounted) return;
    if ((userModel.parentName ?? '').isEmpty ||
        (userModel.parentGender ?? '').isEmpty ||
        (userModel.parentEmail ?? '').isEmpty ||
        userModel.parentDateOfBirth == null) {
      router.go(RoutePaths.parentProfile);
    } else if ((userModel.childName ?? '').isEmpty ||
        (userModel.childAge ?? '').isEmpty ||
        (userModel.relationshipToChild ?? '').isEmpty) {
      router.go(RoutePaths.childProfilePath(userModel.uid!));
    } else {
      await preferences.putBool(SharedPreference.isLogin, true);
      router.go(RoutePaths.base);
    }
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: getTextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(text: "By continuing, you agree to our\n"),
          TextSpan(
            text: "Terms & Conditions",
            style: getTextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              textDecoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (!mounted) return;
                context.push(RoutePaths.terms);
              },
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy",
            style: getTextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              textDecoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (!mounted) return;
                context.push(RoutePaths.privacy);
              },
          ),
          TextSpan(text: "."),
        ],
      ),
    ).appPadding(left: 24, right: 24);
  }
}
