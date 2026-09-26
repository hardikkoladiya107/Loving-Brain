import 'package:freezed_annotation/freezed_annotation.dart';

part 'guide_profile_state.freezed.dart';

@freezed
abstract class GuideProfileState with _$GuideProfileState {
  const factory GuideProfileState() = _GuideProfileState;
}
