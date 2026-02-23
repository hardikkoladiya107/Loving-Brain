import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';
import '../model/invitation_model.dart';
import 'child_repo.dart';

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

  Future<ApiResultStatus> addProposeToSharedEvent({
    required String docId,
    required Map<String, dynamic> request,
  }) async {
    try {
      await sharedEventCollection.doc(docId).update({
        "propose": FieldValue.arrayUnion([request]),
      });
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

  Future<ApiResultStatus> updateSharedEvent({
    required String documentReference,
    required Map<String, dynamic> request,
  }) async {
    try {
      var eventCollection = await sharedEventCollection
          .doc(documentReference)
          .update(request);
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

  Stream<DocumentSnapshot> getSingleSharedEvent(String documentId) {
    return sharedEventCollection.doc(documentId).snapshots();
  }

  Future<ApiResultStatus> deleteSharedEvent({
    required String documentId,
  }) async {
    try {
      await sharedEventCollection.doc(documentId).delete();
      return ApiResultStatus.data(data: '');
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
    required InvitationModel invitationModel,
  }) async {
    try {
      await coParentInvitationCollection.doc(referenceId).update(request);
      return ApiResultStatus.data(data: invitationModel);
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
      final response = await coParentInvitationCollection
          .doc(invitationReferenceId)
          .get();
      final Map<String, dynamic>? data = response.data();
      if (data == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.thisInvitationIsNotForYou.tr()),
        );
      }
      final InvitationModel invitationModel = InvitationModel.fromJson(data);
      final UserModel? userModel = preferences.getUserModel();
      if (userModel?.email != invitationModel.toParent ||
          invitationModel.status != "REQUESTED") {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.thisInvitationIsNotForYou.tr()),
        );
      }
      final ApiResultStatus updateResult = await updateInvitation(
        referenceId: invitationReferenceId,
        request: {"status": "ACCEPTED"},
        invitationModel: invitationModel,
      );
      final String? parentUid = userModel!.uid;
      if (parentUid != null && parentUid.isNotEmpty) {
        final String? childrenStr = invitationModel.children;
        if (childrenStr != null && childrenStr.trim().isNotEmpty) {
          final List<String> childIds = childrenStr
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          for (final String childId in childIds) {
            await ChildRepo.instance.addParentReference(
              childId: childId,
              parentUid: parentUid,
            );
          }
        }
      }
      return updateResult;
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
