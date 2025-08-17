import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_profile_state.freezed.dart';

@freezed
abstract class ChildProfileState with _$ChildProfileState {
  const factory ChildProfileState({
    @Default("") String message,
    @Default("") String childName,
    @Default("") String relationShipToChild,
    @Default("") String childAge,
  }) = _ChildProfileState;
}
