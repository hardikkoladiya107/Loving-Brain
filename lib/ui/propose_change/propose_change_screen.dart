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
import 'bloc/propose_change_cubit.dart';
import 'bloc/propose_change_state.dart';

class ProposeChangeScreen extends StatefulWidget {
  const ProposeChangeScreen({super.key});

  @override
  State<ProposeChangeScreen> createState() => _ProposeChangeScreenState();
}

class _ProposeChangeScreenState extends State<ProposeChangeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProposeChangeCubit, ProposeChangeState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(children: [_backgroundImage(), _screenBody()]),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _backgroundImage() {
    return Column(
      children: [
        Assets.images.imgEssentialsBg.image(height: context.height,fit: BoxFit.cover),
        Container(height: context.height / 2),
      ],
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: LocaleKeys.proposeChange
              .tr()
              .appText(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              )
              .appPadding(left: 10, right: 10, top: 6, bottom: 6),
        ),
      ],
    );
  }

  Widget _startEndTextField() {
    return Row(
      children: [
        Expanded(
          child: AppTextField(fillColor: Colors.grey.withValues(alpha: 0.2)),
        ),
        20.spaceW,
        Expanded(
          child: AppTextField(fillColor: Colors.grey.withValues(alpha: 0.2)),
        ),
      ],
    );
  }

  Widget _youAreProposing() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.spaceH,
          "Current"
              .appText(fontSize: 14, fontWeight: FontWeight.w600)
              .appPadding(left: 20.w),
          4.spaceH,
          _timeWidget(),
          10.spaceH,
          "Proposed"
              .appText(fontSize: 14, fontWeight: FontWeight.w600)
              .appPadding(left: 20.w),
          4.spaceH,
          _timeWidget(),
          10.spaceH,
        ],
      ),
    );
  }

  Widget _timeWidget() {
    return Container(
      height: 30.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _newDate() {
    return AppTextField(fillColor: Colors.grey.withValues(alpha: 0.2));
  }

  Widget _startEndHeader() {
    return Row(
      children: [
        Expanded(
          child: "Start".appText(
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: "End".appText(
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _noteToCoParent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Note to co‐parent (optional)".appText(
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 14,
        ),
        10.h.spaceH,
        AppTextField(
          minLines: 3,
          fillColor: Colors.grey.withValues(alpha: 0.2),
        ),
      ],
    );
  }

  Widget _screenBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        45.h.spaceH,
        _appBar(),

        80.spaceH,
        _header(),
        130.spaceH,
        Row(),
        "You're proposing".appText(fontWeight: FontWeight.w600),
        10.h.spaceH,
        _youAreProposing(),
        10.h.spaceH,
        "New date".appText(fontWeight: FontWeight.w600, fontSize: 14),
        10.h.spaceH,
        _newDate(),
        _startEndHeader(),
        10.h.spaceH,
        _startEndTextField(),
        10.h.spaceH,
        _quickWidget(),
        10.h.spaceH,
        _noteToCoParent(),
        10.h.spaceH,
        proposeButton(text: 'Send Proposal', onTap: () {}),
      ],
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(height: 36, width: 36),
          onTap: () {
            Navigator.pop(context);
          },
        ),

      ],
    );
  }

  Widget proposeButton({
    required String text,
    required GestureTapCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 40,
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

  Widget _quickWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        "Quick:".appText(fontWeight: FontWeight.w600, fontSize: 14),
        _quickItem(label: "+15"),
        _quickItem(label: "+30"),
        _quickItem(label: "Move to Tomorrow"),
      ],
    );
  }

  Widget _quickItem({required String label}) {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: label
            .appText(fontWeight: FontWeight.w600, fontSize: 14)
            .appPadding(all: 8),
      ),
      onTap: () {},
    );
  }
}
