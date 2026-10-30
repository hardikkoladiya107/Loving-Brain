import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/invitation_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';
import 'package:loving_brain/other/preferances.dart';

import '../generated/locale_keys.g.dart';
import 'auth_repo.dart';

class CoParentRepo {
  CoParentRepo._();

  static final CoParentRepo _instance = CoParentRepo._();

  factory CoParentRepo() {
    return _instance;
  }

  static CoParentRepo get instance => _instance;

  CollectionReference<Map<String, dynamic>> get sharedEventCollection =>
      FirebaseFirestore.instance.collection('shared_event');

  CollectionReference<Map<String, dynamic>> get coParentInvitationCollection =>
      FirebaseFirestore.instance.collection('co-parent-invitation');

  CollectionReference<Map<String, dynamic>> get userCollection =>
      FirebaseFirestore.instance.collection('users');

  Future<ApiResultStatus> addSharedEvent({
    required Map<String, dynamic> request,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> eventDoc =
          await sharedEventCollection.add(request);
      return ApiResultStatus.data(data: eventDoc.id);
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

  Future<ApiResultStatus> addProposeToSharedEvent({
    required String docId,
    required Map<String, dynamic> request,
  }) async {
    try {
      await sharedEventCollection.doc(docId).update(<String, dynamic>{
        'propose': FieldValue.arrayUnion(<dynamic>[request]),
      });
      return ApiResultStatus.data(data: '');
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

  Future<ApiResultStatus> updateSharedEvent({
    required String documentReference,
    required Map<String, dynamic> request,
  }) async {
    try {
      await sharedEventCollection.doc(documentReference).update(request);
      return ApiResultStatus.data(data: '');
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

  ApiResultStatus _mapFunctionsError(Object e) {
    if (e is FirebaseFunctionsException) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    }
    return ApiResultStatus.error(
      error: Exception(LocaleKeys.somethingWentWrong.tr()),
    );
  }

  /// Creates invitation via Cloud Function (email + optional FCM).
  Future<ApiResultStatus> createInvitation({
    required String toEmail,
    required String role,
    required List<String> childIds,
    String? fromParentName,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'createCoParentInvitation',
      );
      final HttpsCallableResult<dynamic> response = await callable
          .call<dynamic>(<String, dynamic>{
            'toEmail': toEmail.trim().toLowerCase(),
            'role': role.trim(),
            'childIds': childIds,
            if (fromParentName != null) 'fromParentName': fromParentName.trim(),
          });
      final dynamic data = response.data;
      if (data is Map) {
        return ApiResultStatus.data(
          data: <String, dynamic>{
            'invitationId': data['invitationId']?.toString() ?? '',
            'emailSent': data['emailSent'] == true,
          },
        );
      }
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus> getInvitationPreview({
    required String invitationId,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getInvitationPreview',
      );
      final HttpsCallableResult<dynamic> response = await callable
          .call<dynamic>(<String, dynamic>{
            'invitationId': invitationId.trim(),
          });
      final dynamic data = response.data;
      if (data is Map) {
        return ApiResultStatus.data(data: Map<String, dynamic>.from(data));
      }
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus> sendInvitationEmail({
    required String toEmail,
    required String fromParentName,
    required String childrenNames,
    required String invitationId,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'resendInvitationEmail',
      );
      final HttpsCallableResult<dynamic> response = await callable
          .call<dynamic>(<String, dynamic>{
            'invitationId': invitationId.trim(),
          });
      final dynamic data = response.data;
      if (data is Map && data['success'] == true) {
        return const ApiResultStatus.data(data: 'Email sent');
      }
      return const ApiResultStatus.data(data: 'Email sent');
    } catch (e) {
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus> cancelInvitation({
    required String invitationId,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'cancelInvitation',
      );
      await callable.call<dynamic>(<String, dynamic>{
        'invitationId': invitationId.trim(),
      });
      return const ApiResultStatus.data(data: 'cancelled');
    } catch (e) {
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus> rejectInvitation({
    required String invitationId,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'rejectInvitation',
      );
      await callable.call<dynamic>(<String, dynamic>{
        'invitationId': invitationId.trim(),
      });
      return const ApiResultStatus.data(data: 'rejected');
    } catch (e) {
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus> deleteInvitation({
    required String invitationId,
  }) async {
    return cancelInvitation(invitationId: invitationId);
  }

  Future<ApiResultStatus> updateInvitation({
    required String referenceId,
    required Map<String, dynamic> request,
    required InvitationModel invitationModel,
  }) async {
    return ApiResultStatus.error(
      error: Exception('Invitation updates must go through Cloud Functions.'),
    );
  }

  /// Accepts a co-parent invitation via Cloud Function.
  Future<ApiResultStatus> addUserAsCoParent(
    String invitationReferenceId,
  ) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'acceptInvitation',
      );
      final HttpsCallableResult<dynamic> response = await callable
          .call<dynamic>(<String, dynamic>{
            'invitationId': invitationReferenceId.trim(),
          });

      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null && uid.isNotEmpty) {
        final UserModel? updated = await AuthRepo.instance
            .syncUserAndDefaultChild(uId: uid);
        if (updated != null) {
          await preferences.saveUserModel(updated);
        }
      }

      final dynamic data = response.data;
      final InvitationModel model = InvitationModel(
        status: CoParentInvitationHelpers.statusAccepted,
        children: data is Map && data['childIds'] is List
            ? (data['childIds'] as List<dynamic>).join(',')
            : null,
      );
      return ApiResultStatus.data(data: model);
    } catch (e) {
      debugPrint('Exception accepting invitation: $e');
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus> leaveChildFamily({
    required String childId,
    required String userUid,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'leaveChild',
      );
      await callable.call<dynamic>(<String, dynamic>{
        'childId': childId.trim(),
      });
      final UserModel? updatedUser = await AuthRepo.instance
          .syncUserAndDefaultChild(uId: userUid);
      if (updatedUser != null) {
        await preferences.saveUserModel(updatedUser);
      }
      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus> revokeCaregiver({
    required String childId,
    required String targetUid,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'revokeCaregiver',
      );
      await callable.call<dynamic>(<String, dynamic>{
        'childId': childId.trim(),
        'targetUid': targetUid.trim(),
      });
      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus> removeChild({required String childId}) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'removeChild',
      );
      await callable.call<dynamic>(<String, dynamic>{
        'childId': childId.trim(),
      });
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null && uid.isNotEmpty) {
        await AuthRepo.instance.syncUserAndDefaultChild(uId: uid);
      }
      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus> deleteMyAccount() async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'deleteMyAccount',
      );
      await callable.call<dynamic>(<String, dynamic>{});
      return const ApiResultStatus.data(data: '');
    } catch (e) {
      return _mapFunctionsError(e);
    }
  }

  Future<ApiResultStatus<List<Map<String, dynamic>>>> getPendingInvitations({
    required String fromEmail,
  }) async {
    try {
      final String? uid =
          FirebaseAuth.instance.currentUser?.uid ??
          preferences.getUserModel()?.uid;
      if (uid == null || uid.isEmpty) {
        return ApiResultStatus.data(data: <Map<String, dynamic>>[]);
      }
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await coParentInvitationCollection
              .where('from_uid', isEqualTo: uid)
              .where('status', isEqualTo: 'REQUESTED')
              .get();

      final List<Map<String, dynamic>> pending = <Map<String, dynamic>>[];
      final DateTime now = DateTime.now();
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        final Map<String, dynamic> data = doc.data();
        final String? expiresAtRaw = data['expires_at']?.toString();
        if (expiresAtRaw != null && expiresAtRaw.isNotEmpty) {
          final DateTime? expires = DateTime.tryParse(expiresAtRaw);
          if (expires != null && expires.isBefore(now)) {
            continue;
          }
        }
        pending.add(<String, dynamic>{'id': doc.id, ...data});
      }
      return ApiResultStatus.data(data: pending);
    } on FirebaseException {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<List<Map<String, dynamic>>> getIncomingPendingInvitations() async {
    try {
      final String? uid =
          FirebaseAuth.instance.currentUser?.uid ??
          preferences.getUserModel()?.uid;
      if (uid == null || uid.isEmpty) return <Map<String, dynamic>>[];
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await coParentInvitationCollection
              .where('to_uid', isEqualTo: uid)
              .where('status', isEqualTo: 'REQUESTED')
              .get();
      final DateTime now = DateTime.now();
      final List<Map<String, dynamic>> list = <Map<String, dynamic>>[];
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        final Map<String, dynamic> data = doc.data();
        final String? expiresAtRaw = data['expires_at']?.toString();
        if (expiresAtRaw != null && expiresAtRaw.isNotEmpty) {
          final DateTime? expires = DateTime.tryParse(expiresAtRaw);
          if (expires != null && expires.isBefore(now)) continue;
        }
        list.add(<String, dynamic>{'id': doc.id, ...data});
      }
      return list;
    } catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  Future<String?> checkPendingInvitationForUser(String email) async {
    try {
      final String cleanEmail = email.trim().toLowerCase();
      if (cleanEmail.isEmpty) return null;
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await coParentInvitationCollection
              .where('to_parent', isEqualTo: cleanEmail)
              .where('status', isEqualTo: 'REQUESTED')
              .get();
      final DateTime now = DateTime.now();
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        final Map<String, dynamic> data = doc.data();
        final String? expiresAtRaw = data['expires_at']?.toString();
        if (expiresAtRaw != null && expiresAtRaw.isNotEmpty) {
          final DateTime? expires = DateTime.tryParse(expiresAtRaw);
          if (expires != null && expires.isBefore(now)) continue;
        }
        return doc.id;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<ApiResultStatus> getMyCoParents() async {
    try {
      final UserModel? currentUserModel = preferences.getUserModel();
      final List<String> linked = currentUserModel?.linkedUserIds ?? <String>[];
      if (linked.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.coParentNotFound.tr()),
        );
      }
      final List<String> limited = linked.take(10).toList();
      final QuerySnapshot<Map<String, dynamic>> userResponse =
          await userCollection.where('uid', whereIn: limited).get();
      if (userResponse.docs.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.coParentNotFound.tr()),
        );
      }
      return ApiResultStatus.data(
        data: userResponse.docs
            .map(
              (QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                  UserModel.fromJson(e.data()),
            )
            .toList(),
      );
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
    required io.File file,
    required String? referenceId,
  }) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('shared-event-documents')
          .child(referenceId ?? 'TEST')
          .child('/${file.path.split("/").last}');
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/${file.path.split(".").last}',
        customMetadata: <String, String>{'picked-file-path': file.path},
      );
      final UploadTask uploadTask = ref.putFile(io.File(file.path), metadata);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return ApiResultStatus.data(data: downloadUrl);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }
}
