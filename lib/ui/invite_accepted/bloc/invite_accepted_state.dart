import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_accepted_state.freezed.dart';

@freezed
abstract class InviteAcceptedState with _$InviteAcceptedState {
  const factory InviteAcceptedState() = _InviteAcceptedState;
}
