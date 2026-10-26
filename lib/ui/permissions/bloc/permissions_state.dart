import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'permissions_state.freezed.dart';

@freezed
abstract class PermissionsState with _$PermissionsState {
  const factory PermissionsState({
    @Default('Caregiver') String caregiverName,
    @Default('Partner') String caregiverRole,
    @Default(true) bool sleepEnabled,
    @Default(true) bool behaviourEnabled,
    @Default(false) bool healthNotesEnabled,
    @Default(true) bool plansEnabled,
    @Default(false) bool mentorshipEnabled,
    @Default(false) bool isSaving,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveStatus,
  }) = _PermissionsState;
}
