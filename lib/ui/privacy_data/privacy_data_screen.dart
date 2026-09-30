import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/family_menu/family_menu_screen.dart';
import 'package:loving_brain/ui/privacy_policy/privacy_policy_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/setting_tile.dart';
import 'package:loving_brain/ui/widget/status_pill.dart';
import 'package:loving_brain/ui/widget/warning_box.dart';

import 'bloc/privacy_data_cubit.dart';
import 'bloc/privacy_data_state.dart';

class PrivacyDataScreen extends StatelessWidget {
  const PrivacyDataScreen({super.key});

  void _confirmDeleteAccount(BuildContext context) {
    final cubit = context.read<PrivacyDataCubit>();
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (dialogContext) => Dialog(
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
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: const Color(0xFFD84315),
                  size: 28.sp,
                ),
              ),
              18.spaceH,
              "Delete account?".appText(
                fontSize: 22.sp,
                color: greyColor9,
                fraunces: true,
              ),
              10.spaceH,
              "Are you sure you want to permanently delete your account and all associated data? This action cannot be undone."
                  .appText(
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
                      title: "Cancel",
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
                      title: "Delete",
                      backgroundColor: const Color(0xFFD84315),
                      borderColor: const Color(0xFFD84315),
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        cubit.deleteAccount();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrivacyDataCubit()..init(),
      child: BlocConsumer<PrivacyDataCubit, PrivacyDataState>(
        listener: (context, state) {
          if (state.isAccountDeleted) {
            context.go(RoutePaths.welcome);
            return;
          }
          if (state.errorMessage.isNotEmpty) {
            showSnackBar(
              message: state.errorMessage,
              type: SnackBarType.ERROR,
            );
          }
        },
        builder: (context, state) {
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
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          children: [
                            16.spaceH,
                            "Privacy & data".appText(
                              fontSize: 32.sp,
                              color: greyColor9,
                              fraunces: true,
                              textAlign: TextAlign.start,
                            ),
                            24.spaceH,
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StatusPill(
                                    text: "In short",
                                    textColor: yellowColor1,
                                    backgroundColor: lightYellowColor,
                                    leading: Icon(
                                      Icons.stars,
                                      color: yellowColor1,
                                      size: 14.sp,
                                    ),
                                  ),
                                  16.spaceH,
                                  "Invite sent to Grandma".appText(
                                    fontSize: 20.sp,
                                    color: greyColor9,
                                    fraunces: true,
                                    textAlign: TextAlign.start,
                                  ),
                                  8.spaceH,
                                  "Sent 2 days ago to grandma@example.com. We'll let you know as soon as she accepts."
                                      .appText(
                                        fontSize: 14.sp,
                                        color: greyColor,
                                        textAlign: TextAlign.start,
                                      ),
                                ],
                              ),
                            ),
                            12.spaceH,
                            SettingTile(
                              icon: Image.asset(
                                Assets.v2.icons.icLinkedCaregivers.path,
                                width: 24.sp,
                                height: 24.sp,
                              ),
                              iconBackgroundColor: const Color(0xFFFCF4FF),
                              title: "Linked caregivers",
                              subtitle: "2 people · Ravi and Grandma",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FamilyMenuScreen(),
                                  ),
                                );
                              },
                            ),
                            12.spaceH,
                            SettingTile(
                              icon: Image.asset(
                                Assets.v2.icons.icPrivacyPolicy.path,
                                width: 24.sp,
                                height: 24.sp,
                              ),
                              iconBackgroundColor: const Color(0xFFF0F6FF),
                              title: "Read the full privacy policy",
                              subtitle: "Updated March 2026",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                            ),
                            24.spaceH,
                            AppButton(
                              title: "Export my data",
                              backgroundColor: Colors.white,
                              textColor: greyColor9,
                              borderColor: greyColor.withValues(alpha: 0.2),
                              onTap: () {},
                            ),
                            24.spaceH,
                            WarningBox(
                              label: "Permanent",
                              body:
                                  "Deleting removes ${state.childName}'s profile, every update and all guidance. Linked caregivers lose access immediately. This can't be undone.",
                            ),
                            24.spaceH,
                            AppButton(
                              title: state.isDeletingAccount
                                  ? "Deleting..."
                                  : "Delete account",
                              backgroundColor: Colors.white,
                              textColor: const Color(0xFFD84315), // Red
                              borderColor: const Color(0xFFD84315),
                              onTap: state.isDeletingAccount
                                  ? null
                                  : () => _confirmDeleteAccount(context),
                            ),
                            40.spaceH,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
