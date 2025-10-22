import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/shared_event_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../widget/base_button.dart';
import 'bloc/event_approval_cubit.dart';
import 'bloc/event_approval_state.dart';

class EventApprovalScreen extends StatefulWidget {
  const EventApprovalScreen({super.key, required this.sharedEvent});

  final SharedEventModel sharedEvent;

  @override
  State<EventApprovalScreen> createState() => _EventApprovalScreenState();
}

class _EventApprovalScreenState extends State<EventApprovalScreen> {
  @override
  void initState() {
    context.read<EventApprovalCubit>().init(widget.sharedEvent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventApprovalCubit, EventApprovalState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Assets.images.imgEventApprovalBg.image(
                      height: context.height,
                      width: context.width,
                      fit: BoxFit.cover,
                    ),
                    Container(height: context.height / 2),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    45.h.spaceH,
                    _appBar(),
                    70.h.spaceH,
                    LocaleKeys.eventApproval.tr().appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                    LocaleKeys.reviewAndConfirmTheSharedEvent.tr().appText(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    120.h.spaceH,
                    _approvalCard(state),
                    20.h.spaceH,
                    LocaleKeys.yourResponseUpdatesEventForBothParents
                        .tr()
                        .appText(fontSize: 12, fontWeight: FontWeight.w600),
                  ],
                ).appPadding(left: 20.w, right: 20.w),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        state.updatedSharedEventApiResult.whenOrNull(
          error: (error) {
            EasyLoading.dismiss();
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
          },
          data: (data) {
            Navigator.pop(context);
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
        );
      },
    );
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
      ],
    );
  }

  Widget _approvalCard(EventApprovalState state) {
    return Container(
      decoration: BoxDecoration(
        color: aiQuestionCardColor4,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          12.h.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: (state.sharedEvent?.title ?? "")
                    .appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    )
                    .appPadding(left: 12.w, right: 12.w),
              ),
              Container(
                decoration: BoxDecoration(
                  color: yellowColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: "Pending • waiting for you"
                    .appText(fontSize: 10, fontWeight: FontWeight.w700)
                    .appPadding(left: 8.w, right: 8.w, top: 4.h, bottom: 4.h),
              ).appPadding(right: 12.w),
            ],
          ),
          8.h.spaceH,
          "Requested by ${_getCreatedByName(state)} • for ${_getChildName(state)}"
              .appText(fontSize: 10, fontWeight: FontWeight.w700)
              .appPadding(left: 12.w),

          12.h.spaceH,
          Row(
            children: [
              Assets.icons.icCalenderIcon3.image(height: 20, width: 20),
              12.w.spaceW,
              coParentEventDetailTime(
                state.sharedEvent?.date,
              ).appText(fontWeight: FontWeight.w600, fontSize: 14),
            ],
          ).appPadding(left: 12.w),
          10.h.spaceH,
          Row(
            children: [
              Assets.icons.icTimerIcon.image(height: 24, width: 24),
              12.w.spaceW,

              "${getStringTime(state.sharedEvent?.startTime)} – ${getStringTime(state.sharedEvent?.endTime)}"
                  .appText(fontWeight: FontWeight.w600, fontSize: 14),
            ],
          ).appPadding(left: 12.w),
          10.h.spaceH,
          Row(
            children: [
              Assets.icons.icLocationIcon.image(height: 24, width: 24),
              12.w.spaceW,
              (state.sharedEvent?.location ?? "").appText(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ],
          ).appPadding(left: 12.w),
          10.h.spaceH,
          Row(
            children: [
              Assets.icons.icUserIcon.image(height: 24, width: 24),
              12.w.spaceW,

              _getAssignee(
                state,
              ).appText(fontWeight: FontWeight.w600, fontSize: 14),
            ],
          ).appPadding(left: 12.w),
          30.h.spaceH,

          Row(
            children: [
              10.w.spaceW,
              Expanded(
                child: _button(
                  color: selectedTabColor,
                  text: LocaleKeys.decline.tr(),
                  image: Assets.icons.icDeclineIcon,
                  onTap: () {
                    context.read<EventApprovalCubit>().approveReject("REJECT");
                  },
                ),
              ),
              10.w.spaceW,
              Expanded(
                child: _button(
                  color: greyColor,
                  text: LocaleKeys.propose.tr(),
                  image: Assets.icons.icProposeIcon,
                  onTap: () {},
                ),
              ),
              10.w.spaceW,
              Expanded(
                child: _button(
                  color: gentleReminderIconColor,
                  text: LocaleKeys.approve.tr(),
                  image: Assets.icons.icApproveIcon,
                  onTap: () {
                    context.read<EventApprovalCubit>().approveReject(
                      "APPROVED",
                    );
                  },
                ),
              ),
              10.w.spaceW,
            ],
          ),
          50.h.spaceH,
        ],
      ),
    );
  }

  String _getAssignee(EventApprovalState state) {
    return state.assignedUserList
        .map((e) => (e.parentName ?? ""))
        .toList()
        .join(", ");
  }

  Widget _button({
    required Color color,
    required String text,
    required AssetGenImage image,
    required GestureTapCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image.image(height: 20, width: 20),
            8.w.spaceW,
            text.appText(fontWeight: FontWeight.w600, fontSize: 12),
          ],
        ).appPadding(top: 6.h, bottom: 6.h),
      ),
    );
  }

  String _getChildName(EventApprovalState state) {
    return state.childrenList.map((e) => e.childName ?? "").toList().join(",");
  }

  String _getCreatedByName(EventApprovalState state) {
    return state.createdByUser?.parentName ?? "";
  }
}
