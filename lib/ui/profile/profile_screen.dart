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
import 'package:loving_brain/ui/auth/on_boarding/welcome_screen.dart';
import 'package:loving_brain/ui/manage_children/manage_children_screen.dart';
import 'package:loving_brain/ui/privacy_policy/privacy_policy_screen.dart';
import 'package:loving_brain/ui/profile/bloc/profile_cubit.dart';
import 'package:loving_brain/ui/profile/bloc/profile_state.dart';
import 'package:loving_brain/ui/subscription/subscription_screen.dart';
import 'package:loving_brain/ui/terms_and_conditions/terms_and_conditions.dart';
import 'package:loving_brain/ui/widget/app_dialogs.dart';
import 'package:loving_brain/ui/widget/app_image.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

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
          backgroundColor: const Color(0xFFF4F6F9),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(state.userModel),
              ),
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0.0, -32.0, 0.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F6F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.h.spaceH,
                      _buildSectionTitle("General Preferences"),
                      _buildGroup([
                        _settingItem(
                          title: LocaleKeys.getGentleRemindersForPlay.tr(),
                          showCheckBox: true,
                          icon: LucideIcons.bell,
                          iconBgColor: gentleReminderIconColor,
                          check: state.userModel?.getReminderNotification ?? false,
                          onChanged: (value) {
                            context.read<ProfileCubit>().updateGentleReminder();
                          },
                          isLast: false,
                        ),
                        _settingItem(
                          title: LocaleKeys.children.tr(),
                          icon: LucideIcons.baby,
                          iconBgColor: primaryColor,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ManageChildrenScreen(),
                              ),
                            );
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SubscriptionScreen(),
                              ),
                            );
                          },
                          isLast: false,
                        ),
                        _settingItem(
                          title: LocaleKeys.termsConditions.tr(),
                          icon: LucideIcons.fileText,
                          iconBgColor: termsAndConditionIconColor,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const TermsAndConditionsScreen(),
                              ),
                            );
                          },
                          isLast: false,
                        ),
                        _settingItem(
                          title: LocaleKeys.privacyPolicy.tr(),
                          icon: LucideIcons.shieldCheck,
                          iconBgColor: privacyPolicyIconColor,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicyScreen(),
                              ),
                            );
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
                      100.h.spaceH,
                    ],
                  ),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 74.h, top: 40.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, Color(0xFF9D65E8), Color(0xFF894BCD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _profileImageWidget(userModel),
            20.h.spaceH,
            (userModel?.parentName ?? "Loving Brain Parent").appText(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 26,
              letterSpacing: 0.5,
            ),
            6.h.spaceH,
            (userModel?.email ?? "").appText(
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            if (userModel != null && userModel.displayStreak > 0)
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.flame, color: const Color(0xFFFFD700), size: 18.w),
                      8.spaceW,
                      "${userModel.displayStreak} Day Streak!".appText(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 36.w, bottom: 10.h, top: 12.h),
      child: title.toUpperCase().appText(
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w800,
        fontSize: 12,
        letterSpacing: 1.2,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _buildGroup(List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF894BCD).withValues(alpha: 0.06),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: children,
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
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.08))),
          ),
          child: Row(
             children: [
              Container(
                height: 48.w,
                width: 48.w,
                decoration: BoxDecoration(
                  color: iconBgColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: assetIcon != null
                      ? assetIcon.image(height: 24.w, width: 24.w, color: iconBgColor)
                      : Icon(icon, color: iconBgColor, size: 24.w),
                ),
              ),
              18.spaceW,
              Expanded(
                child: title.appText(
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: titleColor,
                ),
              ),
              if (showCheckBox)
                Transform.scale(
                  scale: 0.9,
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
                Icon(LucideIcons.chevronRight, color: Colors.grey.withValues(alpha: 0.4), size: 20.w),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.logOut, color: Colors.redAccent, size: 36.w),
                ),
                24.h.spaceH,
                "${LocaleKeys.logOut.tr()}?".appText(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
                12.h.spaceH,
                LocaleKeys.areYouSureYouWantToLogout.tr().appText(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  textAlign: TextAlign.center,
                ),
                36.h.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontSize: 16,
                              )
                              .appPadding(top: 16.h, bottom: 16.h),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    12.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          ),
                          child: LocaleKeys.logOut
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16,
                              )
                              .appPadding(top: 16.h, bottom: 16.h),
                        ),
                        onTap: () {
                          context.read<ProfileCubit>().logout();
                          Navigator.pop(context);
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

  void _deleteAccountDialog() {
    showAppDialog(
      child: (context) {
        return Dialog(
          insetPadding: EdgeInsets.only(left: 24.w, right: 24.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.trash2, color: Colors.redAccent, size: 36.w),
                ),
                24.h.spaceH,
                "${LocaleKeys.deleteAccount.tr()}?".appText(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
                12.h.spaceH,
                LocaleKeys.areYouSureYouWantToDeleteAccount.tr().appText(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  textAlign: TextAlign.center,
                ),
                36.h.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontSize: 16,
                              )
                              .appPadding(top: 16.h, bottom: 16.h),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    12.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          ),
                          child: LocaleKeys.delete
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16,
                              )
                              .appPadding(top: 16.h, bottom: 16.h),
                        ),
                        onTap: () {
                          context.read<ProfileCubit>().deleteAccount();
                          Navigator.pop(context);
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

  Future<void> _performLogout() async {
    if (navigatorKey.currentContext != null) {
      await preferences.putBool(SharedPreference.isLogin, false);
      await preferences.clearUser();
      Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (Route<dynamic> route) => false, // remove all previous routes
      );
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
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.25),
          ),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: _profileImage(userModel),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: BaseButton(
            onTap: () {
              _showImagePickerDropdown();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.camera,
                color: Colors.white,
                size: 16,
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
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 30, top: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              24.spaceH,
              "Update Profile Picture".appText(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
              30.spaceH,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   _buildPickerOption(
                    title: LocaleKeys.pickFromCamera.tr(),
                    icon: LucideIcons.camera,
                    color: primaryColor,
                    onTap: () {
                      Navigator.of(context).pop();
                      _chooseImage(ImageSource.camera);
                    },
                  ),
                  20.w.spaceW,
                  _buildPickerOption(
                    title: LocaleKeys.pickGallery.tr(),
                    icon: LucideIcons.image,
                    color: const Color(0xFFFF66C4),
                    onTap: () {
                      Navigator.of(context).pop();
                      _chooseImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
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
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40.w),
            16.spaceH,
            title.appText(
              fontSize: 16,
              fontWeight: FontWeight.w700,
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
        height: 110.r,
        width: 110.r,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(LucideIcons.user, size: 50.r, color: Colors.grey.shade400),
      );
    }
    return AppImage(
      imageUrl: userModel!.profileImage!,
      height: 110.r,
      width: 110.r,
      shape: BoxShape.circle,
    );
  }
}
