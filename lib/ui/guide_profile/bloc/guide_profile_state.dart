import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';

part 'guide_profile_state.freezed.dart';

@freezed
abstract class GuideProfileState with _$GuideProfileState {
  const factory GuideProfileState({
    @Default(false) bool isLoading,
    GuideProfileModel? guide,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _GuideProfileState;
}
