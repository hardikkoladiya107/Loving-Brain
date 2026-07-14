import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/model/mood_log_model.dart';

import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';
import '../other/extra_methods.dart';
import '../other/preferances.dart';

class MoodRepo {
  MoodRepo._();

  static final MoodRepo _instance = MoodRepo._();

  factory MoodRepo() {
    return _instance;
  }

  static MoodRepo get instance => _instance;

  var userCollection = FirebaseFirestore.instance.collection('users');

  Future<ApiResultStatus> addMood({
    required String date,
    required Map<String, dynamic> request,
  }) async {
    try {
      var tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        await userCollection
            .doc(tUid)
            .collection("mood")
            .doc(date)
            .set(request);
        return ApiResultStatus.data(data: tUid);
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> addJournal({
    required Map<String, dynamic> request,
    String? tUid,
  }) async {
    try {
      var uid =
          tUid ??
          preferences.getUserModel()?.uid ??
          FirebaseAuth.instance.currentUser?.uid ??
          "";
      if (uid.isNotEmpty) {
        await userCollection.doc(uid).collection("journals").doc().set(request);
        return ApiResultStatus.data(data: uid);
      } else {
        return ApiResultStatus.error(
          error: Exception(
            "tUid is empty. getUserModel is null or uid is missing.",
          ),
        );
      }
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception("FirebaseException: code=${e.code}, msg=${e.message}"),
      );
    } on Exception catch (e) {
      return ApiResultStatus.error(error: Exception("Exception: $e"));
    }
  }

  Future<ApiResultStatus> updateJournalPosition({
    required String journalId,
    required double x,
    required double y,
    String? tUid,
  }) async {
    try {
      var uid =
          tUid ??
          preferences.getUserModel()?.uid ??
          FirebaseAuth.instance.currentUser?.uid ??
          "";
      if (uid.isNotEmpty) {
        await userCollection
            .doc(uid)
            .collection("journals")
            .doc(journalId)
            .update({'x': x, 'y': y});
        return ApiResultStatus.data(data: uid);
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> deleteJournal({
    required String journalId,
    String? tUid,
  }) async {
    try {
      var uid =
          tUid ??
          preferences.getUserModel()?.uid ??
          FirebaseAuth.instance.currentUser?.uid ??
          "";
      if (uid.isNotEmpty) {
        await userCollection
            .doc(uid)
            .collection("journals")
            .doc(journalId)
            .delete();
        return ApiResultStatus.data(data: uid);
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> fetchAllMoodLogs() async {
    try {
      final tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }

      final snap = await userCollection
          .doc(tUid)
          .collection("mood")
          .orderBy("log_time", descending: true)
          .get();

      final list = snap.docs
          .map((d) => MoodLogModel.fromMap(d.data()))
          .toList();

      return ApiResultStatus.data(data: list);
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }
}
