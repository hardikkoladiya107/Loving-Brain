import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'invite_caregiver_state.freezed.dart';

@freezed
abstract class InviteCaregiverState with _$InviteCaregiverState {
  const InviteCaregiverState._();

  const factory InviteCaregiverState({
    @Default('Grandparent') String selectedRole,
    @Default('your child') String childName,
    @Default('') String email,
    @Default('') String emailError,
    @Default(false) bool isSending,
    @Default('') String createdInvitationId,
    @Default(ApiResultStatus.initial()) ApiResultStatus sendStatus,
  }) = _InviteCaregiverState;

  String get emailOrPhone => email;
}
