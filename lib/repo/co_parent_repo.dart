import 'dart:io';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';
import '../model/invitation_model.dart';
import 'auth_repo.dart';

class CoParentRepo {
  CoParentRepo._();

  static final CoParentRepo _instance = CoParentRepo._();

  factory CoParentRepo() {
    return _instance;
  }

  static CoParentRepo get instance => _instance;

  var sharedEventCollection = FirebaseFirestore.instance.collection(
    'shared_event',
  );

  var coParentInvitationCollection = FirebaseFirestore.instance.collection(
    'co-parent-invitation',
  );

  var userCollection = FirebaseFirestore.instance.collection('users');

  Future<ApiResultStatus> addSharedEvent({
    required Map<String, dynamic> request,
  }) async {
    try {
      var eventCollection = await sharedEventCollection.add(request);
      return ApiResultStatus.data(data: eventCollection.id);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Stream<QuerySnapshot> sharedEventListener() {
    return sharedEventCollection.snapshots();
  }

  Stream<DocumentSnapshot> getSingleSharedEvent(String documentId) {
    return sharedEventCollection.doc(documentId).snapshots();
  }

  Future<ApiResultStatus> createInvitation({
    required Map<String, dynamic> request,
  }) async {
    try {
      var invitationCollectionResult = await coParentInvitationCollection.add(
        request,
      );
      return ApiResultStatus.data(data: invitationCollectionResult.id);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> updateInvitation({
    required String referenceId,
    required Map<String, dynamic> request,
  }) async {
    try {
      await coParentInvitationCollection.doc(referenceId).update(request);
      return ApiResultStatus.data(data: "");
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> addUserAsCoParent(
    String invitationReferenceId,
  ) async {
    try {
      var response = await coParentInvitationCollection
          .doc(invitationReferenceId)
          .get();
      var invitationModel = InvitationModel.fromJson(response.data());
      var userModel = preferences.getUserModel();
      if (userModel?.email == invitationModel.toParent &&
          invitationModel.status == "REQUESTED") {
        return updateInvitation(
          referenceId: invitationReferenceId,
          request: {"status": "ACCEPTED"},
        );
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.thisInvitationIsNotForYou.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> getMyCoParents() async {
    try {
      var currentUserModel = preferences.getUserModel();
      var coParentInvitationResponse = await coParentInvitationCollection
          .where("from_parent", isEqualTo: currentUserModel?.email ?? "")
          .where("status", isEqualTo: "ACCEPTED")
          .get();
      if (coParentInvitationResponse.docs.isNotEmpty) {
        var invitationList = coParentInvitationResponse.docs
            .map((e) => InvitationModel.fromJson(e.data()))
            .toList();
        var userResponse = await userCollection
            .where("email", whereIn: invitationList.map((e) => e.toParent))
            .get();
        return ApiResultStatus.data(
          data: userResponse.docs
              .map((e) => UserModel.fromJson(e.data()))
              .toList(),
        );
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.coParentNotFound.tr()),
        );
      }
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }


  Future<ApiResultStatus> uploadFileToFirebaseStorage({
    required File file,
    required String? referenceId,
  }) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('shared-event-documents')
          .child(referenceId ?? "TEST")
          .child('/${file.path.split("/").last}');
      final metadata = SettableMetadata(
        contentType: 'image/${file.path.split(".").last}',
        customMetadata: {'picked-file-path': file.path},
      );
      var uploadTask = ref.putFile(io.File(file.path), metadata);
      return ApiResultStatus.data(data: await Future.value(uploadTask));
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }



}

