import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/energy_bridge_timer_model.dart';
import 'package:loving_brain/other/energy_bridge_notification_helper.dart';
import 'package:loving_brain/other/notification_util.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/energy_bridge_repo.dart';

import 'energy_bridge_state.dart';

/// Listens to `energy_bridge/{childId}` and handles client-side fire detection.
///
/// Server-side firing uses Cloud Tasks (see `onEnergyBridgeSchedule`); this
/// cubit covers foreground countdown and local notification fallback.
class EnergyBridgeCubit extends Cubit<EnergyBridgeState> {
  EnergyBridgeCubit() : super(const EnergyBridgeState());

  StreamSubscription? _timerSubscription;

  void init({String? childId}) {
    final String? resolvedChildId =
        childId ?? preferences.getUserModel()?.defaultChild?.id;
    if (resolvedChildId == null || resolvedChildId.isEmpty) return;

    changeProps(childId: resolvedChildId);
    _timerSubscription?.cancel();
    _timerSubscription = EnergyBridgeRepo.instance
        .watchTimer(resolvedChildId)
        .listen((EnergyBridgeTimerModel? timer) {
          changeProps(timer: timer);
          _handleFireIfDue();
        });
  }

  void startTimer() {
    _startTimerInternal();
  }

  void stopTimer() {
    _resetTimerInternal(reason: 'manual');
  }

  void resetByReason(String reason) {
    _resetTimerInternal(reason: reason);
  }

  Future<void> _startTimerInternal() async {
    final String? childId = state.childId;
    final String uid = preferences.getUserModel()?.uid ?? '';
    if ((childId ?? '').isEmpty || uid.isEmpty) return;

    changeProps(apiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus response = await EnergyBridgeRepo.instance.startTimer(
      childId: childId!,
      actorUid: uid,
      durationMinutes: 105,
    );
    response.whenOrNull(
      data: (_) async {
        await EnergyBridgeNotificationHelper.scheduleFireNotification(
          childId: childId,
          durationMinutes: 105,
        );
      },
    );
    changeProps(apiResultStatus: response);
  }

  Future<void> _resetTimerInternal({required String reason}) async {
    final String? childId = state.childId;
    final String uid = preferences.getUserModel()?.uid ?? '';
    if ((childId ?? '').isEmpty || uid.isEmpty) return;

    changeProps(apiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus response = await EnergyBridgeRepo.instance.resetTimer(
      childId: childId!,
      actorUid: uid,
      reason: reason,
    );
    await EnergyBridgeNotificationHelper.cancelForChild(childId);
    changeProps(apiResultStatus: response);
  }

  Future<void> _handleFireIfDue() async {
    final EnergyBridgeTimerModel? timer = state.timer;
    final String? childId = state.childId;
    final String uid = preferences.getUserModel()?.uid ?? '';
    if (timer == null || childId == null || uid.isEmpty) return;
    if (!timer.isActive || timer.fired || timer.fireAt == null) return;
    if (DateTime.now().isBefore(timer.fireAt!)) return;

    final ApiResultStatus response = await EnergyBridgeRepo.instance.markFired(
      childId: childId,
      actorUid: uid,
    );
    response.whenOrNull(
      data: (_) {
        NotificationUtil.showLocalNotification(
          id: EnergyBridgeNotificationHelper.notificationIdForChild(childId),
          title: 'LovingBrain',
          body: 'Time to slow things down.',
          payload: 'energy_bridge',
        );
      },
    );
  }

  void changeProps({
    ApiResultStatus? apiResultStatus,
    String? childId,
    EnergyBridgeTimerModel? timer,
  }) {
    emit(
      state.copyWith(
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        childId: childId ?? state.childId,
        timer: timer ?? state.timer,
      ),
    );
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}
