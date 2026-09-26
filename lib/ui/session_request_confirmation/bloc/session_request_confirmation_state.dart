import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_request_confirmation_state.freezed.dart';

@freezed
abstract class SessionRequestConfirmationState
    with _$SessionRequestConfirmationState {
  const factory SessionRequestConfirmationState() =
      _SessionRequestConfirmationState;
}
