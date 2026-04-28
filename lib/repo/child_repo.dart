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
    } on FirebaseException {
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
    } on FirebaseException {
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
    } on FirebaseException {
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
    } on FirebaseException {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  /// Appends a parent uid to the child's [parent_reference_ids] list.
  /// Use when a co-parent accepts an invitation for this child.
  Future<ApiResultStatus> addParentReference({
    required String childId,
    required String parentUid,
  }) async {
    try {
      if (childId.isEmpty || parentUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      await childrenCollection.doc(childId).update({
        'parent_reference_ids': FieldValue.arrayUnion([parentUid]),
      });
      return ApiResultStatus.data(data: '');
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

  Future<ApiResultStatus<List<ChildModel>>> getChildren({
    required List<String> childrenIds,
  }) async {
    try {
      if (childrenIds.isEmpty) {
        return ApiResultStatus.data(data: <ChildModel>[]);
      }
      var childrenResponse = await childrenCollection
          .where(FieldPath.documentId, whereIn: childrenIds)
          .get();
      if (childrenResponse.docs.isNotEmpty) {
        return ApiResultStatus.data(
          data: childrenResponse.docs
              .map((e) => ChildModel.fromJson(e.data(), e.reference))
              .toList(),
        );
      }
      return ApiResultStatus.data(data: <ChildModel>[]);
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
      await childrenCollection.doc(documentReference).update(request);
      return ApiResultStatus.data(data: "");
    } on FirebaseException {
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
      await childrenCollection.doc(documentReference).update(request);
      return ApiResultStatus.data(data: "");
    } on FirebaseException {
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
      await childrenCollection.doc(documentReference).update(request);
      return ApiResultStatus.data(data: "");
    } on FirebaseException {
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
      await childrenCollection.doc(documentReference).update(request);
      return ApiResultStatus.data(data: "");
    } on FirebaseException {
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
      final List<String> ownChildIds =
          user.children?.map((e) => e.id).whereType<String>().toList() ?? [];
      final ApiResultStatus<List<ChildModel>> childApiResultStatus =
          await getChildren(childrenIds: ownChildIds);

      final List<ChildModel> children = [];
      childApiResultStatus.whenOrNull(
        data: (List<ChildModel> data) {
          children.addAll(data);
        },
      );

      final ApiResultStatus<List<ChildModel>> coChildApiResultStatus =
          await getCoChildren(user);
      coChildApiResultStatus.whenOrNull(
        data: (List<ChildModel> data) {
          children.addAll(data);
        },
      );

      return ApiResultStatus.data(data: children);
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

  Future<ApiResultStatus<List<ChildModel>>> getCoChildren(
    UserModel user,
  ) async {
    try {
      var childrenResponse = await CoParentRepo
          .instance
          .coParentInvitationCollection
          .where('to_parent', isEqualTo: user.email)
          .where('childs_essentials', isEqualTo: true)
          .where('status', isEqualTo: 'ACCEPTED')
          .get();

      if (childrenResponse.docs.isEmpty) {
        return ApiResultStatus.data(data: <ChildModel>[]);
      }
      final List<InvitationModel> invitations = childrenResponse.docs
          .map((doc) => InvitationModel.fromJson(doc.data()))
          .toList();
      final Set<String> childIds = <String>{};
      for (final InvitationModel inv in invitations) {
        final String raw = (inv.children ?? "").trim();
        if (raw.isEmpty) continue;
        for (final String part in raw.split(',')) {
          final String id = part.trim();
          if (id.isNotEmpty) childIds.add(id);
        }
      }
      return getChildren(childrenIds: childIds.toList());
    } on FirebaseException {
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
