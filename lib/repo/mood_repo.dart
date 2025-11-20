import 'package:cloud_firestore/cloud_firestore.dart';
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
  }) async {
    try {
      var tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        await userCollection
            .doc(tUid)
            .collection("journals")
            .doc()
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
