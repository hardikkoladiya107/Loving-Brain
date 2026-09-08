import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../model/api_result_status.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentPage,
    @Default(6) int totalPages,
    @Default('Russell Sprout') String parentName,
    @Default('Mother') String parentRole,
    @Default('English') String preferredLanguage,
    @Default('Chennai, India (GMT+5:30)') String location,
    @Default(ApiResultStatus.initial()) ApiResultStatus completeStatus,
  }) = _OnboardingState;
}
