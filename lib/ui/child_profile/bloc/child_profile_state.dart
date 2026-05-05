import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'child_profile_state.freezed.dart';

@freezed
abstract class ChildProfileState with _$ChildProfileState {
  const factory ChildProfileState({
    @Default("") String childName,
    @Default("") String childNameError,
    DateTime? childDob,
    @Default("") String childDobError,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
  }) = _ChildProfileState;
}
