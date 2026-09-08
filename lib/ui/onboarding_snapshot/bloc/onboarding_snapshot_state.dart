import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../model/api_result_status.dart';

part 'onboarding_snapshot_state.freezed.dart';

@freezed
abstract class OnboardingSnapshotState with _$OnboardingSnapshotState {
  const factory OnboardingSnapshotState({
    @Default(ApiResultStatus.initial()) ApiResultStatus status,
  }) = _OnboardingSnapshotState;
}
