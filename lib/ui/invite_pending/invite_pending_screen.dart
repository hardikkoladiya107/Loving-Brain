import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/status_pill.dart';

import 'bloc/invite_pending_cubit.dart';
import 'bloc/invite_pending_state.dart';

/// Screen 56: Invite Pending.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class InvitePendingScreen extends StatefulWidget {
  final String? recipientEmail;
  final String? role;

  const InvitePendingScreen({super.key, this.recipientEmail, this.role});

  @override
  State<InvitePendingScreen> createState() => _InvitePendingScreenState();
}

class _InvitePendingScreenState extends State<InvitePendingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvitePendingCubit>().init(
        recipient: widget.recipientEmail,
        role: widget.role,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvitePendingCubit, InvitePendingState>(
      listener: (BuildContext context, InvitePendingState state) {
        state.actionStatus.whenOrNull(
          data: (dynamic data) {
            if (data == 'invite_resent') {
              showSnackBar(
                message: "Invite resent to ${state.recipientEmail}",
                type: SnackBarType.SUCCESS,
              );
            } else if (data == 'invite_cancelled') {
              showSnackBar(
                message: "Invitation cancelled",
                type: SnackBarType.SUCCESS,
              );
              Navigator.pop(context);
            }
          },
        );
      },
      builder: (BuildContext context, InvitePendingState state) {
        final InvitePendingCubit cubit = context.read<InvitePendingCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top Left Glow
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              // Bottom Right Glow
              Positioned(
                right: -150.w,
                bottom: 0,
                child: Container(
                  width: 400.w,
                  height: 400.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: darkBlue,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          16.spaceH,
                          "Invite pending".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          24.spaceH,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatusPill.pending(),
                                16.spaceH,
                                "Invite sent to ${state.role.isNotEmpty ? state.role : 'Caregiver'}"
                                    .appText(
                                      fontSize: 20.sp,
                                      color: greyColor9,
                                      fraunces: true,
                                    ),
                                8.spaceH,
                                (state.recipientEmail.trim().isNotEmpty
                                        ? "Sent to ${state.recipientEmail}. We'll let you know as soon as they accept."
                                        : "We'll let you know as soon as they accept.")
                                    .appText(
                                      fontSize: 14.sp,
                                      color: greyColor6,
                                      textAlign: TextAlign.start,
                                    ),
                              ],
                            ),
                          ),
                          12.spaceH,
                          InfoBox.white(
                            title: "What they'll see when they join",
                            body:
                                "Sleep updates and today's plan. Nothing else, unless you change it.",
                          ),
                          12.spaceH,
                          InfoBox(
                            iconData: null,
                            textColor: primaryColor,
                            backgroundColor: softPeachOrange,
                            body:
                                "Invites expire after ${state.daysUntilExpiry} days. Nothing is shared until they accept.",
                          ),
                          180.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomActions(context, state, cubit),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    InvitePendingState state,
    InvitePendingCubit cubit,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 32.h,
          bottom: 32.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFEF8F4).withValues(alpha: 0.0),
              const Color(0xFFFEF8F4),
              const Color(0xFFFEF8F4),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Column(
          children: [
            AppButton(
              title: state.isResending ? "Resending..." : "Resend invite",
              backgroundColor: Colors.white,
              textColor: greyColor9,
              onTap: state.isResending
                  ? () {}
                  : () {
                      cubit.resendInvite();
                    },
            ),
            16.spaceH,
            BaseButton(
              onTap: () => cubit.cancelInvite(),
              child: "Cancel invite".appText(
                fontSize: 16.sp,
                color: greyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
