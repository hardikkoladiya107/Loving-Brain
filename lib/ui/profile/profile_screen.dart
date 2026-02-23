import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/ui/on_boarding/on_boarding_screen1.dart';
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
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                50.spaceH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        _profileImageWidget(state.userModel),
                        10.h.spaceH,
                        (state.userModel?.parentName ?? "").appText(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                        5.h.spaceH,
                        (state.userModel?.email ?? "").appText(),
                      ],
                    ),
                  ],
                ),
                10.h.spaceH,
                _settingItem(
                  title: LocaleKeys.getGentleRemindersForPlay.tr(),
                  showCheckBox: true,
                  icon: Assets.icons.icReminderIcon2,
                  iconColor: gentleReminderIconColor,
                  check: state.userModel?.getReminderNotification ?? false,
                  onChanged: (value) {
                    context.read<ProfileCubit>().updateGentleReminder();
                  },
                ),
                10.spaceH,
                LocaleKeys.quickReminders
                    .tr()
                    .appText(fontWeight: FontWeight.w800)
                    .appPadding(left: 20.w),
                10.spaceH,

                _settingItem(
                  title: LocaleKeys.subscription.tr(),
                  icon: Assets.icons.icCrownIcon,
                  iconColor: termsAndConditionIconColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionScreen(),
                      ),
                    );
                  },
                ),
                _settingItem(
                  title: LocaleKeys.children.tr(),
                  icon: null,
                  icon2: Icons.child_care,
                  iconColor: primaryColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ManageChildrenScreen(),
                      ),
                    );
                  },
                ),
                _settingItem(
                  title: LocaleKeys.termsConditions.tr(),
                  icon: Assets.icons.icTermsAndConditionIcon,
                  iconColor: termsAndConditionIconColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TermsAndConditionsScreen(),
                      ),
                    );
                  },
                ),
                _settingItem(
                  title: LocaleKeys.privacyPolicy.tr(),
                  icon: Assets.icons.icPrivacyPolicyIcon,
                  iconColor: privacyPolicyIconColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
                _settingItem(
                  title: LocaleKeys.rateThisApp.tr(),
                  icon: Assets.icons.icRateThisAppIcon,
                  iconColor: rateThisAppIconColor,
                  onTap: () {
                    context.read<ProfileCubit>().rateApp();
                  },
                ),
                _settingItem(
                  title: LocaleKeys.shareThisApp.tr(),
                  icon: Assets.icons.icShareThisAppIcon,
                  iconColor: shareThisAppIconColor,
                  onTap: () {
                    context.read<ProfileCubit>().shareApp();
                  },
                ),
                _settingItem(
                  title: LocaleKeys.deleteAccount.tr(),
                  icon: null,
                  icon2: Icons.delete,
                  iconColor: blueColor,
                  onTap: () {
                    _deleteAccountDialog();
                  },
                ),
                _settingItem(
                  title: LocaleKeys.logOut.tr(),
                  icon: null,
                  icon2: Icons.logout,
                  iconColor: logoutAppIconColor,
                  onTap: () {
                    _logoutDialog();
                  },
                ),
                100.spaceH,
              ],
            ),
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

  Widget _settingItem({
    required String title,
    required AssetGenImage? icon,

    required Color iconColor,
    IconData? icon2,
    String? description,
    bool showCheckBox = false,
    bool check = false,
    ValueChanged<bool>? onChanged,
    GestureTapCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            height: 45,
            width: 45,
            child: Center(
              child: (icon != null)
                  ? icon.image(height: 25, width: 25)
                  : (icon2 != null)
                  ? Icon(icon2, color: Colors.white)
                  : Container(),
            ),
          ),

          10.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.appText(
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                if (description != null)
                  (description ?? "").appText(
                    textAlign: TextAlign.start,
                    fontSize: 12,
                  ),
              ],
            ),
          ),
          if (showCheckBox)
            Transform.scale(
              scale: 0.7,
              child: Switch(value: check, onChanged: onChanged),
            ),
        ],
      ),
    ).appPadding(left: 20.w, right: 20.w, top: 10.h);
  }

  void _logoutDialog() {
    showAppDialog(
      child: (context) {
        return Dialog(
          insetPadding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                20.h.spaceH,
                "${LocaleKeys.logOut.tr()}?".appText(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                20.h.spaceH,
                LocaleKeys.areYouSureYouWantToLogout.tr().appText(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                40.h.spaceH,
                Row(
                  children: [
                    20.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 10.h, bottom: 10.h),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    10.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LocaleKeys.logOut
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 10.h, bottom: 10.h),
                        ),
                        onTap: () {
                          context.read<ProfileCubit>().logout();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    20.w.spaceW,
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
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                20.h.spaceH,
                "${LocaleKeys.deleteAccount.tr()}?".appText(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                20.h.spaceH,
                LocaleKeys.areYouSureYouWantToDeleteAccount.tr().appText(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                30.h.spaceH,
                Row(
                  children: [
                    20.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 10.h, bottom: 10.h),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    10.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LocaleKeys.delete
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 10.h, bottom: 10.h),
                        ),
                        onTap: () {
                          context.read<ProfileCubit>().deleteAccount();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    20.w.spaceW,
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
        MaterialPageRoute(builder: (context) => const OnBoardingScreen1()),
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
      children: [
        _profileImage(userModel),
        Positioned(
          bottom: 0,
          right: 0,
          child: BaseButton(
            onTap: () {
              _showImagePickerDropdown();
            },
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 14,
              ).appPadding(all: 10),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaseButton(
              child: Row(
                children: [
                  12.spaceW,
                  Icon(Icons.camera_alt_outlined),
                  12.spaceW,
                  LocaleKeys.pickFromCamera.tr().appText(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ).appPadding(top: 12, bottom: 12),
              onTap: () async {
                Navigator.of(context).pop();
                _chooseImage(ImageSource.camera);
              },
            ),
            BaseButton(
              child: Row(
                children: [
                  12.spaceW,
                  Icon(Icons.photo_size_select_actual_outlined),
                  12.spaceW,
                  LocaleKeys.pickGallery.tr().appText(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ).appPadding(top: 12, bottom: 12),
              onTap: () async {
                Navigator.of(context).pop();
                _chooseImage(ImageSource.gallery);
              },
            ),
            20.spaceH,
          ],
        );
      },
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
          color: Colors.grey.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person, size: 30.r),
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
