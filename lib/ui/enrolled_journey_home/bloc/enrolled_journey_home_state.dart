import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';

part 'enrolled_journey_home_state.freezed.dart';

@freezed
abstract class EnrolledJourneyHomeState with _$EnrolledJourneyHomeState {
  const factory EnrolledJourneyHomeState({
    @Default(false) bool isLoading,
    EnrolledProgramModel? program,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _EnrolledJourneyHomeState;
}
