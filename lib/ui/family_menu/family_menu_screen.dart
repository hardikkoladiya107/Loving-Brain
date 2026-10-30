import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/family_sharing_consent/family_sharing_consent_screen.dart';
import 'package:loving_brain/ui/invite_caregiver/invite_caregiver_screen.dart';
import 'package:loving_brain/ui/invite_pending/invite_pending_screen.dart';
import 'package:loving_brain/ui/permissions/permissions_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/person_card.dart';
import 'package:loving_brain/ui/widget/status_pill.dart';

import 'bloc/family_menu_cubit.dart';
import 'bloc/family_menu_state.dart';

/// Screen 54: Family Menu.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class FamilyMenuScreen extends StatefulWidget {
  const FamilyMenuScreen({super.key});

  @override
  State<FamilyMenuScreen> createState() => _FamilyMenuScreenState();
}

class _FamilyMenuScreenState extends State<FamilyMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FamilyMenuCubit>().init();
    });
  }

  String _buildCaregiverSubtitle(CaregiverItem c) {
    Map<String, dynamic>? saved = preferences.getCaregiverPermissions(c.email);
    if (saved == null && c.id.isNotEmpty) {
      saved = preferences.getCaregiverPermissions(c.id);
    }
    if (saved != null) {
      final CaregiverPermissionsModel p = CaregiverPermissionsModel.fromMap(
        saved,
      );
      final List<String> parts = <String>[];
      if (p.canViewSleep) parts.add('sleep');
      if (p.canViewBehaviour) parts.add('behaviour');
      if (p.canViewHealthNotes) parts.add('health');
      if (p.canViewPlans) parts.add('plans');
      if (p.canViewMentorSummaries) parts.add('mentorship');
      if (parts.isNotEmpty) {
        return "${c.role} · ${parts.join(', ')}";
      }
    }
    return "${c.role} · sleep, behaviour, plans";
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilyMenuCubit, FamilyMenuState>(
      listener: (BuildContext context, FamilyMenuState state) {
        state.leaveStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (dynamic _) {
            EasyLoading.dismiss();
            showSnackBar(
              message: "You have left the family profile",
              type: SnackBarType.SUCCESS,
            );
            Navigator.pop(context);
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, FamilyMenuState state) {
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
                        child: RefreshIndicator(
                          color: primaryColor,
                          onRefresh: () async {
                            await context.read<FamilyMenuCubit>().init();
                          },
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
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
                              "Everyone here sees the same picture of ${state.childName}."
                                  .appText(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                    textAlign: TextAlign.start,
                                  ),
                              24.spaceH,
                              ...state.linkedCaregivers.map((CaregiverItem c) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: PersonCard(
                                    avatar: Container(
                                      decoration: BoxDecoration(
                                        color: c.isOwner
                                            ? const Color(0xFF665FCE)
                                            : const Color(0xFFFDC21A),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        c.isOwner
                                            ? Icons.shield_rounded
                                            : Icons.face,
                                        size: 30.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    name: c.name,
                                    subtitle: c.isOwner
                                        ? "${c.role} · Profile Owner"
                                        : _buildCaregiverSubtitle(c),
                                    statusPill: c.isOwner
                                        ? const StatusPill(
                                            text: "Primary Parent",
                                            textColor: Color(0xFF665FCE),
                                            backgroundColor: Color(0xFFF3F2FE),
                                          )
                                        : StatusPill.linked(),
                                    showChevron: !c.isOwner,
                                    onTap: c.isOwner
                                        ? () {
                                            showPrimaryParentInfoDialog(
                                              context,
                                              c.name,
                                            );
                                          }
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    PermissionsScreen(
                                                      caregiverName: c.name,
                                                      caregiverRole: c.role,
                                                      caregiverId: c.id,
                                                      caregiverEmail: c.email,
                                                    ),
                                              ),
                                            ).then((_) {
                                              if (context.mounted) {
                                                context
                                                    .read<FamilyMenuCubit>()
                                                    .init();
                                              }
                                            });
                                          },
                                  ),
                                );
                              }),
                              ...state.pendingInvites.map((CaregiverItem c) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: PersonCard(
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
                                    name: c.name,
                                    subtitle:
                                        "${c.role} · ${c.daysRemaining} days left",
                                    statusPill: StatusPill.awaitingResponse(),
                                    showChevron: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => InvitePendingScreen(
                                            invitationId: c.id,
                                            recipientEmail: c.email.isNotEmpty
                                                ? c.email
                                                : c.name,
                                            role: c.role,
                                            childName: state.childName,
                                          ),
                                        ),
                                      ).then((_) {
                                        if (context.mounted) {
                                          context
                                              .read<FamilyMenuCubit>()
                                              .init();
                                        }
                                      });
                                    },
                                  ),
                                );
                              }),
                              24.spaceH,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const FamilySharingConsentScreen(),
                                    );
                                },
                                child: InfoBox.orange(
                                  title: "How sharing works",
                                  body:
                                      "You choose what each person sees, and can change it or remove access at any time.",
                                ),
                              ),
                              140.spaceH,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBottomActions(context, state),
              ],
            ),
          );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context, FamilyMenuState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
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
          child: state.isCurrentUserOwner
              ? AppButton(
                  title: "Invite a caregiver",
                  onTap: () {
                    final bool hasConsented =
                        preferences.getBool(
                          SharedPreference.isFamilyConsentGranted,
                        ) ??
                        false;
                    final Widget destination = hasConsented
                        ? const InviteCaregiverScreen()
                        : const FamilySharingConsentScreen();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => destination),
                    ).then((_) {
                      if (context.mounted) {
                        context.read<FamilyMenuCubit>().init();
                      }
                    });
                  },
                )
              : AppButton(
                  title: "Leave family",
                  backgroundColor: Colors.white,
                  borderColor: const Color(0xFFD84315),
                  textColor: const Color(0xFFD84315),
                  onTap: () {
                    _showLeaveConfirmationDialog(context, state);
                  },
                ),
        ),
      ),
    );
  }

  void _showLeaveConfirmationDialog(
    BuildContext context,
    FamilyMenuState state,
  ) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: const Color(0xFFD84315),
                    size: 26.sp,
                  ),
                ),
                16.spaceH,
                "Leave family?".appText(
                  fontSize: 20.sp,
                  color: greyColor9,
                  fraunces: true,
                ),
                8.spaceH,
                "Are you sure you want to leave ${state.childName}'s profile? You will no longer see or log updates for this child."
                    .appText(
                      fontSize: 14.sp,
                      color: greyColor,
                      textAlign: TextAlign.center,
                      height: 1.4,
                    ),
                20.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        height: 44.h,
                        padding: EdgeInsets.zero,
                        title: 'Cancel',
                        backgroundColor: const Color(0xFFF8F5F2),
                        borderColor: const Color(0xFFE9E2DC),
                        textColor: greyColor9,
                        onTap: () => Navigator.pop(dialogContext),
                      ),
                    ),
                    12.spaceW,
                    Expanded(
                      child: AppButton(
                        height: 44.h,
                        padding: EdgeInsets.zero,
                        title: 'Leave',
                        backgroundColor: const Color(0xFFD84315),
                        borderColor: const Color(0xFFD84315),
                        textColor: Colors.white,
                        onTap: () {
                          Navigator.pop(dialogContext);
                          context.read<FamilyMenuCubit>().leaveFamily();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
      },
    );
  }
}

void showPrimaryParentInfoDialog(BuildContext context, String parentName) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shield_rounded,
                    color: const Color(0xFF665FCE),
                    size: 26.sp,
                  ),
                ),
                16.spaceH,
                "Primary Parent".appText(
                  fontSize: 20.sp,
                  color: greyColor9,
                  fraunces: true,
                ),
                10.spaceH,
                "$parentName is the primary parent and creator of this profile. Their permissions cannot be modified."
                    .appText(
                      fontSize: 14.sp,
                      color: greyColor,
                      textAlign: TextAlign.center,
                      height: 1.4,
                    ),
                24.spaceH,
                AppButton(
                  height: 44.h,
                  padding: EdgeInsets.zero,
                  title: 'Got it',
                  backgroundColor: primaryColor,
                  borderColor: primaryColor,
                  textColor: Colors.white,
                  onTap: () => Navigator.pop(dialogContext),
                ),
              ],
            ),
          ),
        );
    },
  );
}
