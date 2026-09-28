import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/invite_caregiver/invite_caregiver_screen.dart';
import 'package:loving_brain/ui/invite_pending/invite_pending_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/person_card.dart';
import 'package:loving_brain/ui/widget/status_pill.dart';

import 'bloc/family_menu_cubit.dart';
import 'bloc/family_menu_state.dart';

class FamilyMenuScreen extends StatelessWidget {
  const FamilyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FamilyMenuCubit()..init(),
      child: BlocBuilder<FamilyMenuCubit, FamilyMenuState>(
        builder: (context, state) {
          final childName = context.read<FamilyMenuCubit>().childName;
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
                            "Family".appText(
                              fontSize: 32.sp,
                              color: greyColor9,
                              fraunces: true,
                              textAlign: TextAlign.start,
                            ),
                            8.spaceH,
                            "Everyone here sees the same picture of $childName."
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor,
                                  textAlign: TextAlign.start,
                                ),
                            24.spaceH,
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
                              name: "Ravi",
                              subtitle: "Partner · sleep, behaviour, plans",
                              statusPill: StatusPill.linked(),
                              showChevron: true,
                              onTap: () {},
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
                              name: "Grandma",
                              subtitle: "Invite sent 2 days ago",
                              statusPill: StatusPill.awaitingResponse(),
                              showChevron: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const InvitePendingScreen(),
                                  ),
                                );
                              },
                            ),
                            24.spaceH,
                            InfoBox.orange(
                              title: "How sharing works",
                              body:
                                  "You choose what each person sees, and can change it or remove access at any time.",
                            ),
                            120.spaceH,
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
        },
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
          top: 40.h,
          bottom: 40.h,
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
        child: AppButton(
          title: "Invite a caregiver",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InviteCaregiverScreen()),
            );
          },
        ),
      ),
    );
  }
}
