import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'child_essentials_state.freezed.dart';

@freezed
abstract class ChildEssentialsState with _$ChildEssentialsState {
  const factory ChildEssentialsState({
    @Default(false) bool isLoading,
    @Default('your child') String childName,
    @Default(<String>[]) List<String> allergies,
    @Default(<String>[]) List<String> medications,
    @Default(<String>[]) List<String> emergencyContacts,
    @Default('') String pediatrician,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _ChildEssentialsState;
}
