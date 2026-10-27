import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
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

/// Screen 62: Privacy & Data.
/// Conforms to AGENTS.md §5.1 and v2-doc/04_DATABASE_SCHEMA_AND_OFFLINE_RULES.md.
class PrivacyDataScreen extends StatefulWidget {
  const PrivacyDataScreen({super.key});

  @override
  State<PrivacyDataScreen> createState() => _PrivacyDataScreenState();
}

class _PrivacyDataScreenState extends State<PrivacyDataScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrivacyDataCubit>().init();
    });
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
          child: SingleChildScrollView(
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
                    .appText(fontSize: 14.sp, color: greyColor, height: 1.4),
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
                          context.read<PrivacyDataCubit>().deleteAccount();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOfflineSyncSheet(BuildContext context) {
    final PrivacyDataCubit cubit = context.read<PrivacyDataCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (BuildContext sheetContext) {
        return BlocProvider<PrivacyDataCubit>.value(
          value: cubit,
          child: BlocBuilder<PrivacyDataCubit, PrivacyDataState>(
            builder: (BuildContext context, PrivacyDataState state) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 44.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: greyColor7,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                        20.spaceH,
                        "Offline sync".appText(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          fraunces: true,
                          color: greyColor9,
                        ),
                        6.spaceH,
                        "Cloud synchronization & offline storage".appText(
                          fontSize: 14.sp,
                          color: greyColor,
                        ),
                        20.spaceH,
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F2FE),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(
                                0xFF665FCE,
                              ).withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.w,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    state.isSyncing
                                        ? Icons.sync_rounded
                                        : (state.pendingOfflineUpdatesCount > 0
                                              ? Icons.cloud_upload_outlined
                                              : Icons.cloud_done_rounded),
                                    color: const Color(0xFF665FCE),
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                              14.spaceW,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (state.pendingOfflineUpdatesCount > 0
                                            ? "${state.pendingOfflineUpdatesCount} updates waiting to sync"
                                            : "All data is up to date")
                                        .appText(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: greyColor9,
                                        ),
                                    4.spaceH,
                                    (state.isSyncing
                                            ? "Syncing in progress..."
                                            : "Last synced: ${state.lastSyncedTime.isNotEmpty ? state.lastSyncedTime : 'Just now'}")
                                        .appText(
                                          fontSize: 13.sp,
                                          color: greyColor,
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        16.spaceH,
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF8F4),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: const Color(0xFFE9E2DC)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.shield_outlined,
                                    size: 20.sp,
                                    color: primaryColor,
                                  ),
                                  8.spaceW,
                                  Expanded(
                                    child: "Offline Resilience Guarantee"
                                        .appText(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: greyColor9,
                                        ),
                                  ),
                                ],
                              ),
                              8.spaceH,
                              "LovingBrain automatically saves all logs, sleep forecasts, and parent notes locally on your device. When your phone reconnects to the internet, pending logs are seamlessly uploaded so nothing typed is ever lost."
                                  .appText(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    height: 1.4,
                                  ),
                            ],
                          ),
                        ),
                        24.spaceH,
                        AppButton(
                          title: state.isSyncing ? "Syncing..." : "Sync now",
                          isLoading: state.isSyncing,
                          backgroundColor: primaryColor,
                          textColor: Colors.white,
                          onTap: state.isSyncing
                              ? null
                              : () {
                                  sheetContext
                                      .read<PrivacyDataCubit>()
                                      .manualSyncOfflineUpdates();
                                },
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(sheetContext).padding.bottom + 12.h,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivacyDataCubit, PrivacyDataState>(
      listener: (BuildContext context, PrivacyDataState state) {
        state.syncStatus.whenOrNull(
          data: (dynamic data) {
            final int count = (data is int) ? data : 0;
            showSnackBar(
              message: count > 0
                  ? "Synced $count pending update(s) to cloud successfully."
                  : "All data is up to date. Cloud storage is synchronized.",
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception error) {
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );

        state.exportStatus.whenOrNull(
          loading: () => EasyLoading.show(status: 'Exporting data...'),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: "Your data has been exported successfully.",
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

        state.deleteStatus.whenOrNull(
          loading: () => EasyLoading.show(status: 'Deleting account...'),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: "Account deleted successfully.",
              type: SnackBarType.SUCCESS,
            );
            context.go(RoutePaths.welcome);
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
      builder: (BuildContext context, PrivacyDataState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.w,
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
                right: -150.w,
                bottom: 0,
                child: Container(
                  width: 400.w,
                  height: 400.w,
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
                bottom: true,
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
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          bottom: 80.h,
                        ),
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
                              borderRadius: BorderRadius.circular(16.r),
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
                                "Your data stays protected".appText(
                                  fontSize: 20.sp,
                                  color: greyColor9,
                                  fraunces: true,
                                  textAlign: TextAlign.start,
                                ),
                                8.spaceH,
                                "LovingBrain keeps ${state.childName}'s reflections, health notes, and family logs private and secure."
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
                            icon: Icon(
                              Icons.cloud_sync_outlined,
                              size: 24.sp,
                              color: const Color(0xFF665FCE),
                            ),
                            iconBackgroundColor: const Color(0xFFF3F2FE),
                            title: "Offline sync",
                            subtitle: state.isSyncing
                                ? "Syncing pending updates..."
                                : state.pendingOfflineUpdatesCount > 0
                                ? "${state.pendingOfflineUpdatesCount} updates waiting to sync"
                                : "All data is up to date",
                            trailing: state.isSyncing
                                ? SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : null,
                            onTap: () => _showOfflineSyncSheet(context),
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
                            subtitle: "Manage linked caregivers & permissions",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
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
                                MaterialPageRoute<void>(
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
                            onTap: () =>
                                context.read<PrivacyDataCubit>().exportData(),
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
    );
  }
}
