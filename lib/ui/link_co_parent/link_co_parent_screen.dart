import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
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
  TextEditingController linkCoParentEmailController = TextEditingController();

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
        if (linkCoParentEmailController.text != state.coParentEmail) {
          linkCoParentEmailController.value = linkCoParentEmailController.value
              .copyWith(
                text: state.coParentEmail ?? '',
                selection: linkCoParentEmailController.selection,
              );
        }

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
                    160.h.spaceH,
                    _coParentEmail(state),
                    20.h.spaceH,
                    _shareForWhichChild(state),
                    32.h.spaceH,
                    _whatTheyllhaveAccessTo(state),
                    32.h.spaceH,
                    _sendInvite(
                      text: state.selectedTab == "EMAIL"
                          ? LocaleKeys.sendInvite.tr()
                          : LocaleKeys.generateInviteLink.tr(),
                      onTap: () {
                        context.read<LinkCoParentCubit>().sendInvite();
                      },
                    ),
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
      listener: (context, state) {
        state.createInvitation.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
          data: (data) {
            EasyLoading.dismiss();
            var invitationLink = getInvitationLink(data.toString());
            SharePlus.instance.share(
              ShareParams(
                text:
                    'Please join as co-parent using this link\n $invitationLink',
              ),
            );
          },
        );
      },
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

  Widget _coParentEmail(LinkCoParentState state) {
    return AppTextField(
      filled: true,
      fillColor: fillTextfieldColor,
      title: LocaleKeys.coParentEmail.tr(),
      hint: LocaleKeys.coParentEmailHint.tr(),
      hintStyle: getTextStyle(fontSize: 12),
      error: state.coParentEmailError,
      onChanged: (value) {
        context.read<LinkCoParentCubit>().changeProps(coParentEmail: value);
      },
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget _shareForWhichChild(LinkCoParentState state) {
    List<Widget> widgetList = [];
    for (int i = 0; i < state.children.length; i++) {
      var child = state.children[i];
      widgetList.add(
        BaseButton(
          child: Row(
            children: [
              childNameCard(
                name: child.childName ?? "",
                selected: state.selectedChildren.any(
                  (element) => element.reference?.id == child.reference?.id,
                ),
              ),
              15.w.spaceW,
            ],
          ),
          onTap: () {
            context.read<LinkCoParentCubit>().selectChild(child);
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.shareForWhichChild.tr().appText(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        16.spaceH,
        Row(children: [...widgetList]),
        if ((state.selectChildrenError ?? "").isNotEmpty) ...[
          Column(
            children: [
              4.spaceH,
              Row(
                children: [
                  (state.selectChildrenError ?? "").appText(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ],
      ],
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget childNameCard({required String name, required bool selected}) {
    return Container(
      decoration: BoxDecoration(
        color: tabBarBgColor,
        borderRadius: BorderRadius.circular(20),
        border: selected ? Border.all(color: primaryColor, width: 2) : null,
      ),
      child: name
          .appText(fontWeight: FontWeight.w700, fontSize: 14)
          .appPadding(all: 12),
    );
  }

  Widget _whatTheyllhaveAccessTo(LinkCoParentState state) {
    return Column(
      children: [
        accessCard(
          isRequired: true,
          title: LocaleKeys.calendarEvents.tr(),
          description: LocaleKeys.createApproveAndChangeSharedEvents.tr(),
          switchValue: state.calenderAndEvent,
          onChanged: (value) {
            context.read<LinkCoParentCubit>().changeProps(
              calenderAndEvent: value,
            );
          },
        ),
        20.h.spaceH,
        accessCard(
          isRequired: false,
          title: LocaleKeys.childEssentials.tr(),
          description: LocaleKeys.medicalNotesSchoolContactsAllergies.tr(),
          switchValue: state.childEssentials,
          onChanged: (value) {
            context.read<LinkCoParentCubit>().changeProps(
              childEssentials: value,
            );
          },
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
    bool switchValue = false,
    ValueChanged<bool>? onChanged,
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
              child: Switch(value: switchValue, onChanged: onChanged),
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
