import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_pending_state.freezed.dart';

@freezed
abstract class InvitePendingState with _$InvitePendingState {
  const factory InvitePendingState() = _InvitePendingState;
}
