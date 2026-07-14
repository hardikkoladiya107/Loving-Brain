import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../widget/base_button.dart';
import 'bloc/link_co_parent_cubit.dart';
import 'bloc/link_co_parent_state.dart';

class LinkCoParentScreen extends StatefulWidget {
  const LinkCoParentScreen({super.key});

  @override
  State<LinkCoParentScreen> createState() => _LinkCoParentScreenState();
}

class _LinkCoParentScreenState extends State<LinkCoParentScreen> {
  final TextEditingController _emailController = TextEditingController();

  static const List<Color> _ctaGradient = <Color>[
    Color(0xFF6A24B8),
    Color(0xFF894BCD),
    Color(0xFFA96EE0),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LinkCoParentCubit>().init();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LinkCoParentCubit, LinkCoParentState>(
      listener: (BuildContext context, LinkCoParentState state) {
        state.createInvitation.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (dynamic data) {
            EasyLoading.dismiss();
            if (state.emailDeliveryFailed) {
              showSnackBar(
                message: LocaleKeys.invitationEmailDeliveryFailed.tr(),
                type: SnackBarType.ERROR,
              );
            } else {
              showSnackBar(
                message: LocaleKeys.invitationSentSuccess.tr(
                  namedArgs: <String, String>{
                    'email': state.coParentEmail ?? '',
                  },
                ),
                type: SnackBarType.SUCCESS,
              );
            }
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
      builder: (BuildContext context, LinkCoParentState state) {
        if (_emailController.text != (state.coParentEmail ?? '')) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _emailController.value = _emailController.value.copyWith(
              text: state.coParentEmail ?? '',
              selection: _emailController.selection,
            );
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: <Widget>[
              _ambientBackground(),
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.13,
                    child: Assets.images.imgCoParentBg.image(
                      fit: BoxFit.cover,
                      width: context.width,
                      height: context.height,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
                      child: _navHeader(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 36.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _heroInviteCard(),
                            18.h.spaceH,
                            _glassFormCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  _sectionCard(
                                    title: LocaleKeys.coParentEmail.tr(),
                                    icon: Icons.alternate_email_rounded,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[_coParentEmail(state)],
                                    ),
                                  ),
                                  14.h.spaceH,
                                  _sectionCard(
                                    title: LocaleKeys.shareForWhichChild.tr(),
                                    icon: Icons.child_care_rounded,
                                    child: _shareForWhichChild(state),
                                  ),
                                  14.h.spaceH,
                                  _sectionCard(
                                    title: LocaleKeys.coParentingCalendar.tr(),
                                    icon: Icons.lock_clock_rounded,
                                    child: _whatTheyllhaveAccessTo(state),
                                  ),
                                  26.h.spaceH,
                                  _sendInvite(
                                    text: state.selectedTab == 'EMAIL'
                                        ? LocaleKeys.sendInvite.tr()
                                        : LocaleKeys.generateInviteLink.tr(),
                                    onTap: () {
                                      context
                                          .read<LinkCoParentCubit>()
                                          .sendInvite();
                                    },
                                  ),
                                  14.h.spaceH,
                                  _inviteFootnote(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _ambientBackground() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  const Color(0xFFF5F0FF),
                  const Color(0xFFFFF8FB),
                  const Color(0xFFFAFAFA),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -80.h,
          right: -45.w,
          child: _softOrb(const Color(0xFF894BCD), 230.w),
        ),
        Positioned(
          top: 160.h,
          left: -65.w,
          child: _softOrb(const Color(0xFF5271FF), 200.w),
        ),
        Positioned(
          bottom: 120.h,
          right: -55.w,
          child: _softOrb(const Color(0xFFFF66C4), 210.w),
        ),
      ],
    );
  }

  Widget _softOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.13),
      ),
    );
  }

  Widget _navHeader() {
    return Row(
      children: <Widget>[
        BaseButton(
          onTap: () => context.pop(),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.9),
                    width: 1.5,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Assets.icons.icBackIcon.image(height: 22.h, width: 22.w),
              ),
            ),
          ),
        ),
        14.w.spaceW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LocaleKeys.linkCoParent.tr().appText(
                fontWeight: FontWeight.w900,
                fontSize: 22.sp,
                color: Colors.black87,
                textAlign: TextAlign.start,
                letterSpacing: -0.3,
              ),
              4.h.spaceH,
              LocaleKeys.familySync.tr().appText(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroInviteCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              primaryColor.withValues(alpha: 0.92),
              const Color(0xFFA96EE0).withValues(alpha: 0.88),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.group_add_rounded,
                color: Colors.white,
                size: 26.sp,
              ),
            ),
            14.w.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LocaleKeys.addFirstSharedEvent.tr().appText(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.96),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  6.h.spaceH,
                  LocaleKeys.shareResponsibilityFairly
                      .tr()
                      .replaceAll('\n', ' ')
                      .appText(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                        textAlign: TextAlign.start,
                        height: 1.3,
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassFormCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 20.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.95),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.95)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 18.sp, color: primaryColor),
              8.w.spaceW,
              title.appText(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: blackTextColor,
              ),
            ],
          ),
          10.h.spaceH,
          child,
        ],
      ),
    );
  }

  Widget _sendInvite({required String text, required VoidCallback? onTap}) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _ctaGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.42),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: text.appText(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _coParentEmail(LinkCoParentState state) {
    return AppTextField(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.94),
      hint: LocaleKeys.coParentEmailHint.tr(),
      hintStyle: getTextStyle(fontSize: 13.sp, color: Colors.grey.shade500),
      error: state.coParentEmailError,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) {
        context.read<LinkCoParentCubit>().changeProps(coParentEmail: value);
      },
    );
  }

  Widget _shareForWhichChild(LinkCoParentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: state.children
              .map(
                (ChildModel child) => BaseButton(
                  onTap: () {
                    context.read<LinkCoParentCubit>().selectChild(child);
                  },
                  child: _childNameChip(
                    name: child.childName ?? '',
                    selected: state.selectedChildren.any(
                      (ChildModel e) => e.reference?.id == child.reference?.id,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if ((state.selectChildrenError ?? '').isNotEmpty) ...<Widget>[
          8.h.spaceH,
          (state.selectChildrenError ?? '').appText(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: redColor,
            textAlign: TextAlign.start,
          ),
        ],
      ],
    );
  }

  Widget _childNameChip({required String name, required bool selected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: selected
            ? LinearGradient(
                colors: <Color>[
                  _ctaGradient[0].withValues(alpha: 0.95),
                  _ctaGradient[2].withValues(alpha: 0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: selected ? null : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: selected
              ? Colors.transparent
              : Colors.white.withValues(alpha: 0.95),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: selected
                ? primaryColor.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: selected ? 14 : 8,
            offset: Offset(0, selected ? 5 : 3),
          ),
        ],
      ),
      child: name.appText(
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
        color: selected ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _whatTheyllhaveAccessTo(LinkCoParentState state) {
    return Column(
      children: <Widget>[
        _accessCard(
          isRequired: false,
          title: LocaleKeys.calendarEvents.tr(),
          description: LocaleKeys.createApproveAndChangeSharedEvents.tr(),
          icon: Icons.calendar_month_rounded,
          switchValue: state.calenderAndEvent,
          onChanged: (bool value) {
            context.read<LinkCoParentCubit>().changeProps(
              calenderAndEvent: value,
            );
          },
        ),
        12.h.spaceH,
        _accessCard(
          isRequired: false,
          title: LocaleKeys.childEssentials.tr(),
          description: LocaleKeys.medicalNotesSchoolContactsAllergies.tr(),
          icon: Icons.favorite_outline_rounded,
          switchValue: state.childEssentials,
          onChanged: (bool value) {
            context.read<LinkCoParentCubit>().changeProps(
              childEssentials: value,
            );
          },
        ),
        12.h.spaceH,
        _accessCard(
          isRequired: false,
          title: LocaleKeys.eventAttachment.tr(),
          description: LocaleKeys.attachDocument.tr(),
          icon: Icons.attach_file_rounded,
          showSwitch: false,
        ),
      ],
    );
  }

  Widget _accessCard({
    required bool isRequired,
    required String title,
    required String description,
    required IconData icon,
    bool showSwitch = true,
    bool switchValue = false,
    ValueChanged<bool>? onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.95),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: primaryColor, size: 22.sp),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: title.appText(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: blackTextColor,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isRequired) ...<Widget>[
                      8.w.spaceW,
                      LocaleKeys.starRequired.tr().appText(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ],
                ),
                if (description.isNotEmpty) ...<Widget>[
                  4.h.spaceH,
                  description.appText(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: greyColor1,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (showSwitch)
            Transform.scale(
              scale: 0.82,
              child: Switch(
                value: switchValue,
                onChanged: onChanged,
                activeTrackColor: primaryColor,
                activeThumbColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _inviteFootnote() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.info_outline_rounded, size: 18.sp, color: primaryColor),
          10.w.spaceW,
          Expanded(
            child: LocaleKeys.onceAcceptedyouSameSharedCalendar.tr().appText(
              color: Colors.black87,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
