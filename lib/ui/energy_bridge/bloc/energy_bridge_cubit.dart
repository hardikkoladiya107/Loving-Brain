import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/notification_util.dart';
import 'energy_bridge_state.dart';

class EnergyBridgeCubit extends Cubit<EnergyBridgeState> {
  EnergyBridgeCubit() : super(const EnergyBridgeState());

  void init() {
    bool isActive = preferences.getBool(SharedPreference.isHighEnergyActive) ?? false;
    int startTime = preferences.getInt(SharedPreference.energyBridgeStartTime) ?? 0;
    
    // Check if 120 minutes have already passed and auto-reset
    if (isActive && startTime > 0) {
      final startDateTime = DateTime.fromMillisecondsSinceEpoch(startTime);
      final difference = DateTime.now().difference(startDateTime);
      if (difference.inMinutes >= 120) {
        _resetTimerState();
        isActive = false;
        startTime = 0;
      }
    }

    changeProps(isTimerActive: isActive, startTime: startTime);
  }

  void startTimer() {
    final now = DateTime.now();
    final startTimeEpoch = now.millisecondsSinceEpoch;
    
    preferences.putBool(SharedPreference.isHighEnergyActive, true);
    preferences.putInt(SharedPreference.energyBridgeStartTime, startTimeEpoch);
    
    changeProps(isTimerActive: true, startTime: startTimeEpoch);

    // Schedule notification for 105 minutes from now
    // (using 105 minutes per requirements)
    final triggerTime = now.add(const Duration(minutes: 105));
    
    NotificationUtil.scheduleNotification(
      id: 9991, // Unique ID for Energy Bridge
      title: "Energy Bridge",
      body: "Time to transition! Your child has been highly active.",
      payload: "energy_bridge",
      scheduledDate: triggerTime,
    );
  }

  void stopTimer() {
    _resetTimerState();
    changeProps(isTimerActive: false, startTime: 0);
  }

  void _resetTimerState() {
    preferences.putBool(SharedPreference.isHighEnergyActive, false);
    preferences.putInt(SharedPreference.energyBridgeStartTime, 0);
    NotificationUtil.cancelNotification(9991);
  }

  void changeProps({
    apiResultStatus,
    bool? isTimerActive,
    int? startTime,
  }) {
    emit(
      state.copyWith(
        apiResultStatus: apiResultStatus ?? state.apiResultStatus,
        isTimerActive: isTimerActive ?? state.isTimerActive,
        startTime: startTime ?? state.startTime,
      ),
    );
  }
}
