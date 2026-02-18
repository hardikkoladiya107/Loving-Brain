import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:share_plus/share_plus.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/app_utils.dart';
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
      listener: (context, state) {
        state.createInvitation.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (dynamic data) {
            EasyLoading.dismiss();
            showSnackBar(
              message: 'inviteLinkReadyToShare'.tr(),
              type: SnackBarType.SUCCESS,
            );
            final String invitationLink = getInvitationLink(data.toString());
            SharePlus.instance.share(
              ShareParams(
                text:
                    'Please join as co-parent using this link\n$invitationLink',
              ),
            );
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
      builder: (context, state) {
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
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Assets.images.imgCoParentBg.image(
                    fit: BoxFit.cover,
                    width: context.width,
                    height: context.height,
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 8.h,
                    bottom: 32.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.h.spaceH,
                      _appBar(),
                      24.h.spaceH,
                      _coParentEmail(state),
                      20.h.spaceH,
                      _shareForWhichChild(state),
                      24.h.spaceH,
                      _whatTheyllhaveAccessTo(state),
                      28.h.spaceH,
                      _sendInvite(
                        text: state.selectedTab == 'EMAIL'
                            ? LocaleKeys.sendInvite.tr()
                            : LocaleKeys.generateInviteLink.tr(),
                        onTap: () {
                          context.read<LinkCoParentCubit>().sendInvite();
                        },
                      ),
                      16.h.spaceH,
                      _inviteDescriptionText(),
                      24.h.spaceH,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sendInvite({
    required String text,
    required VoidCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: blueColor2.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: text.appText(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 15.sp,
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          onTap: () => Navigator.pop(context),
          child: Assets.icons.icBackIcon.image(
            height: 36.h,
            width: 36.w,
            color: Colors.black.withValues(alpha: 0.8),
          ),
        ),
        12.w.spaceW,
        LocaleKeys.linkCoParent.tr().appText(
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
          color: blackTextColor,
        ),
      ],
    );
  }

  Widget _coParentEmail(LinkCoParentState state) {
    return AppTextField(
      filled: true,
      fillColor: fillTextfieldColor,
      title: LocaleKeys.coParentEmail.tr(),
      hint: LocaleKeys.coParentEmailHint.tr(),
      hintStyle: getTextStyle(fontSize: 12.sp),
      error: state.coParentEmailError,
      controller: _emailController,
      onChanged: (String value) {
        context.read<LinkCoParentCubit>().changeProps(coParentEmail: value);
      },
    );
  }

  Widget _shareForWhichChild(LinkCoParentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.shareForWhichChild.tr().appText(
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
          color: blackTextColor,
        ),
        12.h.spaceH,
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
                      (ChildModel e) =>
                          e.reference?.id == child.reference?.id,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if ((state.selectChildrenError ?? '').isNotEmpty) ...[
          8.h.spaceH,
          (state.selectChildrenError ?? '').appText(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: redColor,
          ),
        ],
      ],
    );
  }

  Widget _childNameChip({required String name, required bool selected}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: tabBarBgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: selected ? Border.all(color: primaryColor, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: name.appText(
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
        color: blackTextColor,
      ),
    );
  }

  Widget _whatTheyllhaveAccessTo(LinkCoParentState state) {
    return Column(
      children: [
        _accessCard(
          isRequired: true,
          title: LocaleKeys.calendarEvents.tr(),
          description: LocaleKeys.createApproveAndChangeSharedEvents.tr(),
          switchValue: state.calenderAndEvent,
          onChanged: (bool value) {
            context.read<LinkCoParentCubit>().changeProps(
                  calenderAndEvent: value,
                );
          },
        ),
        14.h.spaceH,
        _accessCard(
          isRequired: false,
          title: LocaleKeys.childEssentials.tr(),
          description: LocaleKeys.medicalNotesSchoolContactsAllergies.tr(),
          switchValue: state.childEssentials,
          onChanged: (bool value) {
            context.read<LinkCoParentCubit>().changeProps(
                  childEssentials: value,
                );
          },
        ),
        14.h.spaceH,
        _accessCard(
          isRequired: false,
          title: LocaleKeys.eventAttachment.tr(),
          description: '',
          showSwitch: false,
        ),
      ],
    );
  }

  Widget _accessCard({
    required bool isRequired,
    required String title,
    required String description,
    bool showSwitch = true,
    bool switchValue = false,
    ValueChanged<bool>? onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: fillTextfieldColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    title.appText(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: blackTextColor,
                    ),
                    if (isRequired) ...[
                      8.w.spaceW,
                      LocaleKeys.starRequired.tr().appText(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ],
                ),
                4.h.spaceH,
                description.appText(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: greyColor1,
                ),
              ],
            ),
          ),
          if (showSwitch)
            Transform.scale(
              scale: 0.8,
              child: Switch(value: switchValue, onChanged: onChanged),
            ),
        ],
      ),
    );
  }

  Widget _inviteDescriptionText() {
    return LocaleKeys.onceAcceptedyouSameSharedCalendar.tr().appText(
      color: blackTextColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    );
  }
}
