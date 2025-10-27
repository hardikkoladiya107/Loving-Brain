import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/essential_model.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/child_repo.dart';
import 'essentials_state.dart';

class EssentialsCubit extends Cubit<EssentialsState> {
  EssentialsCubit() : super(EssentialsState());

  void init() {
    emit(EssentialsState(userModel: preferences.getUserModel()));
    _listenToChild();
  }

  void changeProps({
    ChildModel? childModel,
    UserModel? userModel,
    ApiResultStatus? addEssentialsApiResult,
    ApiResultStatus? uploadDocumentApiResultStatus,
    String? titleError,
    String? descriptionError,

    List<String>? documentsList,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        addEssentialsApiResult:
            addEssentialsApiResult ?? ApiResultStatus.initial(),
        uploadDocumentApiResultStatus:
            uploadDocumentApiResultStatus ?? ApiResultStatus.initial(),
        titleError: titleError ?? "",
        descriptionError: descriptionError ?? "",
        documentsList: documentsList ?? state.documentsList,
      ),
    );
  }

  StreamSubscription? sharedEventStreamSubscription;

  void _listenToChild() {
    if (state.userModel?.defaultChild != null) {
      sharedEventStreamSubscription?.cancel();
      sharedEventStreamSubscription = state.userModel?.defaultChild!
          .snapshots()
          .listen((event) {
            if (event.data() != null) {
              changeProps(
                childModel: ChildModel.fromJson(
                  event.data() as Map<String, dynamic>,
                  event.reference,
                ),
              );
            }
          });
    }
  }

  bool isValidate({required String title, required String description}) {
    if (title.isEmpty) {
      changeProps(
        addEssentialsApiResult: ApiResultStatus.initial(),
        titleError: "Please provide title",
      );
      return false;
    }
    if (description.isEmpty) {
      changeProps(
        addEssentialsApiResult: ApiResultStatus.initial(),
        descriptionError: "Please provide description",
      );
      return false;
    }
    return true;
  }

  Future<void> addEssentialNote({
    required String title,
    required String description,
  }) async {
    if (!isValidate(title: title, description: description)) return;
    changeProps(addEssentialsApiResult: ApiResultStatus.loading());
    var apiResultStatus = await ChildRepo.instance.addEssential(
      request: {"title": title, "description": description},
      id: state.userModel?.defaultChild?.id,
    );
    changeProps(addEssentialsApiResult: apiResultStatus);
  }

  Future<void> editEssentialNote(
    int index, {
    required String title,
    required String description,
  }) async {
    if (!isValidate(title: title, description: description)) return;
    changeProps(addEssentialsApiResult: ApiResultStatus.loading());

    List<EssentialNote>? note = [];
    note.addAll(state.childModel?.essentials ?? []);
    note[index].title = title;
    note[index].description = description;
    List<dynamic> data = note.map((e) => e.toJson()).toList();
    var apiResultStatus = await ChildRepo.instance.updateEssentials(
      documentReference: state.childModel?.reference!.id,
      request: {'essentials': data},
    );
    changeProps(addEssentialsApiResult: apiResultStatus);
  }

  Future<void> deleteEssentialNote({required int index}) async {
    changeProps(addEssentialsApiResult: ApiResultStatus.loading());
    var apiResultStatus = await ChildRepo.instance.deleteEssential(
      documentReference: state.childModel?.reference!.id,
      request: {
        'essentials': FieldValue.arrayRemove([
          state.childModel?.essentials?[index].toJson(),
        ]),
      },
    );
    changeProps(addEssentialsApiResult: ApiResultStatus.initial());
  }

  Future<void> deleteDocument({required int index}) async {
    changeProps(uploadDocumentApiResultStatus: ApiResultStatus.loading());
    ChildRepo.instance.deleteFileFromFirebaseStorage(
      fileUrl: state.childModel?.documents?[index] ?? "",
    );
    var apiResultStatus = await ChildRepo.instance.deleteDocument(
      documentReference: state.childModel?.reference!.id,
      request: {
        'documents': FieldValue.arrayRemove([
          state.childModel?.documents?[index],
        ]),
      },
    );
    changeProps(uploadDocumentApiResultStatus: apiResultStatus);
  }

  Future<void> uploadToFirebaseStorage(String? fileLocalPath) async {
    if (fileLocalPath != null) {
      changeProps(uploadDocumentApiResultStatus: ApiResultStatus.loading());
      var uploadedFilePath = await ChildRepo.instance
          .uploadFileToFirebaseStorage(
            file: File(fileLocalPath),
            referenceId: state.userModel?.uid,
          );
      uploadedFilePath.whenOrNull(
        data: (data) async {
          changeProps(
            uploadDocumentApiResultStatus: ApiResultStatus.data(data: ""),
          );
          if (data is String) {
            _updateDocuments(data);
            // List<String> documentsList = [];
            // documentsList.addAll(state.documentsList);
            // documentsList.add(data);
            // changeProps(documentsList: documentsList);
          }
        },
        error: (error) {
          changeProps(
            uploadDocumentApiResultStatus: ApiResultStatus.error(error: error),
          );
        },
      );
    }
  }

  Future<void> _updateDocuments(String fileNetworkUrl) async {
    if (state.childModel?.reference?.id != null) {
      await ChildRepo.instance.updateDocuments(
        documentReference: state.childModel?.reference!.id,
        request: {
          'documents': FieldValue.arrayUnion([fileNetworkUrl]),
        },
      );
    }
  }
}
