import 'package:freezed_annotation/freezed_annotation.dart';

part 'parent_profile_state.freezed.dart';

@freezed
abstract class ParentProfileState with _$ParentProfileState {
  const factory ParentProfileState({
    @Default("") String message,
    DateTime? dateOfBirth,
    @Default("") String selectedGender,
    @Default("") String parentName,
    @Default("") String parentEmail,
  }) = _ParentProfileState;
}
