import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/setting_tile.dart';
import 'package:loving_brain/ui/widget/warning_box.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/help_safety_cubit.dart';
import 'bloc/help_safety_state.dart';

/// Screen 63: Help & Safety Screen.
/// Conforms to AGENTS.md §5.1, §6.1, and §6.4.
class HelpSafetyScreen extends StatefulWidget {
  const HelpSafetyScreen({super.key});

  @override
  State<HelpSafetyScreen> createState() => _HelpSafetyScreenState();
}

class _HelpSafetyScreenState extends State<HelpSafetyScreen> {
  late final HelpSafetyCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = HelpSafetyCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.init();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _launch(String urlString) async {
    final Uri? uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<HelpSafetyCubit, HelpSafetyState>(
        bloc: _cubit,
        listener: (BuildContext context, HelpSafetyState state) {},
        builder: (BuildContext context, HelpSafetyState state) {
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
                            "Help & safety".appText(
                              fontSize: 32.sp,
                              color: greyColor9,
                              fraunces: true,
                              textAlign: TextAlign.start,
                            ),
                            24.spaceH,
                            SettingTile(
                              icon: Image.asset(
                                Assets.v2.icons.icFaqs.path,
                                width: 24.sp,
                                height: 24.sp,
                              ),
                              iconBackgroundColor: const Color(0xFFE8F5E9),
                              title: "FAQs",
                              subtitle: "Sleep, tantrums, sharing and billing",
                              onTap: () => _launch(state.faqUrl),
                            ),
                            12.spaceH,
                            SettingTile(
                              icon: Image.asset(
                                Assets.v2.icons.icContactSupport.path,
                                width: 24.sp,
                                height: 24.sp,
                              ),
                              iconBackgroundColor: const Color(0xFFE3F2FD),
                              title: "Contact support",
                              subtitle: "Usually answered within a working day",
                              onTap: () => _launch(
                                "mailto:${state.supportEmail}?subject=LovingBrain Support Request",
                              ),
                            ),
                            12.spaceH,
                            SettingTile(
                              icon: Image.asset(
                                Assets.v2.icons.icMentorshipBooking.path,
                                width: 24.sp,
                                height: 24.sp,
                              ),
                              iconBackgroundColor: const Color(0xFFFFF3E0),
                              title: "Mentorship booking help",
                              subtitle: "Questions about guides and sessions",
                              onTap: () => _launch(
                                "mailto:${state.supportEmail}?subject=Mentorship Booking Help",
                              ),
                            ),
                            24.spaceH,
                            WarningBox(
                              label: "In an emergency",
                              title: "Contact your local emergency services",
                              body:
                                  "LovingBrain can't help in an emergency and isn't monitored.",
                            ),
                            24.spaceH,
                            InfoBox.white(
                              title: "Medical disclaimer",
                              iconData: Icons.info,
                              iconColor: const Color(0xFFE64A19),
                              body:
                                  "LovingBrain offers general guidance based on your own updates. It doesn't diagnose anything and doesn't replace professional medical advice.",
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
