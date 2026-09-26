import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_session_state.freezed.dart';

@freezed
abstract class RequestSessionState with _$RequestSessionState {
  const factory RequestSessionState({
    @Default('Bedtime has been unsettled\nfor two weeks') String mainConcern,
    @Default('17 months') String childAge,
    @Default('Weekday evenings after 8 PM') String preferredDays,
    @Default('English') String preferredLanguage,
    @Default(true) bool shareSummary,
    @Default(false) bool isSubmitting,
  }) = _RequestSessionState;
}
