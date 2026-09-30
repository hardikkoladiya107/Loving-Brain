import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart';
import 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_state.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/editable_field_card.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/location_picker_sheet.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentProfileV2Cubit()..init(),
      child: const _ParentProfileView(),
    );
  }
}

class _ParentProfileView extends StatelessWidget {
  const _ParentProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentProfileV2Cubit, ParentProfileV2State>(
      listener: (context, state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(status: 'Saving...'),
          data: (String message) {
            EasyLoading.dismiss();
            showSnackBar(message: message, type: SnackBarType.SUCCESS);
          },
          error: (Exception exception) {
            EasyLoading.dismiss();
            showSnackBar(
              message: exception.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );

        state.logoutStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            context.go(RoutePaths.welcome);
          },
          error: (Exception exception) {
            EasyLoading.dismiss();
            context.go(RoutePaths.welcome);
          },
        );

        state.deleteAccountStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            context.go(RoutePaths.welcome);
          },
          error: (Exception exception) {
            EasyLoading.dismiss();
            context.go(RoutePaths.welcome);
          },
        );
      },
      builder: (context, state) {
        final cubit = context.read<ParentProfileV2Cubit>();
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              Positioned(
                left: -150,
                top: -150,
                child: Container(
                  width: 400,
                  height: 400,
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
              Positioned(
                right: -150,
                bottom: 0,
                child: Container(
                  width: 400,
                  height: 400,
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
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
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
                          Expanded(
                            child: Center(
                              child: "Your profile".appText(
                                fontSize: 24.sp,
                                color: greyColor9,
                                fraunces: true,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            position: PopupMenuPosition.under,
                            offset: Offset(0, 8.h),
                            color: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            elevation: 12,
                            shadowColor: Colors.black.withValues(alpha: 0.12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              side: const BorderSide(
                                color: Color(0xFFF3ECE7),
                                width: 1,
                              ),
                            ),
                            onSelected: (value) {
                              if (value == 'logout') {
                                _showLogoutDialog(context);
                              } else if (value == 'delete') {
                                _showDeleteAccountDialog(context);
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'logout',
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 6.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36.w,
                                          height: 36.w,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF0E5),
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.logout_rounded,
                                            color: primaryColor,
                                            size: 18.sp,
                                          ),
                                        ),
                                        12.spaceW,
                                        "Log out".appText(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: greyColor9,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuDivider(height: 1),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 6.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36.w,
                                          height: 36.w,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFEBEE),
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: const Color(0xFFD84315),
                                            size: 18.sp,
                                          ),
                                        ),
                                        12.spaceW,
                                        "Delete account".appText(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFD84315),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.more_vert_rounded,
                                color: darkBlue,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          24.spaceH,
                          Center(
                            child: Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDC21A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.face,
                                size: 48.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          32.spaceH,
                          EditableFieldCard(
                            label: "YOUR NAME",
                            value: state.name,
                            maxLength: 50,
                            onChanged: (v) => cubit.updateField(name: v),
                            onEdit: () {},
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "YOUR EMAIL",
                            value: state.user?.email ?? "",
                            readOnly: true,
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "PREFERRED LANGUAGE",
                            value: state.language,
                            onChanged: (v) => cubit.updateField(language: v),
                            onEdit: () {},
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "LOCATION / TIME ZONE",
                            value: state.location,
                            hintText: "Select location & time zone",
                            readOnly: true,
                            onTap: () => showLocationPickerSheet(
                              context,
                              initialLocation: state.location,
                              initialLocationData: cubit.locationData,
                              onLocationSelected: cubit.updateLocationData,
                            ),
                            onEdit: () => showLocationPickerSheet(
                              context,
                              initialLocation: state.location,
                              initialLocationData: cubit.locationData,
                              onLocationSelected: cubit.updateLocationData,
                            ),
                          ),
                          24.spaceH,
                          InfoBox.orange(
                            iconData: null,
                            body:
                                "Your time zone is used to work out sleep windows, so it's worth updating if you travel for a while.",
                          ),
                          120.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomActions(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 40.h,
          bottom: 40.h,
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
          title: "Save changes",
          onTap: () {
            FocusScope.of(context).unfocus();
            context.read<ParentProfileV2Cubit>().saveProfile();
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final ParentProfileV2Cubit cubit = context.read<ParentProfileV2Cubit>();
    _showThemedConfirmDialog(
      context: context,
      icon: Icons.logout_rounded,
      iconColor: primaryColor,
      iconBgColor: const Color(0xFFFFF0E5),
      title: 'Log out?',
      message: 'Are you sure you want to log out of your account?',
      confirmText: 'Log out',
      confirmColor: primaryColor,
      onConfirm: cubit.logout,
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final ParentProfileV2Cubit cubit = context.read<ParentProfileV2Cubit>();
    _showThemedConfirmDialog(
      context: context,
      icon: Icons.delete_outline_rounded,
      iconColor: const Color(0xFFD84315),
      iconBgColor: const Color(0xFFFFEBEE),
      title: 'Delete account?',
      message:
          'Are you sure you want to delete your account? This action is permanent and cannot be undone.',
      confirmText: 'Delete',
      confirmColor: const Color(0xFFD84315),
      onConfirm: cubit.deleteAccount,
    );
  }

  void _showThemedConfirmDialog({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28.sp),
                ),
                18.spaceH,
                title.appText(
                  fontSize: 22.sp,
                  color: greyColor9,
                  fraunces: true,
                ),
                10.spaceH,
                message.appText(
                  fontSize: 14.sp,
                  color: greyColor,
                  height: 1.4,
                ),
                24.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        height: 48.h,
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
                        height: 48.h,
                        padding: EdgeInsets.zero,
                        title: confirmText,
                        backgroundColor: confirmColor,
                        borderColor: confirmColor,
                        textColor: Colors.white,
                        onTap: () {
                          Navigator.pop(dialogContext);
                          onConfirm();
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
