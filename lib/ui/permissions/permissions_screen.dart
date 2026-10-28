import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import 'bloc/permissions_cubit.dart';
import 'bloc/permissions_state.dart';

/// Screen 58: Caregiver Permissions.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class PermissionsScreen extends StatefulWidget {
  final String? caregiverName;
  final String? caregiverRole;

  const PermissionsScreen({super.key, this.caregiverName, this.caregiverRole});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionsCubit>().init(
        caregiverName: widget.caregiverName,
        role: widget.caregiverRole,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionsCubit, PermissionsState>(
      listener: (BuildContext context, PermissionsState state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (dynamic data) {
            EasyLoading.dismiss();
            if (data == 'permissions_saved') {
              showSnackBar(
                message: "Permissions saved successfully",
                type: SnackBarType.SUCCESS,
              );
              Navigator.pop(context);
            } else if (data == 'access_revoked') {
              showSnackBar(
                message: "Access removed for ${state.caregiverName}",
                type: SnackBarType.SUCCESS,
              );
              Navigator.pop(context);
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
      builder: (BuildContext context, PermissionsState state) {
        final PermissionsCubit cubit = context.read<PermissionsCubit>();

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
                          "What ${state.caregiverName} can see".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          8.spaceH,
                          "Change any of this at any time.".appText(
                            fontSize: 14.sp,
                            color: greyColor,
                            textAlign: TextAlign.start,
                          ),
                          24.spaceH,
                          _buildToggleCard(
                            title: "Sleep",
                            subtitle: "Naps, bedtimes and night waking",
                            value: state.sleepEnabled,
                            onChanged: (_) => cubit.toggleSleep(),
                          ),
                          12.spaceH,
                          _buildToggleCard(
                            title: "Behaviour",
                            subtitle: "Tantrum updates and patterns",
                            value: state.behaviourEnabled,
                            onChanged: (_) => cubit.toggleBehaviour(),
                          ),
                          12.spaceH,
                          _buildToggleCard(
                            title: "Health notes",
                            subtitle: "Illness, teething and medication",
                            value: state.healthNotesEnabled,
                            onChanged: (_) => cubit.toggleHealthNotes(),
                          ),
                          12.spaceH,
                          _buildToggleCard(
                            title: "Plans",
                            subtitle: "Today's plan and what you're trying",
                            value: state.plansEnabled,
                            onChanged: (_) => cubit.togglePlans(),
                          ),
                          12.spaceH,
                          _buildToggleCard(
                            title: "Mentorship summaries",
                            subtitle: "Notes from sessions with a guide",
                            value: state.mentorshipEnabled,
                            onChanged: (_) => cubit.toggleMentorship(),
                          ),
                          16.spaceH,
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: softPeachOrange,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: primaryColor,
                                  size: 20.sp,
                                ),
                                12.spaceW,
                                Expanded(
                                  child:
                                      "Parent reflections and private notes are never shared with co-parents or caregivers under any circumstances."
                                          .appText(
                                            fontSize: 13.sp,
                                            color: greyColor9,
                                            textAlign: TextAlign.start,
                                            height: 1.4,
                                          ),
                                ),
                              ],
                            ),
                          ),
                          160.spaceH,
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

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.appText(
                  fontSize: 16.sp,
                  color: greyColor9,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
                4.spaceH,
                subtitle.appText(
                  fontSize: 14.sp,
                  color: greyColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          16.spaceW,
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF673AB7), // Purple
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE6DDD5),
            trackOutlineColor: const WidgetStatePropertyAll<Color>(
              Color(0xFFE6DDD5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    PermissionsState state,
    PermissionsCubit cubit,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: 24.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: const BoxDecoration(color: Color(0xFFFEF2EA)),
        child: Column(
          children: [
            AppButton(
              title: state.isSaving ? "Saving..." : "Save permissions",
              onTap: state.isSaving
                  ? () {}
                  : () {
                      cubit.savePermissions();
                    },
            ),
            16.spaceH,
            BaseButton(
              onTap: state.isSaving
                  ? () {}
                  : () {
                      _showRemoveAccessDialog(
                        context,
                        cubit,
                        state.caregiverName,
                      );
                    },
              child: "Remove ${state.caregiverName}'s access".appText(
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

  void _showRemoveAccessDialog(
    BuildContext context,
    PermissionsCubit cubit,
    String caregiverName,
  ) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_remove_outlined,
                    color: const Color(0xFFD84315),
                    size: 26.sp,
                  ),
                ),
                16.spaceH,
                "Remove access?".appText(
                  fontSize: 20.sp,
                  color: greyColor9,
                  fraunces: true,
                ),
                8.spaceH,
                "Are you sure you want to remove access for $caregiverName? They will no longer see your family logs."
                    .appText(
                      fontSize: 14.sp,
                      color: greyColor,
                      textAlign: TextAlign.center,
                      height: 1.4,
                    ),
                20.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        height: 44.h,
                        padding: EdgeInsets.zero,
                        title: 'Cancel',
                        backgroundColor: const Color(0xFFF8F5F2),
                        borderColor: const Color(0xFFE9E2DC),
                        textColor: greyColor9,
                        onTap: () => Navigator.pop(dialogContext),
                      ),
                    ),
                    12.spaceW,
                    Expanded(
                      child: AppButton(
                        height: 44.h,
                        padding: EdgeInsets.zero,
                        title: 'Remove',
                        backgroundColor: const Color(0xFFD84315),
                        borderColor: const Color(0xFFD84315),
                        textColor: Colors.white,
                        onTap: () {
                          Navigator.pop(dialogContext);
                          cubit.revokeAccess();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
