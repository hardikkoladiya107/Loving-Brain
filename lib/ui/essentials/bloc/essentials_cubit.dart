import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/essential_model.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/child_repo.dart';
import 'essentials_state.dart';

class EssentialsCubit extends Cubit<EssentialsState> {
  EssentialsCubit() : super(EssentialsState());

  Future<void> init() async {
    changeProps(
      userModel: preferences.getUserModel(),
      titleError: "",
      descriptionError: "",
      addEssentialsApiResult: ApiResultStatus.initial(),
      childrenListApiResult: ApiResultStatus.initial(),
      uploadDocumentApiResultStatus: ApiResultStatus.initial(),
    );
    await loadChildren();
    await fetchChildFromFirestore();
  }

  void changeProps({
    ChildModel? childModel,
    List<ChildModel>? children,
    UserModel? userModel,
    ApiResultStatus? addEssentialsApiResult,
    ApiResultStatus? uploadDocumentApiResultStatus,
    ApiResultStatus? childrenListApiResult,
    String? titleError,
    String? descriptionError,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        addEssentialsApiResult:
            addEssentialsApiResult ?? state.addEssentialsApiResult,
        uploadDocumentApiResultStatus:
            uploadDocumentApiResultStatus ??
            state.uploadDocumentApiResultStatus,
        childrenListApiResult:
            childrenListApiResult ?? state.childrenListApiResult,
        titleError: titleError ?? state.titleError,
        descriptionError: descriptionError ?? state.descriptionError,
        childList: children ?? state.childList,
      ),
    );
  }

  // StreamSubscription? sharedEventStreamSubscription;

  // void _listenToChild() {
  //   if (state.userModel?.defaultChild != null) {
  //     sharedEventStreamSubscription?.cancel();
  //     sharedEventStreamSubscription = state.userModel?.defaultChild!
  //         .snapshots()
  //         .listen((event) {
  //           if (event.data() != null) {
  //             changeProps(
  //               childModel: ChildModel.fromJson(
  //                 event.data() as Map<String, dynamic>,
  //                 event.reference,
  //               ),
  //             );
  //           }
  //         });
  //   }

  Future<void> fetchChildFromFirestore({DocumentReference? refVal}) async {
    try {
      final DocumentReference? ref = refVal ?? state.userModel?.defaultChild;
      if (ref == null) return;
      final snapshot = await ref.get();
      final data = snapshot.data();
      if (data != null) {
        changeProps(
          childModel: ChildModel.fromJson(data as Map<String, dynamic>, ref),
        );
      }
    } catch (e) {
      debugPrint('Failed to fetch child: $e');
    }
  }

  bool isValidate({required String title, required String description}) {
    final String normalizedTitle = title.trim();
    final String normalizedDescription = description.trim();
    changeProps(titleError: "", descriptionError: "");

    if (normalizedTitle.isEmpty) {
      changeProps(titleError: LocaleKeys.pleaseEnterTitle.tr());
      return false;
    }
    if (normalizedDescription.isEmpty) {
      changeProps(descriptionError: LocaleKeys.pleaseEnterDescription.tr());
      return false;
    }
    return true;
  }

  Future<void> addEssentialNote({
    required String title,
    required String description,
  }) async {
    final String normalizedTitle = title.trim();
    final String normalizedDescription = description.trim();
    final String? childId = state.childModel?.reference?.id;
    if (!isValidate(
      title: normalizedTitle,
      description: normalizedDescription,
    )) {
      changeProps(addEssentialsApiResult: ApiResultStatus.initial());
      return;
    }
    if ((childId ?? "").isEmpty) {
      changeProps(
        addEssentialsApiResult: ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChild.tr()),
        ),
      );
      return;
    }
    changeProps(addEssentialsApiResult: ApiResultStatus.loading());
    final ApiResultStatus apiResultStatus = await ChildRepo.instance
        .addEssential(
          request: <String, dynamic>{
            "title": normalizedTitle,
            "description": normalizedDescription,
          },
          id: childId,
        );
    changeProps(addEssentialsApiResult: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (_) async {
        await fetchChildFromFirestore(refVal: state.childModel?.reference);
      },
    );
  }

  Future<void> editEssentialNote(
    int index, {
    required String title,
    required String description,
  }) async {
    final String normalizedTitle = title.trim();
    final String normalizedDescription = description.trim();
    final String? childId = state.childModel?.reference?.id;
    final List<EssentialNote> notes = List<EssentialNote>.from(
      state.childModel?.essentials ?? <EssentialNote>[],
    );
    if (!isValidate(
      title: normalizedTitle,
      description: normalizedDescription,
    )) {
      changeProps(addEssentialsApiResult: ApiResultStatus.initial());
      return;
    }
    if ((childId ?? "").isEmpty || index < 0 || index >= notes.length) {
      changeProps(
        addEssentialsApiResult: ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        ),
      );
      return;
    }
    changeProps(addEssentialsApiResult: ApiResultStatus.loading());

    notes[index] = EssentialNote(
      title: normalizedTitle,
      description: normalizedDescription,
    );
    final List<Map<String, dynamic>> data = notes
        .map((EssentialNote e) => e.toJson())
        .toList();
    final ApiResultStatus apiResultStatus = await ChildRepo.instance
        .updateEssentials(
          documentReference: childId,
          request: <String, dynamic>{'essentials': data},
        );
    changeProps(addEssentialsApiResult: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (_) async {
        await fetchChildFromFirestore(refVal: state.childModel?.reference);
      },
    );
  }

  Future<void> deleteEssentialNote({required int index}) async {
    final String? childId = state.childModel?.reference?.id;
    final EssentialNote? note = state.childModel?.essentials?[index];
    if ((childId ?? "").isEmpty || note == null) {
      changeProps(
        addEssentialsApiResult: ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        ),
      );
      return;
    }
    changeProps(addEssentialsApiResult: ApiResultStatus.loading());
    final ApiResultStatus apiResultStatus = await ChildRepo.instance
        .deleteEssential(
          documentReference: childId,
          request: <String, FieldValue>{
            'essentials': FieldValue.arrayRemove(<Map<String, dynamic>>[
              note.toJson(),
            ]),
          },
        );
    changeProps(addEssentialsApiResult: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (_) async {
        await fetchChildFromFirestore(refVal: state.childModel?.reference);
      },
    );
  }

  Future<void> deleteDocument({required int index}) async {
    final String? childId = state.childModel?.reference?.id;
    final String fileUrl = state.childModel?.documents?[index] ?? "";
    if ((childId ?? "").isEmpty || fileUrl.isEmpty) {
      changeProps(
        uploadDocumentApiResultStatus: ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        ),
      );
      return;
    }
    changeProps(uploadDocumentApiResultStatus: ApiResultStatus.loading());

    final ApiResultStatus deleteFileApiResult = await ChildRepo.instance
        .deleteFileFromFirebaseStorage(fileUrl: fileUrl);
    bool deleteFileSuccess = false;
    deleteFileApiResult.whenOrNull(data: (_) => deleteFileSuccess = true);
    if (!deleteFileSuccess) {
      changeProps(uploadDocumentApiResultStatus: deleteFileApiResult);
      return;
    }

    final ApiResultStatus apiResultStatus = await ChildRepo.instance
        .deleteDocument(
          documentReference: childId,
          request: <String, FieldValue>{
            'documents': FieldValue.arrayRemove(<String>[fileUrl]),
          },
        );
    changeProps(uploadDocumentApiResultStatus: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (_) async {
        await fetchChildFromFirestore(refVal: state.childModel?.reference);
      },
    );
  }

  Future<void> uploadToFirebaseStorage(String? fileLocalPath) async {
    if (fileLocalPath == null) return;
    changeProps(uploadDocumentApiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus uploadedFilePath = await ChildRepo.instance
        .uploadFileToFirebaseStorage(
          file: File(fileLocalPath),
          referenceId: state.userModel?.uid,
        );
    uploadedFilePath.whenOrNull(
      data: (dynamic data) async {
        if (data is String && data.isNotEmpty) {
          final ApiResultStatus updateApiResult = await _updateDocuments(data);
          changeProps(uploadDocumentApiResultStatus: updateApiResult);
          updateApiResult.whenOrNull(
            data: (_) async {
              await fetchChildFromFirestore(
                refVal: state.childModel?.reference,
              );
            },
          );
          return;
        }
        changeProps(
          uploadDocumentApiResultStatus: ApiResultStatus.error(
            error: Exception(LocaleKeys.somethingWentWrong.tr()),
          ),
        );
      },
      error: (dynamic error) {
        changeProps(
          uploadDocumentApiResultStatus: ApiResultStatus.error(error: error),
        );
      },
    );
  }

  Future<ApiResultStatus> _updateDocuments(String fileNetworkUrl) async {
    final String? childId = state.childModel?.reference?.id;
    if ((childId ?? "").isEmpty) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.pleaseSelectChild.tr()),
      );
    }
    return ChildRepo.instance.updateDocuments(
      documentReference: childId,
      request: <String, FieldValue>{
        'documents': FieldValue.arrayUnion(<String>[fileNetworkUrl]),
      },
    );
  }

  Future<void> loadChildren() async {
    changeProps(
      childrenListApiResult: ApiResultStatus.loading(),
      children: <ChildModel>[],
    );
    if (state.userModel == null) {
      changeProps(
        childrenListApiResult: ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        ),
      );
      return;
    }
    final ApiResultStatus childrenListApiResult = await ChildRepo.instance
        .getAllChildren(state.userModel!);
    childrenListApiResult.whenOrNull(
      data: (dynamic data) {
        if (data is List<ChildModel>) {
          changeProps(
            childrenListApiResult: ApiResultStatus.data(data: data),
            children: data,
            childModel: data.isNotEmpty ? data.first : state.childModel,
          );
        }
      },
      error: (dynamic error) {
        changeProps(
          childrenListApiResult: ApiResultStatus.error(
            error: Exception(LocaleKeys.somethingWentWrong.tr()),
          ),
        );
      },
    );
  }
}
