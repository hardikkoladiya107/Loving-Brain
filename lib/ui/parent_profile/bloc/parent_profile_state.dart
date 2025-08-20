import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'parent_profile_state.freezed.dart';

@freezed
abstract class ParentProfileState with _$ParentProfileState {
  const factory ParentProfileState({
    @Default([]) List<String> genderList,
    @Default("") String parentName,
    @Default("") String parentNameError,
    @Default("") String parentEmailAddress,
    @Default("") String parentEmailAddressError,
    DateTime? parentDateOfBirth,
    @Default("") String parentDateOfBirthError,
    @Default("") String parentGender,
    @Default("") String parentGenderError,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
  }) = _ParentProfileState;
}
