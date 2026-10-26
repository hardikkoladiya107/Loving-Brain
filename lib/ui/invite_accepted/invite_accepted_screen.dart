import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/permissions/permissions_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/person_card.dart';
import 'package:loving_brain/ui/widget/status_pill.dart';

import 'bloc/invite_accepted_cubit.dart';
import 'bloc/invite_accepted_state.dart';

/// Screen 57: Invite Accepted.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class InviteAcceptedScreen extends StatefulWidget {
  final String? caregiverName;
  final String? caregiverRole;

  const InviteAcceptedScreen({
    super.key,
    this.caregiverName,
    this.caregiverRole,
  });

  @override
  State<InviteAcceptedScreen> createState() => _InviteAcceptedScreenState();
}

class _InviteAcceptedScreenState extends State<InviteAcceptedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InviteAcceptedCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.caregiverName ?? "Grandma";
    final String role = widget.caregiverRole ?? "Grandparent";

    return BlocConsumer<InviteAcceptedCubit, InviteAcceptedState>(
      listener: (BuildContext context, InviteAcceptedState state) {},
      builder: (BuildContext context, InviteAcceptedState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top Left Glow
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.h,
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
                right: -150.w,
                bottom: 0,
                child: Container(
                  width: 400.w,
                  height: 400.h,
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
                          "Invite status".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          24.spaceH,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatusPill.accepted(),
                                16.spaceH,
                                "$name has joined".appText(
                                  fontSize: 20.sp,
                                  color: greyColor9,
                                  fraunces: true,
                                ),
                                8.spaceH,
                                "They can now see what you've shared sleep updates and today's plan."
                                    .appText(
                                      fontSize: 14.sp,
                                      color: greyColor,
                                      textAlign: TextAlign.start,
                                    ),
                              ],
                            ),
                          ),
                          12.spaceH,
                          PersonCard(
                            avatar: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDC21A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.face,
                                size: 30.sp,
                                color: Colors.white,
                              ),
                            ),
                            name: name,
                            subtitle: "$role · joined today",
                            statusPill: StatusPill.linked(),
                            showChevron: false,
                          ),
                          12.spaceH,
                          InfoBox.white(
                            title: "Worth checking",
                            body:
                                "Have a look at what they can see. You can adjust it now or any time later.",
                          ),
                          180.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomActions(context, name, role),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context, String name, String role) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 32.h,
          bottom: 32.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFEF8F4).withValues(alpha: 0.0),
              const Color(0xFFFEF8F4),
              const Color(0xFFFEF8F4),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Column(
          children: [
            AppButton(
              title: "Manage permissions",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PermissionsScreen(
                      caregiverName: name,
                      caregiverRole: role,
                    ),
                  ),
                );
              },
            ),
            16.spaceH,
            BaseButton(
              onTap: () {
                Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
              },
              child: "Back to Family".appText(
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
