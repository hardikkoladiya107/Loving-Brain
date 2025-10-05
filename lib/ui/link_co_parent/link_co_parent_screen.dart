import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
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
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<LinkCoParentCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LinkCoParentCubit, LinkCoParentState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Assets.images.imgCoParentBg.image(
                      height: context.height,
                      width: context.width,
                    ),
                    Container(height: 250.h),
                  ],
                ),
                Column(
                  children: [
                    45.h.spaceH,
                    _appBar(),
                    48.h.spaceH,
                    _headerTabBar(state),
                    32.h.spaceH,
                    _coParentEmail(),
                    65.h.spaceH,
                    _shareForWhichChild(),
                    32.h.spaceH,
                    _whatTheyllhaveAccessTo(),
                    32.h.spaceH,
                    _sendInvite(text: LocaleKeys.sendInvite.tr(), onTap: () {}),
                    12.h.spaceH,
                    _inviteDescriptionText(),
                    32.h.spaceH,
                  ],
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _sendInvite({
    required String text,
    required GestureTapCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.appText(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ],
        ),
      ),
    ).appPadding(left: 15, right: 15);
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(
            height: 36,
            width: 36,
            color: Colors.black.withValues(alpha: 0.8),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        12.w.spaceW,
        LocaleKeys.linkCoParent.tr().appText(fontWeight: FontWeight.w700),
      ],
    ).appPadding(left: 20);
  }

  Widget _headerTabBar(LinkCoParentState state) {
    return Container(
      width: 250.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: tabBarBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: BaseButton(
              child: Container(
                decoration: state.selectedTab == "EMAIL"
                    ? BoxDecoration(
                        color: selectedTabColor,
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(),
                    Icon(Icons.email_outlined, size: 20),
                    8.spaceW,
                    LocaleKeys.email.tr().appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
              onTap: () {
                context.read<LinkCoParentCubit>().changeProps(
                  selectedTab: "EMAIL",
                );
              },
            ),
          ),
          8.spaceW,
          Expanded(
            child: BaseButton(
              child: Container(
                decoration: state.selectedTab == "INVITE_LINK"
                    ? BoxDecoration(
                        color: selectedTabColor,
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(),
                    Icon(Icons.link, size: 24),
                    8.spaceW,
                    LocaleKeys.inviteLink.tr().appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
              onTap: () {
                context.read<LinkCoParentCubit>().changeProps(
                  selectedTab: "INVITE_LINK",
                );
              },
            ),
          ),
        ],
      ).appPadding(all: 6),
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget _coParentEmail() {
    return AppTextField(
      filled: true,
      fillColor: fillTextfieldColor,
      title: LocaleKeys.coParentEmail.tr(),
      hint: LocaleKeys.coParentEmailHint.tr(),
      hintStyle: getTextStyle(fontSize: 12),
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget _shareForWhichChild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.shareForWhichChild.tr().appText(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        16.spaceH,
        Row(
          children: [
            childNameCard(name: "Leo"),
            15.w.spaceW,
            childNameCard(name: "Ava"),
          ],
        ),
      ],
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget childNameCard({required String name}) {
    return Container(
      decoration: BoxDecoration(
        color: tabBarBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: name
          .appText(fontWeight: FontWeight.w700, fontSize: 14)
          .appPadding(all: 12),
    );
  }

  Widget _whatTheyllhaveAccessTo() {
    return Column(
      children: [
        accessCard(
          isRequired: true,
          title: LocaleKeys.calendarEvents.tr(),
          description: LocaleKeys.createApproveAndChangeSharedEvents.tr(),
        ),
        20.h.spaceH,
        accessCard(
          isRequired: false,
          title: LocaleKeys.childEssentials.tr(),
          description: LocaleKeys.medicalNotesSchoolContactsAllergies.tr(),
        ),
        20.h.spaceH,
        accessCard(
          isRequired: false,
          title: LocaleKeys.eventAttachment.tr(),
          description: '',
          showSwitch: false,
        ),
      ],
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget accessCard({
    required bool isRequired,
    required String title,
    required String description,
    bool showSwitch = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fillTextfieldColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    title.appText(fontSize: 14, fontWeight: FontWeight.w700),
                    if (isRequired) ...[
                      16.spaceW,
                      LocaleKeys.starRequired.tr().appText(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ],
                ),
                description.appText(fontSize: 10, fontWeight: FontWeight.w700),
              ],
            ),
          ),
          if (showSwitch)
            Transform.scale(
              scale: 0.7,
              child: Switch(value: true, onChanged: (value) {}),
            ),
        ],
      ).appPadding(all: 10),
    );
  }

  Widget _inviteDescriptionText() {
    return LocaleKeys.onceAcceptedyouSameSharedCalendar
        .tr()
        .appText(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700)
        .appPadding(left: 20.w, right: 20.w);
  }
}
