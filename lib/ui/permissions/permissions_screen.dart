import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _sleepEnabled = true;
  bool _behaviourEnabled = true;
  bool _healthNotesEnabled = false;
  bool _plansEnabled = true;
  bool _mentorshipEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          // Top Left Glow
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
          // Bottom Right Glow
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
                      "What Grandma can see".appText(
                        fontSize: 32.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      8.spaceH,
                      "Change any of this at any time.".appText(
                        fontSize: 14.sp,
                        color: greyColor,
                        textAlign: TextAlign.start,
                      ),
                      24.spaceH,
                      _buildToggleCard(
                        title: "Sleep",
                        subtitle: "Naps, bedtimes and night waking",
                        value: _sleepEnabled,
                        onChanged: (val) => setState(() => _sleepEnabled = val),
                      ),
                      12.spaceH,
                      _buildToggleCard(
                        title: "Behaviour",
                        subtitle: "Tantrum updates and patterns",
                        value: _behaviourEnabled,
                        onChanged: (val) =>
                            setState(() => _behaviourEnabled = val),
                      ),
                      12.spaceH,
                      _buildToggleCard(
                        title: "Health notes",
                        subtitle: "Illness, teething and medication",
                        value: _healthNotesEnabled,
                        onChanged: (val) =>
                            setState(() => _healthNotesEnabled = val),
                      ),
                      12.spaceH,
                      _buildToggleCard(
                        title: "Plans",
                        subtitle: "Today's plan and what you're trying",
                        value: _plansEnabled,
                        onChanged: (val) => setState(() => _plansEnabled = val),
                      ),
                      12.spaceH,
                      _buildToggleCard(
                        title: "Mentorship summaries",
                        subtitle: "Notes from sessions with a guide",
                        value: _mentorshipEnabled,
                        onChanged: (val) =>
                            setState(() => _mentorshipEnabled = val),
                      ),
                      160.spaceH,
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
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.appText(
                  fontSize: 16.sp,
                  color: greyColor9,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
                4.spaceH,
                subtitle.appText(
                  fontSize: 14.sp,
                  color: greyColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          16.spaceW,
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF673AB7), // Purple
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Color(0xFFE6DDD5),
            trackOutlineColor: WidgetStatePropertyAll(Color(0xFFE6DDD5)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: 20.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: BoxDecoration(color: Color(0xffFEF2EA)),
        child: Column(
          children: [
            AppButton(
              title: "Save permissions",
              onTap: () {
                Navigator.pop(context);
              },
            ),
            16.spaceH,
            BaseButton(
              onTap: () {},
              child: "Remove Grandma's access".appText(
                fontSize: 16.sp,
                color: greyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
