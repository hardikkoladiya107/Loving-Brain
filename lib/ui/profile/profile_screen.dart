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
          backgroundColor: const Color(0xFFF6F8FA),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(state.userModel),
                    24.h.spaceH,
                    
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
                    60.h.spaceH,
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            20.h.spaceH,
            _profileImageWidget(userModel),
            16.h.spaceH,
            (userModel?.parentName ?? "Profile").appText(
              color: Colors.black87,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
            4.h.spaceH,
            (userModel?.email ?? "").appText(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            30.h.spaceH,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 28.w, bottom: 8.h, top: 8.h),
      child: title.appText(
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _buildGroup(List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.06))),
          ),
          child: Row(
             children: [
              Container(
                height: 42.w,
                width: 42.w,
                decoration: BoxDecoration(
                  color: iconBgColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: assetIcon != null
                      ? assetIcon.image(height: 20.w, width: 20.w, color: iconBgColor)
                      : Icon(icon, color: iconBgColor, size: 22.w),
                ),
              ),
              16.spaceW,
              Expanded(
                child: title.appText(
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              if (showCheckBox)
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: check,
                    onChanged: onChanged,
                    activeThumbColor: primaryColor,
                    activeTrackColor: primaryColor.withOpacity(0.3),
                  ),
                )
              else
                Icon(LucideIcons.chevronRight, color: Colors.grey.withOpacity(0.4), size: 20.w),
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
          insetPadding: EdgeInsets.only(left: 20.w, right: 20.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.logOut, color: Colors.redAccent, size: 32.w),
                ),
                20.h.spaceH,
                "${LocaleKeys.logOut.tr()}?".appText(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                12.h.spaceH,
                LocaleKeys.areYouSureYouWantToLogout.tr().appText(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  textAlign: TextAlign.center,
                ),
                32.h.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              )
                              .appPadding(top: 14.h, bottom: 14.h),
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
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          ),
                          child: LocaleKeys.logOut
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 14.h, bottom: 14.h),
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
          insetPadding: EdgeInsets.only(left: 20.w, right: 20.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.trash2, color: Colors.redAccent, size: 32.w),
                ),
                20.h.spaceH,
                "${LocaleKeys.deleteAccount.tr()}?".appText(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                12.h.spaceH,
                LocaleKeys.areYouSureYouWantToDeleteAccount.tr().appText(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  textAlign: TextAlign.center,
                ),
                32.h.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              )
                              .appPadding(top: 14.h, bottom: 14.h),
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
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          ),
                          child: LocaleKeys.delete
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 14.h, bottom: 14.h),
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
            gradient: const LinearGradient(
              colors: [primaryColor, Color(0xFFFF66C4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.camera,
                color: primaryColor,
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
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              12.spaceH,
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              20.spaceH,
              "Update Profile Picture".appText(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              16.spaceH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      child: Column(
        children: [
          Container(
            height: 60.w,
            width: 60.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28.w),
          ),
          8.spaceH,
          title.appText(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ],
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
        height: 100.r,
        width: 100.r,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(LucideIcons.user, size: 40.r, color: Colors.grey.shade400),
      );
    }
    return AppImage(
      imageUrl: userModel!.profileImage!,
      height: 100.r,
      width: 100.r,
      shape: BoxShape.circle,
    );
  }
}
