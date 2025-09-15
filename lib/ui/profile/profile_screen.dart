import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/profile/bloc/profile_cubit.dart';
import 'package:loving_brain/ui/profile/bloc/profile_state.dart';
import 'package:loving_brain/ui/subscription/subscription_screen.dart';
import 'package:loving_brain/ui/widget/app_image.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                        AppImage(
                          imageUrl: 'https://picsum.photos/200/300',
                          height: 100.h,
                          width: 100.h,
                          shape: BoxShape.circle,
                        ),
                        "Sarah".appText(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                        "hello@sarah.com".appText(),
                      ],
                    ),
                  ],
                ),
                10.spaceH,
                _settingItem(
                  title: LocaleKeys.getGentleRemindersForPlay.tr(),
                  showCheckBox: true,
                  icon: Assets.icons.icReminderIcon2,
                  iconColor: gentleReminderIconColor,
                ),
                10.spaceH,
                LocaleKeys.quickReminders
                    .tr()
                    .appText(fontWeight: FontWeight.w800)
                    .appPadding(left: 20.w),
                10.spaceH,
                _settingItem(
                  title: LocaleKeys.dailyEmotionCheckIn.tr(),
                  description: LocaleKeys.darkLight.tr(),
                  icon: Assets.icons.icDailyEmotionCheckIcon,
                  iconColor: dailyEmotionCheckIconColor,
                  showCheckBox: true,
                  check: state.dailyEmotionCheck,
                  onChanged: (value) {
                    context.read<ProfileCubit>().changeProps(
                      dailyEmotionCheck: value,
                    );
                  },
                ),
                _settingItem(
                  title: LocaleKeys.todayPlayIdea.tr(),
                  showCheckBox: true,
                  icon: Assets.icons.icTodaysPlayIdeaIcon,
                  iconColor: todayPlayIdeaIconColor,
                  check: state.todaysPlayIdea,
                  onChanged: (value) {
                    context.read<ProfileCubit>().changeProps(
                      todaysPlayIdea: value,
                    );
                  },
                ),
                _settingItem(
                  title: LocaleKeys.scheduleReminders.tr(),
                  description: LocaleKeys.eventsFromCoParentingCalendar.tr(),
                  showCheckBox: true,
                  icon: Assets.icons.icScheduleReminderIcon,
                  iconColor: scheduleReminderIconColor,
                  check: state.scheduleReminder,
                  onChanged: (value) {
                    context.read<ProfileCubit>().changeProps(
                      scheduleReminder: value,
                    );
                  },
                ),
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
                  title: LocaleKeys.termsConditions.tr(),
                  icon: Assets.icons.icTermsAndConditionIcon,
                  iconColor: termsAndConditionIconColor,
                ),
                _settingItem(
                  title: LocaleKeys.privacyPolicy.tr(),
                  icon: Assets.icons.icPrivacyPolicyIcon,
                  iconColor: privacyPolicyIconColor,
                ),
                _settingItem(
                  title: LocaleKeys.rateThisApp.tr(),
                  icon: Assets.icons.icRateThisAppIcon,
                  iconColor: rateThisAppIconColor,
                ),
                _settingItem(
                  title: LocaleKeys.shareThisApp.tr(),
                  icon: Assets.icons.icShareThisAppIcon,
                  iconColor: shareThisAppIconColor,
                ),
                _settingItem(
                  title: LocaleKeys.deleteAccount.tr(),
                  icon: null,
                  icon2: Icons.delete,
                  iconColor: blueColor,
                  onTap: () {},
                ),
                _settingItem(
                  title: LocaleKeys.logOut.tr(),
                  icon: null,
                  icon2: Icons.logout,
                  iconColor: logoutAppIconColor,
                  onTap: () {},
                ),
                100.spaceH,
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
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
}
