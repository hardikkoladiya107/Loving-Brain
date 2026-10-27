import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/setting_tile.dart';
import 'package:loving_brain/ui/widget/warning_box.dart';
import 'package:loving_brain/ui/faq/faq_screen.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HelpSafetyCubit>().init();
    });
  }

  Future<void> _launch(String urlString, {String? copyFallbackText}) async {
    final Uri? uri = Uri.tryParse(urlString);
    bool launched = false;
    if (uri != null) {
      try {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        launched = false;
      }
    }
    if (!launched) {
      final String fallback = copyFallbackText ?? urlString;
      await Clipboard.setData(ClipboardData(text: fallback));
      showSnackBar(
        message: "Copied to clipboard: $fallback",
        type: SnackBarType.SUCCESS,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HelpSafetyCubit, HelpSafetyState>(
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
              Positioned.fill(
                child: SafeArea(
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
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 80.h),
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
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FaqScreen(),
                                ),
                              ),
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
                                copyFallbackText: state.supportEmail,
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
                                copyFallbackText: state.supportEmail,
                              ),
                            ),
                            24.spaceH,
                            WarningBox(
                              label: "In an emergency",
                              title: "Contact your local emergency services",
                              body:
                                  "LovingBrain can't help in an emergency and isn't monitored.",
                              action: InkWell(
                                onTap: () =>
                                    _launch("tel:${state.emergencyPhone}"),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD84315),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                        size: 18.sp,
                                      ),
                                      8.spaceW,
                                      "Call emergency services (${state.emergencyPhone})"
                                          .appText(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ],
                                  ),
                                ),
                              ),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
