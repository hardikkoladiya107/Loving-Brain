import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/invitation_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:mime/mime.dart';

import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';
import '../model/routine_category_model.dart';

class ChildRepo {
  ChildRepo._();

  static final ChildRepo _instance = ChildRepo._();

  factory ChildRepo() {
    return _instance;
  }

  static ChildRepo get instance => _instance;

  var routineTypeCollection = FirebaseFirestore.instance.collection(
    'routine_type',
  );

  var childrenCollection = FirebaseFirestore.instance.collection('children');

  Future<ApiResultStatus> getAllRoutineCategories() async {
    try {
      var behaviours = await routineTypeCollection.get();
      if (behaviours.docs.isNotEmpty) {
        return ApiResultStatus.data(
          data: behaviours.docs
              .map((e) => RoutineCategoryModel.fromJson(e))
              .toList(),
        );
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
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

  Future<ApiResultStatus> addRoutine({
    required String? id,
    required Map<String, dynamic> request,
  }) async {
    if (id == null || id.isEmpty) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.pleaseSelectChild.tr()),
      );
    }
    try {
      await childrenCollection.doc(id).update({
        "routines": FieldValue.arrayUnion([request]),
      });
      return ApiResultStatus.data(data: "");
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> removeRoutine({
    required String? id,
    required Map<String, dynamic> request,
  }) async {
    try {
      await childrenCollection.doc(id).update({
        "routines": FieldValue.arrayRemove([request]),
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

  Future<ApiResultStatus> addEssential({
    required String? id,
    required Map<String, dynamic> request,
  }) async {
    try {
      await childrenCollection.doc(id).update({
        "essentials": FieldValue.arrayUnion([request]),
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

  Future<ApiResultStatus> removeEssential({
    required String? id,
    required Map<String, dynamic> request,
  }) async {
    try {
      await childrenCollection.doc(id).update({
        "essentials": FieldValue.arrayRemove([request]),
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

  Future<ApiResultStatus> getChildren({
    required List<String> childrenIds,
  }) async {
    try {
      var childrenResponse = await childrenCollection
          .where(FieldPath.documentId, whereIn: childrenIds)
          .get();
      if (childrenResponse.docs.isNotEmpty) {
        return ApiResultStatus.data(
          data: childrenResponse.docs
              .map((e) => ChildModel.fromJson(e.data(), e.reference))
              .toList(),
        );
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.childrenNotFound.tr()),
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
  // 👈 add this to pubspec.yaml

  Future<ApiResultStatus> uploadFileToFirebaseStorage({
    required io.File file,
    required String? referenceId,
  }) async {
    try {
      final fileName = file.path.split("/").last;
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final ref = FirebaseStorage.instance
          .ref()
          .child('essential-documents')
          .child(referenceId ?? "TEST")
          .child(fileName);

      final metadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {
          'picked-file-path': file.path,
          // 'reference-id': referenceId ?? 'TEST',
          // 'file-name': fileName,
          // 'upload-timestamp': DateTime.now().toIso8601String(),
          // 'mime-type': mimeType,
        },
      );

      final uploadTask = ref.putFile(file, metadata);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();

      return ApiResultStatus.data(data: downloadUrl);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> deleteFileFromFirebaseStorage({
    required String fileUrl,
  }) async {
    try {
      // Create a reference from the full URL
      final ref = FirebaseStorage.instance.refFromURL(fileUrl);

      // Delete the file
      await ref.delete();

      return ApiResultStatus.data(data: "File deleted successfully");
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> updateDocuments({
    String? documentReference,
    required Map<String, FieldValue> request,
  }) async {
    try {
      var eventCollection = await childrenCollection
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

  Future<ApiResultStatus> updateEssentials({
    String? documentReference,
    required Map<String, dynamic> request,
  }) async {
    try {
      var eventCollection = await childrenCollection
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

  Future<ApiResultStatus> deleteEssential({
    String? documentReference,
    required Map<String, FieldValue> request,
  }) async {
    try {
      var eventCollection = await childrenCollection
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

  Future<ApiResultStatus> deleteDocument({
    String? documentReference,
    required Map<String, FieldValue> request,
  }) async {
    try {
      var eventCollection = await childrenCollection
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

  Future<ApiResultStatus<List<ChildModel>>> getAllChildren(
    UserModel user,
  ) async {
    try {
      // 1️⃣ Fetch both child lists
      ApiResultStatus childApiResultStatus = await getChildren(
        childrenIds: user.children?.map((e) => e.id).toList() ?? [],
      );

      ApiResultStatus coChildApiResultStatus = await getCoChildren(user);

      // 2️⃣ Extract data from both (if available)
      final List<ChildModel> children = [];
      childApiResultStatus.whenOrNull(
        data: (data) {
          children.addAll(data);
        },
      );
      coChildApiResultStatus.whenOrNull(
        data: (data) {
          children.addAll(data);
        },
      );

      // 3️⃣ Return merged result
      if (children.isNotEmpty) {
        return ApiResultStatus.data(data: children);
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.childrenNotFound.tr()),
        );
      }
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> getCoChildren(UserModel user) async {
    try {
      var childrenResponse = await CoParentRepo
          .instance
          .coParentInvitationCollection
          .where('to_parent', isEqualTo: user.email)
          .where('childs_essentials', isEqualTo: true)
          .where('status', isEqualTo: 'ACCEPTED')
          .get();

      if (childrenResponse.docs.isNotEmpty) {
        List<InvitationModel> invitations = childrenResponse.docs
            .map((doc) => InvitationModel.fromJson(doc.data()))
            .toList();

        return getChildren(
          childrenIds: invitations
              .map((e) => e.children ?? "")
              .toList()
              .where((element) => element.isNotEmpty)
              .toList(),
        );
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.childrenNotFound.tr()),
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
}
