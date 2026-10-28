import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/invite_pending/invite_pending_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';

import 'bloc/invite_caregiver_cubit.dart';
import 'bloc/invite_caregiver_state.dart';

/// Screen 55: Invite a Caregiver.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class InviteCaregiverScreen extends StatefulWidget {
  const InviteCaregiverScreen({super.key});

  @override
  State<InviteCaregiverScreen> createState() => _InviteCaregiverScreenState();
}

class _InviteCaregiverScreenState extends State<InviteCaregiverScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InviteCaregiverCubit>().init();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InviteCaregiverCubit, InviteCaregiverState>(
      listener: (BuildContext context, InviteCaregiverState state) {
        state.sendStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: "Invitation sent successfully",
              type: SnackBarType.SUCCESS,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => InvitePendingScreen(
                  invitationId: state.createdInvitationId,
                  recipientEmail: state.email.trim(),
                  role: state.selectedRole,
                  childName: state.childName,
                ),
              ),
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
      builder: (BuildContext context, InviteCaregiverState state) {
        final InviteCaregiverCubit cubit = context.read<InviteCaregiverCubit>();

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
                          "Invite a caregiver".appText(
                            fontSize: 28.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          8.spaceH,
                          "They'll get a link to join — no account needed first."
                              .appText(
                                fontSize: 14.sp,
                                color: greyColor6,
                                textAlign: TextAlign.start,
                              ),
                          24.spaceH,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: state.emailError.isNotEmpty
                                    ? redColor
                                    : secondaryColor,
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "EMAIL".appText(
                                        fontSize: 12.sp,
                                        color: state.emailError.isNotEmpty
                                            ? redColor
                                            : greyColor11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      4.spaceH,
                                      TextField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        onChanged: (String val) {
                                          cubit.updateEmail(val);
                                        },
                                        style: getTextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: greyColor9,
                                        ),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          hintText: "e.g. name@example.com",
                                          hintStyle: getTextStyle(
                                            fontSize: 16.sp,
                                            color: greyColor4,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (state.email.trim().isNotEmpty &&
                                    state.email.trim().isValidEmail &&
                                    !cubit.isSelfEmail(state.email.trim()))
                                  Container(
                                    padding: EdgeInsets.all(3.r),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (state.emailError.isNotEmpty) ...[
                            6.spaceH,
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: state.emailError.appText(
                                fontSize: 12.sp,
                                color: redColor,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                          24.spaceH,
                          "THEIR RELATIONSHIP TO ${state.childName.toUpperCase()}"
                              .appText(
                                fontSize: 16.sp,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.start,
                              ),
                          12.spaceH,
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _buildRoleChip(context, state, "Partner"),
                              _buildRoleChip(context, state, "Grandparent"),
                              _buildRoleChip(context, state, "Nanny"),
                              _buildRoleChip(context, state, "Other"),
                            ],
                          ),
                          24.spaceH,
                          InfoBox(
                            backgroundColor: softPeachOrange,
                            textColor: primaryColor,
                            iconColor: primaryColor,
                            iconData: Icons.info,
                            body: "",
                            title: state.selectedRole == "Grandparent"
                                ? "Grandparents start with sleep and plans only. You can change exactly what they see in Permissions before or after they join."
                                : "Selected role starts with tailored permissions. You can change exactly what they see in Permissions before or after they join.",
                          ),
                          12.spaceH,
                          InfoBox.white(
                            title: "What they won't see",
                            body:
                                "Health notes, mentorship summaries and your own reflections stay private unless you choose to share them.",
                          ),
                          140.spaceH,
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

  Widget _buildRoleChip(
    BuildContext context,
    InviteCaregiverState state,
    String label,
  ) {
    final bool isSelected = state.selectedRole == label;
    return GestureDetector(
      onTap: () => context.read<InviteCaregiverCubit>().selectRole(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF673AB7)
                : greyColor.withValues(alpha: 0.2),
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: label.appText(
          fontSize: 14.sp,
          color: isSelected ? const Color(0xFF673AB7) : greyColor9,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    InviteCaregiverState state,
    InviteCaregiverCubit cubit,
  ) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: isKeyboardOpen ? 10.h : 24.h,
          bottom: isKeyboardOpen
              ? 10.h
              : (20.h + MediaQuery.of(context).padding.bottom),
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
        child: AppButton(
          title: state.isSending ? "Sending..." : "Send invite",
          onTap: state.isSending
              ? () {}
              : () {
                  cubit.sendInvite();
                },
        ),
      ),
    );
  }
}
