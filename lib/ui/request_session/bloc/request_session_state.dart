import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';

part 'request_session_state.freezed.dart';

@freezed
abstract class RequestSessionState with _$RequestSessionState {
  const factory RequestSessionState({
    GuideProfileModel? guide,
    @Default('your child') String childName,
    @Default('') String mainConcern,
    @Default('') String mainConcernError,
    @Default('17 months') String childAge,
    @Default('') String preferredDays,
    @Default('') String preferredLanguage,
    @Default(false) bool shareSummary,
    @Default(false) bool isSubmitting,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveStatus,
  }) = _RequestSessionState;
}
