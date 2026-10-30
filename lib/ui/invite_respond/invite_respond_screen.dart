import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_loading_indicator.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import 'bloc/invite_respond_cubit.dart';
import 'bloc/invite_respond_state.dart';

class InviteRespondScreen extends StatefulWidget {
  const InviteRespondScreen({super.key, this.invitationId});

  final String? invitationId;

  @override
  State<InviteRespondScreen> createState() => _InviteRespondScreenState();
}

class _InviteRespondScreenState extends State<InviteRespondScreen> {
  Widget _detailsCard(InviteRespondState state) {
    final String childName = state.childNames.trim();
    final String email = state.invitedEmailMasked.trim();
    final String role = state.role.trim();
    final List<Widget> rows = <Widget>[
      if (childName.isNotEmpty)
        _detailRow(label: 'CARING FOR', value: childName),
      if (email.isNotEmpty) _detailRow(label: 'INVITED AS', value: email),
      if (role.isNotEmpty)
        _detailRow(label: 'YOUR ROLE', value: role, badge: true),
    ];
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE9E2DC)),
      ),
      child: Column(
        children: <Widget>[
          for (int index = 0; index < rows.length; index++) ...<Widget>[
            rows[index],
            if (index != rows.length - 1)
              Divider(
                height: 1.h,
                thickness: 1.h,
                color: const Color(0xFFF0E8E2),
              ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow({
    required String label,
    required String value,
    bool badge = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: label.appText(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: greyColor6,
              letterSpacing: 0.6,
              textAlign: TextAlign.start,
            ),
          ),
          12.spaceW,
          if (badge)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: indigoLight,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: value.appText(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: secondaryColor,
                letterSpacing: 0,
                textAlign: TextAlign.start,
              ),
            )
          else
            Flexible(
              child: value.appText(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: greyColor9,
                letterSpacing: 0,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  void _leaveClosedInvite(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    final bool isLoggedIn =
        preferences.getBool(SharedPreference.isLogin) ?? false;
    context.go(isLoggedIn ? RoutePaths.base : RoutePaths.welcome);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String id =
          (widget.invitationId ?? PendingInvitationManager.getId()).trim();
      context.read<InviteRespondCubit>().init(invitationId: id);
    });
  }

  @override
  void dispose() {
    // If splash or a new link replaces this screen mid-load, the loading
    // mask must not stay behind and swallow taps on Today.
    unawaited(EasyLoading.dismiss(animation: false));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InviteRespondCubit, InviteRespondState>(
      listener: (BuildContext context, InviteRespondState state) {
        state.previewStatus.whenOrNull(
          data: (_) {
            unawaited(EasyLoading.dismiss(animation: false));
          },
          error: (Exception error) {
            unawaited(EasyLoading.dismiss(animation: false));
            final String message = error.toString().replaceAll(
              'Exception: ',
              '',
            );
            showSnackBar(message: message, type: SnackBarType.ERROR);
            if (message == LocaleKeys.deepLinkInvitationInvalid.tr()) {
              _leaveClosedInvite(context);
            }
          },
        );
        state.actionStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (dynamic data) async {
            EasyLoading.dismiss();
            await PendingInvitationManager.clear();
            if (!context.mounted) return;
            final String payload = data?.toString() ?? '';
            if (payload == 'rejected') {
              showSnackBar(
                message: 'Invitation declined',
                type: SnackBarType.SUCCESS,
              );
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RoutePaths.base);
              }
              return;
            }
            final UserModel? user = preferences.getUserModel();
            final bool onboarded = user?.isOnboardingCompleted ?? false;
            showSnackBar(
              message: LocaleKeys.coParentInvitationAcceptedSuccess.tr(),
              type: SnackBarType.SUCCESS,
            );
            if (!onboarded) {
              context.go(RoutePaths.onboarding);
            } else {
              context.go(RoutePaths.base);
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
      },
      builder: (BuildContext context, InviteRespondState state) {
        final InviteRespondCubit cubit = context.read<InviteRespondCubit>();
        final bool canRespond =
            !state.isLoadingPreview && state.status == 'REQUESTED';
        final String childName = state.childNames.trim().isNotEmpty
            ? state.childNames.trim()
            : 'their child';
        final String intro = state.fromParentName.trim().isNotEmpty
            ? '${state.fromParentName.trim()} invited you to care for $childName.'
            : 'Review this invitation and choose accept or decline.';
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: <Widget>[
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      12.spaceH,
                      BaseButton(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(RoutePaths.base);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: darkBlue,
                            size: 22.sp,
                          ),
                        ),
                      ),
                      24.spaceH,
                      'Co-parent invitation'.appText(
                        fraunces: true,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: greyColor9,
                        textAlign: TextAlign.start,
                        letterSpacing: 0,
                      ),
                      if (state.isLoadingPreview)
                        const Expanded(child: AppLoadingIndicator())
                      else ...<Widget>[
                        10.spaceH,
                        intro.appText(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: greyColor,
                          textAlign: TextAlign.start,
                          letterSpacing: 0,
                          height: 1.4,
                        ),
                        20.spaceH,
                        _detailsCard(state),
                        const Spacer(),
                      ],
                      if (canRespond) ...<Widget>[
                        AppButton(
                          title: 'Accept invitation',
                          padding: EdgeInsets.zero,
                          onTap: () => cubit.accept(),
                        ),
                        12.spaceH,
                        AppButton(
                          title: 'Decline',
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                          borderColor: const Color(0xFFE9E2DC),
                          textColor: greyColor9,
                          onTap: () => cubit.reject(),
                        ),
                      ],
                      24.spaceH,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
