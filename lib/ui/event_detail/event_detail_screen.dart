import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/shared_event_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../widget/base_button.dart';
import 'bloc/event_detail_cubit.dart';
import 'bloc/event_detail_state.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.sharedEvent});

  final SharedEventModel sharedEvent;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<EventDetailCubit>().init(widget.sharedEvent);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventDetailCubit, EventDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: addSharedEventBgColor,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Assets.images.imgEventDetailBg.image(
                      height: context.height,
                      width: context.width,
                      fit: BoxFit.cover,
                    ),
                    Container(height: context.height / 2),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    45.h.spaceH,
                    _appBar(),
                    30.h.spaceH,
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (state.sharedEvent?.title ?? "").appText(
                            fontWeight: FontWeight.w800,
                          ),
                          LocaleKeys.forChildCreatedBy.tr(
                            namedArgs: {
                              'childName': _getChildName(state),
                              'creatorName': _getCreatedByName(state),
                            },
                          ).appText(fontSize: 14),
                        ],
                      ).appPadding(all: 8),
                    ),
                    40.h.spaceH,
                    Row(
                      children: [
                        Assets.icons.icCalenderIcon3.image(
                          height: 20,
                          width: 20,
                        ),
                        12.w.spaceW,
                        coParentEventDetailTime(
                          state.sharedEvent?.date,
                        ).appText(fontWeight: FontWeight.w600, fontSize: 14),
                      ],
                    ).appPadding(left: 12.w),
                    16.h.spaceH,
                    Row(
                      children: [
                        Assets.icons.icTimerIcon.image(height: 24, width: 24),
                        12.w.spaceW,
                        "${getStringTime(state.sharedEvent?.startTime)} – ${getStringTime(state.sharedEvent?.endTime)}"
                            .appText(fontWeight: FontWeight.w600, fontSize: 14),
                      ],
                    ).appPadding(left: 12.w),
                    16.h.spaceH,
                    Row(
                      children: [
                        Assets.icons.icLocationIcon.image(
                          height: 24,
                          width: 24,
                        ),
                        12.w.spaceW,
                        (state.sharedEvent?.location ?? "").appText(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ],
                    ).appPadding(left: 12.w),
                    16.h.spaceH,
                    Row(
                      children: [
                        Assets.icons.icUserIcon.image(height: 24, width: 24),
                        12.w.spaceW,
                        _getAssignee(
                          state,
                        ).appText(fontWeight: FontWeight.w600, fontSize: 14),
                      ],
                    ).appPadding(left: 12.w),
                    45.h.spaceH,
                    if ((state.sharedEvent?.note ?? "").isNotEmpty) ...[
                      _note(state.sharedEvent?.note),
                      10.h.spaceH,
                    ],
                    _attachments(state),
                    10.h.spaceH,
                    _history(),
                    30.h.spaceH,
                    _bottomButtons(state),
                    30.h.spaceH,
                    LocaleKeys.thisEventAppearsInBothCalendars.tr().appText(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ).appPadding(left: 20.w, right: 20.w),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        state.uploadDocumentApiResultStatus.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
          },
          error: (error) {
            EasyLoading.dismiss();
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
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
            context.pop();
          },
        ),
        20.w.spaceW,
        LocaleKeys.eventDetails.tr().appText(fontWeight: FontWeight.w700, fontSize: 20),
      ],
    );
  }

  Widget _note(String? note) {
    return Container(
      decoration: BoxDecoration(
        color: aiQuestionCardColor1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocaleKeys.note.tr().appText(color: cardColor2, fontWeight: FontWeight.w700),
          (note ?? "").appText(
            fontSize: 12,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w600,
          ),
        ],
      ).appPadding(all: 8),
    );
  }



  Widget _history() {
    return Container(
      decoration: BoxDecoration(
        color: fillTextfieldColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.spaceH,
          LocaleKeys.history.tr().appText(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          4.spaceH,
          Row(
            children: [
              Assets.icons.icSuccessCheck.image(),
              4.spaceW,
              LocaleKeys.mockApprovedByPriya.tr().appText(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ],
          ),
          4.spaceH,
          Row(
            children: [
              Assets.icons.icSuccessCheck.image(),
              4.spaceW,
              LocaleKeys.mockApprovedByPriya.tr().appText(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ],
          ),
          10.spaceH,
        ],
      ).appPadding(left: 20),
    );
  }

  Widget _bottomButton({
    required GestureTapCallback? onTap,
    required String text,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text
                .appText(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                )
                .appPadding(top: 5, bottom: 5),
          ],
        ),
      ),
    );
  }

  Widget _bottomButtons(EventDetailState state) {
    return Row(
      children: [
        Expanded(
          child: _bottomButton(
            onTap: () {
              if (state.sharedEvent != null) {
                context.push(RoutePaths.proposeChange, extra: state.sharedEvent!);
              }
            },
            text: LocaleKeys.proposeChange.tr(),
          ),
        ),
        10.w.spaceW,
        Expanded(
          child: _bottomButton(onTap: () {}, text: LocaleKeys.reminder.tr()),
        ),
        10.w.spaceW,
        Expanded(
          child: _bottomButton(
            onTap: () {
              SharePlus.instance.share(
                ShareParams(text: _getShareMessage(state)),
              );
            },
            text: LocaleKeys.share.tr(),
          ),
        ),
      ],
    );
  }

  String _getAssignee(EventDetailState state) {
    return state.assignedUserList
        .map((e) => (e.parentName ?? ""))
        .toList()
        .join(", ");
  }

  String _getChildName(EventDetailState state) {
    return state.childrenList.map((e) => e.childName ?? "").toList().join(",");
  }

  String _getCreatedByName(EventDetailState state) {
    return state.createdByUser?.parentName ?? "";
  }

  String? _getShareMessage(EventDetailState state) {
    return "dd";
  }

  Widget _attachments(EventDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: fillTextfieldColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          8.h.spaceH,
          Row(
            children: [
              10.w.spaceW,
              Assets.icons.icAttachmentPin.image(height: 20, width: 20),
              10.w.spaceW,
              LocaleKeys.attachment.tr().appText(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              _addAttachment(),
              10.w.spaceW,
            ],
          ),
          _filesWidget(state),
        ],
      ),
    );
  }

  String _getFileName(String e) {
    var finalPath = e.split("?").first.toString();
    var fileName = finalPath.split("%2F").last;
    return fileName.toString();
  }

  Widget _fileNameWidget(String e) {
    return Row(
      children: [
        Icon(Icons.file_copy_outlined, size: 20, color: primaryColor),
        10.spaceW,
        Expanded(
          child: BaseButton(
            child: _getFileName(e).appText(
              textAlign: TextAlign.start,
              fontSize: 14,
              color: primaryColor,
              fontWeight: FontWeight.w600,
              textDecoration: TextDecoration.underline,
            ),
            onTap: () async {
              if (!await launchUrl(Uri.parse(e))) {
                showSnackBar(
                  message: LocaleKeys.somethingWentWrong.tr(),
                  type: SnackBarType.ERROR,
                );
              }
            },
          ),
        ),
      ],
    ).appPadding(left: 20, right: 20);
  }

  Widget _filesWidget(EventDetailState state) {
    return Column(
      children: [
        20.spaceH,
        ...(state.sharedEvent?.documents ?? []).map(
          (e) => _fileNameWidget(e),
        ),
        20.spaceH,
      ],
    );
  }

  Widget _addAttachment() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: LocaleKeys.addAttachment
            .tr()
            .appText(fontSize: 10, fontWeight: FontWeight.w700)
            .appPadding(left: 6, right: 6, top: 4, bottom: 4),
      ),
      onTap: () {
        _chooseImage();
      },
    );
  }

  Future<void> _chooseImage() async {
    final XFile? photo = await ImagePicker().pickMedia();
    if (photo != null && navigatorKey.currentContext != null) {
      navigatorKey.currentContext!
          .read<EventDetailCubit>()
          .uploadToFirebaseStorage(photo.path);
    }
  }
}
