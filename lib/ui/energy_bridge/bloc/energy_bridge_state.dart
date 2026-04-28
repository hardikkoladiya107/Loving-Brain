import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/energy_bridge_timer_model.dart';

part 'energy_bridge_state.freezed.dart';

@freezed
abstract class EnergyBridgeState with _$EnergyBridgeState {
  const factory EnergyBridgeState({
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
    String? childId,
    EnergyBridgeTimerModel? timer,
  }) = _EnergyBridgeState;
}
