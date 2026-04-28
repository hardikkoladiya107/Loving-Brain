import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/energy_bridge_timer_model.dart';

class EnergyBridgeRepo {
  EnergyBridgeRepo._();
  static final EnergyBridgeRepo _instance = EnergyBridgeRepo._();
  factory EnergyBridgeRepo() => _instance;
  static EnergyBridgeRepo get instance => _instance;

  final CollectionReference<Map<String, dynamic>> _energyBridgeCollection =
      FirebaseFirestore.instance.collection('energy_bridge');

  DocumentReference<Map<String, dynamic>> _doc(String childId) {
    return _energyBridgeCollection.doc(childId);
  }

  Stream<EnergyBridgeTimerModel?> watchTimer(String childId) {
    return _doc(childId).snapshots().map((
      DocumentSnapshot<Map<String, dynamic>> snap,
    ) {
      final Map<String, dynamic>? data = snap.data();
      if (data == null) return null;
      return EnergyBridgeTimerModel.fromJson(data, childId: childId);
    });
  }

  Future<ApiResultStatus> startTimer({
    required String childId,
    required String actorUid,
    int durationMinutes = 105,
  }) async {
    try {
      final DateTime now = DateTime.now();
      final DateTime fireAt = now.add(Duration(minutes: durationMinutes));
      await _doc(childId).set(<String, dynamic>{
        'is_active': true,
        'started_at': Timestamp.fromDate(now),
        'duration_minutes': durationMinutes,
        'fire_at': Timestamp.fromDate(fireAt),
        'fired': false,
        'fired_at': null,
        'fired_push_sent_at': null,
        'last_reset_at': null,
        'reset_reason': null,
        'updated_by': actorUid,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
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

  Future<ApiResultStatus> resetTimer({
    required String childId,
    required String actorUid,
    required String reason,
  }) async {
    try {
      await _doc(childId).set(<String, dynamic>{
        'is_active': false,
        'last_reset_at': FieldValue.serverTimestamp(),
        'reset_reason': reason,
        'updated_by': actorUid,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
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

  Future<ApiResultStatus> markFired({
    required String childId,
    required String actorUid,
  }) async {
    try {
      await _doc(childId).set(<String, dynamic>{
        'is_active': false,
        'fired': true,
        'fired_at': FieldValue.serverTimestamp(),
        'updated_by': actorUid,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
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
