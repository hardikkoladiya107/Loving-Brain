import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/essential_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_dialogs.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/locale_keys.g.dart';
import '../widget/base_button.dart';
import 'bloc/essentials_cubit.dart';
import 'bloc/essentials_state.dart';

class EssentialsScreen extends StatefulWidget {
  const EssentialsScreen({super.key});

  @override
  State<EssentialsScreen> createState() => _EssentialsScreenState();
}

class _EssentialsScreenState extends State<EssentialsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<EssentialsCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EssentialsCubit, EssentialsState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: Stack(children: [_backgroundImage(), _essentialsBody(state)]),
        );
      },
      listener: (context, state) {
        state.addEssentialsApiResult.whenOrNull(
          data: (data) {
            EasyLoading.dismiss();
            Navigator.pop(context);
          },
          error: (error) {
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
          initial: () {
            EasyLoading.dismiss();
          },
        );
        state.childrenListApiResult.whenOrNull(
          data: (data) {
            EasyLoading.dismiss();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
          initial: () {
            EasyLoading.dismiss();
          },
        );

        state.uploadDocumentApiResultStatus.whenOrNull(
          data: (data) {
            EasyLoading.dismiss();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
        );
      },
    );
  }

  Widget _backgroundImage() {
    return Column(
      children: [
        Assets.images.imgEssentialsBg.image(
          height: context.height,
          fit: BoxFit.cover,
        ),
        // Container(height: context.height / 2),
      ],
    );
  }

  Widget _header(EssentialsState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: "${state.childModel?.childName ?? ""}'s Essentials"
          .appText(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          )
          .appPadding(left: 10, right: 10, top: 6, bottom: 6),
    );
  }

  Widget _essentialsBody(EssentialsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        45.h.spaceH,
        _appBar(state),
        80.spaceH,
        _header(state),
        130.spaceH,
        Row(),
        LocaleKeys.sharedInformationBothParentsSamePage.tr().appText(
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
        14.spaceH,
        Expanded(
          child: ListView(
            children: [
              _essentialNotesList(state),
              12.spaceH,
              _addNotesButton(state),
              12.spaceH,
              _essentialDocumentsList(state),
              120.spaceH,
            ],
          ),
        ),
      ],
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget _essentialNotesList(EssentialsState state) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: state.childModel?.essentials?.length ?? 0,
      separatorBuilder: (context, index) {
        return 4.0.spaceH;
      },
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: blueColor1,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  (state.childModel?.essentials?[index].title ?? "").appText(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  (state.childModel?.essentials?[index].description ?? "")
                      .appText(),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: yellowColor,
                  border: Border.all(color: redColor),
                ),
                child: InkWell(
                  onTap: () {
                    context.read<EssentialsCubit>().deleteEssentialNote(
                      index: index,
                    );
                  },
                  child: Icon(Icons.delete, size: 20, color: redColor),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: yellowColor,
                  border: Border.all(color: blueColor2),
                ),
                child: InkWell(
                  onTap: () async {
                    essentialNoteForm(state, index: index);
                  },
                  child: Icon(Icons.edit, size: 20, color: blueColor2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _essentialDocumentsList(EssentialsState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: aiQuestionCardColor2,
      ),
      child: Column(
        children: [
          if (state.childModel?.documents?.isNotEmpty ?? false) 12.spaceH,
          if (state.childModel?.documents?.isNotEmpty ?? false)
            LocaleKeys.attachedDocuments.appText(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.childModel?.documents?.length ?? 0,
            itemBuilder: (context, index) {
              return _fileNameWidget(state, index);
              return Row(
                children: [
                  "• ".appText(fontWeight: FontWeight.bold),
                  Expanded(
                    child: (state.childModel?.documents?[index] ?? "")
                        .firebaseFileName
                        .appText(),
                  ),
                ],
              );
            },
          ),
          _uploadDocButton(state).appPadding(all: 8),
        ],
      ),
    );
  }

  Widget _appBar(EssentialsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(height: 36, width: 36),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        AppDropDownButton(
          offset: Offset(0, 40),
          dropdownWidth: 170.w,
          dropDownWidget: (close) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: List.generate(state.childList.length, (index) {
                  return BaseButton(
                    child: Container(
                      height: 40.h,
                      width: 170.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            offset: Offset(0, 1),
                            spreadRadius: 2,
                            // blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: (state.childList[index].childName ?? "").appText(
                          fontWeight: FontWeight.w600,

                          fontSize: 14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    onTap: () {
                      context.read<EssentialsCubit>().changeProps(
                        childModel: state.childList[index],
                      );
                      context.read<EssentialsCubit>().fetchChildFromFirestore(
                        refVal: state.childList[index].reference,
                      );
                      close.call();
                    },
                  );
                }),
              ),
            );
          },
          child: Container(
            height: 40,
            width: 170.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                8.spaceW,
                Expanded(
                  child: state.childModel != null
                      ? (state.childModel?.childName ?? "").appText()
                      : SizedBox(),
                ),
                Icon(Icons.arrow_drop_down),
                8.spaceW,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _addNotesButton(EssentialsState state) {
    return BaseButton(
      onTap: () {
        context.read<EssentialsCubit>().changeProps(
          descriptionError: "",
          titleError: "",
          addEssentialsApiResult: ApiResultStatus.initial(),
        );
        essentialNoteForm(state);
      },
      child: Container(
        // width: 158.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined),
            12.spaceW,
            Center(
              child: LocaleKeys.addEssentialNote.tr().appText(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void essentialNoteForm(EssentialsState state, {int? index}) {
    EssentialNote? essentialNote;
    bool isEdit = index != null;
    if (isEdit) {
      essentialNote = state.childModel?.essentials?[index];
    }
    TextEditingController titleController = TextEditingController(
      text: essentialNote?.title,
    );
    TextEditingController descriptionController = TextEditingController(
      text: essentialNote?.description,
    );
    showAppDialog(
      child: (context) {
        return BlocBuilder<EssentialsCubit, EssentialsState>(
          builder: (context, state) {
            return Dialog(
              insetPadding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Essential".appText(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  6.spaceH,
                  Divider(),
                  6.spaceH,
                  AppTextField(
                    title: LocaleKeys.essentialTitle.tr(),
                    hint: LocaleKeys.enterEssentialTitle.tr(),
                    controller: titleController,
                    error: state.titleError,
                  ),
                  AppTextField(
                    title: LocaleKeys.essentialDescription.tr(),
                    hint: LocaleKeys.enterEssentialDescription.tr(),
                    minLines: 5,
                    controller: descriptionController,
                    error: state.descriptionError,
                  ),
                  BaseButton(
                    onTap: () {
                      print("title---->${titleController.text}");
                      print("description---->${descriptionController.text}");

                      if (isEdit) {
                        context.read<EssentialsCubit>().editEssentialNote(
                          index,
                          title: titleController.text,
                          description: descriptionController.text,
                        );
                      } else {
                        context.read<EssentialsCubit>().addEssentialNote(
                          title: titleController.text,
                          description: descriptionController.text,
                        );
                      }
                    },
                    child: Container(
                      // width: 158.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: blueColor2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child:
                            (isEdit
                                    ? LocaleKeys.save
                                    : LocaleKeys.addEssentialNote)
                                .tr()
                                .appText(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ),
                  ),
                ],
              ).appPadding(all: 12),
            );
          },
        );
      },
    );
  }

  Widget _uploadDocButton(EssentialsState state) {
    return BaseButton(
      child: Container(
        // width: 158.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: yellowColor3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined),
            12.spaceW,
            Center(
              child: LocaleKeys.uploadDocument.tr().appText(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        await _chooseImage(state);
      },
    );
  }

  Widget _fileNameWidget(EssentialsState state, int index) {
    return Row(
      children: [
        Icon(Icons.file_copy_outlined, size: 20, color: primaryColor),
        10.spaceW,
        Expanded(
          child: BaseButton(
            child: (state.childModel?.documents?[index] ?? "").firebaseFileName
                .appText(
                  textAlign: TextAlign.start,
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  textDecoration: TextDecoration.underline,
                ),
            onTap: () async {
              if (!await launchUrl(
                Uri.parse(state.childModel?.documents?[index] ?? ""),
              )) {
                showSnackBar(
                  message: LocaleKeys.somethingWentWrong.tr(),
                  type: SnackBarType.ERROR,
                );
              }
            },
          ),
        ),
        InkWell(
          onTap: () {
            context.read<EssentialsCubit>().deleteDocument(index: index);
          },
          child: Icon(Icons.delete, size: 24, color: Colors.red),
        ),
      ],
    ).appPadding(left: 20, right: 20);
  }

  Future<void> _chooseImage(EssentialsState state) async {
    final FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(allowMultiple: false);
    if (filePickerResult?.paths.isNotEmpty ?? false) {
      navigatorKey.currentContext
          ?.read<EssentialsCubit>()
          .uploadToFirebaseStorage(filePickerResult?.paths.first);
    }
  }
}
