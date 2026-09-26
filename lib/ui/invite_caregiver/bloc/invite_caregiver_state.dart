import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_caregiver_state.freezed.dart';

@freezed
abstract class InviteCaregiverState with _$InviteCaregiverState {
  const factory InviteCaregiverState() = _InviteCaregiverState;
}
