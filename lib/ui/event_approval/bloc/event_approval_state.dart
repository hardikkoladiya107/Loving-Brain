import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_approval_state.freezed.dart';

@freezed
abstract class EventApprovalState with _$EventApprovalState {
  const factory EventApprovalState({@Default("") String message}) =
      _EventApprovalState;
}
