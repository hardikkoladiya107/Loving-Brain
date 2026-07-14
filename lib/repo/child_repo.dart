import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/invitation_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/energy_bridge_notification_helper.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/repo/energy_bridge_repo.dart';
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

  /// Writes denormalized `child_state` on the child doc and an audit row under
  /// `children/{id}/states/{timestamp}_{key}` for co-parent real-time sync.
  Future<ApiResultStatus> updateChildState({
    required String childId,
    required ChildState childState,
    required String actorUid,
  }) async {
    try {
      if (childId.isEmpty || actorUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }

      final DateTime now = DateTime.now();
      final DocumentReference<Map<String, dynamic>> childRef =
          childrenCollection.doc(childId);
      final DocumentReference<Map<String, dynamic>> stateRef = childRef
          .collection('states')
          .doc('${now.microsecondsSinceEpoch}_${childState.key}');
      final WriteBatch writeBatch = FirebaseFirestore.instance.batch();

      writeBatch.update(childRef, <String, dynamic>{
        'child_state': childState.key,
        'state_updated_at': Timestamp.fromDate(now),
      });
      writeBatch.set(stateRef, <String, dynamic>{
        'state_id': childState.key,
        'time_stamp': Timestamp.fromDate(now),
        'updated_by': actorUid,
      });

      await writeBatch.commit();
      return ApiResultStatus.data(data: childState.key);
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

  Future<ApiResultStatus> saveSmartMomentEvent({
    required String childId,
    required String actorUid,
    required String stateAtTime,
    required int ageInMonths,
  }) async {
    try {
      if (childId.isEmpty || actorUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      await childrenCollection
          .doc(childId)
          .collection('events')
          .add(<String, dynamic>{
            'child_id': childId,
            'type': 'smart_moment',
            'state_at_time': stateAtTime,
            'age_in_months': ageInMonths,
            'outcome': 'success',
            'timestamp': Timestamp.now(),
            'updated_by': actorUid,
          });
      return ApiResultStatus.data(data: childId);
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

  Future<ApiResultStatus> saveHelpFlowEvent({
    required String childId,
    required String actorUid,
    required String problemType,
    required String solutionId,
    required String childState,
    required int ageInMonths,
  }) async {
    try {
      if (childId.isEmpty || actorUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      await childrenCollection
          .doc(childId)
          .collection('events')
          .add(<String, dynamic>{
            'type': 'help_flow',
            'problem_type': problemType,
            'solution_id': solutionId,
            'outcome': 'success',
            'child_state': childState,
            'age_in_months': ageInMonths,
            'timestamp': Timestamp.now(),
            'updated_by': actorUid,
          });
      return ApiResultStatus.data(data: childId);
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

  Future<bool> isSleepInProgress({required String childId}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snap =
          await childrenCollection.doc(childId).get();
      return snap.data()?['sleep_in_progress'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResultStatus> recordFeed({
    required String childId,
    required String actorUid,
  }) async {
    try {
      if (childId.isEmpty || actorUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final DateTime now = DateTime.now();
      await childrenCollection.doc(childId).update(<String, dynamic>{
        'last_feed_time': Timestamp.fromDate(now),
      });
      await childrenCollection.doc(childId).collection('events').add(
        <String, dynamic>{
          'type': 'feed',
          'child_id': childId,
          'timestamp': Timestamp.fromDate(now),
          'updated_by': actorUid,
        },
      );
      final ApiResultStatus resetResult = await EnergyBridgeRepo.instance
          .resetTimer(childId: childId, actorUid: actorUid, reason: 'feed');
      resetResult.whenOrNull(
        data: (_) async {
          await EnergyBridgeNotificationHelper.cancelForChild(childId);
        },
      );
      return ApiResultStatus.data(data: childId);
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

  Future<ApiResultStatus> startSleep({
    required String childId,
    required String actorUid,
  }) async {
    try {
      if (childId.isEmpty || actorUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final DateTime now = DateTime.now();
      final ApiResultStatus stateResult = await updateChildState(
        childId: childId,
        childState: ChildState.tired,
        actorUid: actorUid,
      );
      bool stateSaved = false;
      stateResult.whenOrNull(data: (_) => stateSaved = true);
      if (!stateSaved) {
        return stateResult;
      }
      await childrenCollection.doc(childId).update(<String, dynamic>{
        'sleep_in_progress': true,
        'sleep_started_at': Timestamp.fromDate(now),
      });
      await childrenCollection.doc(childId).collection('events').add(
        <String, dynamic>{
          'type': 'sleep_start',
          'child_id': childId,
          'timestamp': Timestamp.fromDate(now),
          'updated_by': actorUid,
        },
      );
      final ApiResultStatus resetResult = await EnergyBridgeRepo.instance
          .resetTimer(childId: childId, actorUid: actorUid, reason: 'sleep');
      resetResult.whenOrNull(
        data: (_) async {
          await EnergyBridgeNotificationHelper.cancelForChild(childId);
        },
      );
      return ApiResultStatus.data(data: childId);
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

  Future<ApiResultStatus> endSleep({
    required String childId,
    required String actorUid,
  }) async {
    try {
      if (childId.isEmpty || actorUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final DocumentSnapshot<Map<String, dynamic>> snap =
          await childrenCollection.doc(childId).get();
      final Map<String, dynamic>? data = snap.data();
      final Timestamp? startedTs = data?['sleep_started_at'] as Timestamp?;
      final DateTime now = DateTime.now();
      int durationMinutes = 0;
      if (startedTs != null) {
        durationMinutes = now.difference(startedTs.toDate()).inMinutes;
      }
      await childrenCollection.doc(childId).update(<String, dynamic>{
        'sleep_in_progress': false,
        'sleep_started_at': null,
        'last_sleep_duration_minutes': durationMinutes,
      });
      await childrenCollection.doc(childId).collection('events').add(
        <String, dynamic>{
          'type': 'sleep_end',
          'child_id': childId,
          'duration_minutes': durationMinutes,
          'timestamp': Timestamp.fromDate(now),
          'updated_by': actorUid,
        },
      );
      return ApiResultStatus.data(data: childId);
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
}
