import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
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
  Widget build(BuildContext context) {
    return BlocConsumer<InviteRespondCubit, InviteRespondState>(
      listener: (BuildContext context, InviteRespondState state) {
        state.previewStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) => EasyLoading.dismiss(),
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
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
            state.status == 'REQUESTED' || state.status.isEmpty;
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: SafeArea(
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
                    child: Icon(Icons.arrow_back_rounded, size: 22.sp),
                  ),
                  24.spaceH,
                  'Co-parent invitation'.appText(
                    fraunces: true,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  12.spaceH,
                  if (state.fromParentName.isNotEmpty)
                    '${state.fromParentName} invited you to care for ${state.childNames.isNotEmpty ? state.childNames : 'their child'}.'
                        .appText(fontSize: 16, height: 1.4)
                  else
                    'Review this invitation and choose accept or decline.'
                        .appText(fontSize: 16, height: 1.4),
                  8.spaceH,
                  if (state.invitedEmailMasked.isNotEmpty)
                    'Invited as ${state.invitedEmailMasked}'.appText(
                      fontSize: 13,
                      color: const Color(0xFF8A8A8A),
                    ),
                  if (state.role.isNotEmpty) ...<Widget>[
                    8.spaceH,
                    'Role: ${state.role}'.appText(fontSize: 14),
                  ],
                  const Spacer(),
                  if (canRespond) ...<Widget>[
                    AppButton(
                      title: 'Accept invitation',
                      onTap: () => cubit.accept(),
                    ),
                    12.spaceH,
                    AppButton(
                      title: 'Decline',
                      backgroundColor: Colors.white,
                      borderColor: const Color(0xFFD84315),
                      textColor: const Color(0xFFD84315),
                      onTap: () => cubit.reject(),
                    ),
                  ],
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
