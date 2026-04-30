import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:loving_brain/main.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_image.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/profile/bloc/profile_cubit.dart';
import 'package:loving_brain/ui/profile/bloc/profile_state.dart';
import 'package:loving_brain/ui/widget/app_dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/router/route_paths.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/preferances.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFFFAFAFA),
          body: Stack(
            children: [
              // AURORA BLOBS BACKGROUND
              Positioned(
                top: -100.h,
                left: -50.w,
                child: Container(
                  width: 350.w,
                  height: 350.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF894BCD).withValues(alpha: 0.18),
                  ),
                ),
              ),
              Positioned(
                top: 150.h,
                right: -100.w,
                child: Container(
                  width: 300.w,
                  height: 300.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF66C4).withValues(alpha: 0.12),
                  ),
                ),
              ),
              Positioned(
                bottom: -50.h,
                left: -80.w,
                child: Container(
                  width: 400.w,
                  height: 400.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF5271FF).withValues(alpha: 0.10),
                  ),
                ),
              ),
              
              // GLASS EFFECT OVERLAY
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ),

              // SCROLLABLE CONTENT
              Positioned.fill(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SafeArea(
                        bottom: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            20.h.spaceH,
                            _buildHeader(state.userModel),
                            8.h.spaceH,
                            
                            _buildSectionTitle("General Preferences"),
                            _buildGroup([
                              _settingItem(
                                title: LocaleKeys.getGentleRemindersForPlay.tr(),
                                showCheckBox: true,
                                icon: LucideIcons.bell,
                                iconBgColor: gentleReminderIconColor,
                                check: state.userModel?.isNotification ?? false,
                                onChanged: (value) {
                                  context.read<ProfileCubit>().updateNotification();
                                },
                                isLast: false,
                              ),
                              _settingItem(
                                title: LocaleKeys.children.tr(),
                                icon: LucideIcons.baby,
                                iconBgColor: primaryColor,
                                onTap: () {
                                  context.push(RoutePaths.manageChildren);
                                },
                                isLast: true,
                              ),
                            ]),

                            _buildSectionTitle("Account & Plan"),
                            _buildGroup([
                              _settingItem(
                                title: LocaleKeys.subscription.tr(),
                                icon: LucideIcons.crown,
                                iconBgColor: const Color(0xFFE5B02B),
                                onTap: () {
                                  context.push(RoutePaths.subscription);
                                },
                                isLast: false,
                              ),
                              _settingItem(
                                title: LocaleKeys.termsConditions.tr(),
                                icon: LucideIcons.fileText,
                                iconBgColor: termsAndConditionIconColor,
                                onTap: () {
                                  context.push(RoutePaths.terms);
                                },
                                isLast: false,
                              ),
                              _settingItem(
                                title: LocaleKeys.privacyPolicy.tr(),
                                icon: LucideIcons.shieldCheck,
                                iconBgColor: privacyPolicyIconColor,
                                onTap: () {
                                  context.push(RoutePaths.privacy);
                                },
                                isLast: true,
                              ),
                            ]),

                            _buildSectionTitle("About Loving Brain"),
                            _buildGroup([
                              _settingItem(
                                title: LocaleKeys.rateThisApp.tr(),
                                icon: LucideIcons.star,
                                iconBgColor: rateThisAppIconColor,
                                onTap: () {
                                  context.read<ProfileCubit>().rateApp();
                                },
                                isLast: false,
                              ),
                              _settingItem(
                                title: LocaleKeys.shareThisApp.tr(),
                                icon: LucideIcons.share2,
                                iconBgColor: shareThisAppIconColor,
                                onTap: () {
                                  context.read<ProfileCubit>().shareApp();
                                },
                                isLast: true,
                              ),
                            ]),

                            _buildSectionTitle("Danger Zone"),
                            _buildGroup([
                              _settingItem(
                                title: LocaleKeys.deleteAccount.tr(),
                                icon: LucideIcons.trash2,
                                iconBgColor: Colors.redAccent,
                                titleColor: Colors.redAccent,
                                onTap: () {
                                  _deleteAccountDialog();
                                },
                                isLast: false,
                              ),
                              _settingItem(
                                title: LocaleKeys.logOut.tr(),
                                icon: LucideIcons.logOut,
                                iconBgColor: logoutAppIconColor,
                                titleColor: logoutAppIconColor,
                                onTap: () {
                                  _logoutDialog();
                                },
                                isLast: true,
                              ),
                            ]),
                            120.h.spaceH,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      listener: (context, state) {
        state.logoutApiResultStatus.whenOrNull(
          initial: () {},
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
            _performLogout();
          },
          error: (error) {
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
            EasyLoading.dismiss();
          },
        );

        state.deleteAccountApiResultStatus.whenOrNull(
          initial: () {},
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
            _performLogout();
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );

        state.uploadFileApiResultStatus.whenOrNull(
          data: (data) {
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
        );
      },
    );
  }

  Widget _buildHeader(UserModel? userModel) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(scale: 0.75, child: _profileImageWidget(userModel)),
          12.h.spaceH,
          (userModel?.parentName ?? "Loving Brain Parent").appText(
            color: Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 0.5,
            textAlign: TextAlign.center,
          ),
          2.h.spaceH,
          (userModel?.email ?? "").appText(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 13,
            textAlign: TextAlign.center,
          ),
          if (userModel != null && userModel.displayStreak > 0)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.flame, color: const Color(0xFFFF9561), size: 16.w),
                    4.spaceW,
                    "${userModel.displayStreak} Day Streak!".appText(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ),
          12.h.spaceH,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, bottom: 4.h, top: 8.h),
      child: title.toUpperCase().appText(
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w800,
        fontSize: 10,
        letterSpacing: 1.5,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _buildGroup(List<Widget> children) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget _settingItem({
    required String title,
    IconData? icon,
    AssetGenImage? assetIcon,
    required Color iconBgColor,
    bool showCheckBox = false,
    bool check = false,
    ValueChanged<bool>? onChanged,
    GestureTapCallback? onTap,
    bool isLast = false,
    Color titleColor = Colors.black87,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: isLast ? null : Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.04))),
          ),
          child: Row(
             children: [
              Container(
                height: 36.w,
                width: 36.w,
                decoration: BoxDecoration(
                  color: iconBgColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: assetIcon != null
                      ? assetIcon.image(height: 18.w, width: 18.w, color: iconBgColor)
                      : Icon(icon, color: iconBgColor, size: 18.w),
                ),
              ),
              14.spaceW,
              Expanded(
                child: title.appText(
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: titleColor,
                ),
              ),
              if (showCheckBox)
                Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    value: check,
                    onChanged: onChanged,
                    activeThumbColor: Colors.white,
                    activeTrackColor: primaryColor,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade300,
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                )
              else
                Icon(LucideIcons.chevronRight, color: Colors.grey.withValues(alpha: 0.4), size: 16.w),
            ],
          ),
        ),
      ),
    );
  }

  void _logoutDialog() {
    showAppDialog(
      child: (context) {
        return Dialog(
          insetPadding: EdgeInsets.only(left: 24.w, right: 24.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(LucideIcons.logOut, color: Colors.redAccent, size: 40.w),
                    ),
                    28.h.spaceH,
                    "${LocaleKeys.logOut.tr()}?".appText(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                    12.h.spaceH,
                    LocaleKeys.areYouSureYouWantToLogout.tr().appText(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      textAlign: TextAlign.center,
                    ),
                    40.h.spaceH,
                    Row(
                      children: [
                        Expanded(
                          child: BaseButton(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                              ),
                              child: LocaleKeys.cancel
                                  .tr()
                                  .appText(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                    fontSize: 16,
                                  )
                                  .appPadding(top: 18.h, bottom: 18.h),
                            ),
                            onTap: () {
                              context.pop();
                            },
                          ),
                        ),
                        16.w.spaceW,
                        Expanded(
                          child: BaseButton(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              ),
                              child: LocaleKeys.logOut
                                  .tr()
                                  .appText(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 16,
                                  )
                                  .appPadding(top: 18.h, bottom: 18.h),
                            ),
                            onTap: () {
                              context.read<ProfileCubit>().logout();
                              context.pop();
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
      },
    );
  }

  void _deleteAccountDialog() {
    showAppDialog(
      child: (context) {
        return Dialog(
          insetPadding: EdgeInsets.only(left: 24.w, right: 24.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(LucideIcons.trash2, color: Colors.redAccent, size: 40.w),
                    ),
                    28.h.spaceH,
                    "${LocaleKeys.deleteAccount.tr()}?".appText(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                    12.h.spaceH,
                    LocaleKeys.areYouSureYouWantToDeleteAccount.tr().appText(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      textAlign: TextAlign.center,
                    ),
                    40.h.spaceH,
                    Row(
                      children: [
                        Expanded(
                          child: BaseButton(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                              ),
                              child: LocaleKeys.cancel
                                  .tr()
                                  .appText(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                    fontSize: 16,
                                  )
                                  .appPadding(top: 18.h, bottom: 18.h),
                            ),
                            onTap: () {
                              context.pop();
                            },
                          ),
                        ),
                        16.w.spaceW,
                        Expanded(
                          child: BaseButton(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              ),
                              child: LocaleKeys.delete
                                  .tr()
                                  .appText(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 16,
                                  )
                                  .appPadding(top: 18.h, bottom: 18.h),
                            ),
                            onTap: () {
                              context.read<ProfileCubit>().deleteAccount();
                              context.pop();
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
      },
    );
  }

  Future<void> _performLogout() async {
    if (navigatorKey.currentContext != null) {
      await preferences.putBool(SharedPreference.isLogin, false);
      await preferences.clearUser();
      navigatorKey.currentContext!.go(RoutePaths.welcome);
    }
  }

  @override
  void dispose() {
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<ProfileCubit>().dispose();
    }
    super.dispose();
  }

  Widget _profileImageWidget(UserModel? userModel) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.6),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _profileImage(userModel),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: BaseButton(
            onTap: () {
              _showImagePickerDropdown();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade100, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.camera,
                color: primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePickerDropdown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 40, top: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                border: Border(top: BorderSide(color: Colors.white, width: 1.5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 6,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  30.spaceH,
                  "Update Profile Picture".appText(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                  40.spaceH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       _buildPickerOption(
                        title: LocaleKeys.pickFromCamera.tr(),
                        icon: LucideIcons.camera,
                        color: primaryColor,
                        onTap: () {
                          context.pop();
                          _chooseImage(ImageSource.camera);
                        },
                      ),
                      24.w.spaceW,
                      _buildPickerOption(
                        title: LocaleKeys.pickGallery.tr(),
                        icon: LucideIcons.image,
                        color: const Color(0xFFFF66C4),
                        onTap: () {
                          context.pop();
                          _chooseImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        width: 140.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 28.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ]
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 44.w),
            20.spaceH,
            title.appText(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseImage(ImageSource camera) async {
    final XFile? photo = await ImagePicker().pickImage(source: camera);
    if (photo != null && navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<ProfileCubit>().selectImage(photo.path);
    }
  }

  Widget _profileImage(UserModel? userModel) {
    if ((userModel?.profileImage ?? "").isEmpty) {
      return Container(
        height: 120.r,
        width: 120.r,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(LucideIcons.user, size: 50.r, color: Colors.grey.shade400),
      );
    }
    return AppImage(
      imageUrl: userModel!.profileImage!,
      height: 120.r,
      width: 120.r,
      shape: BoxShape.circle,
    );
  }
}
