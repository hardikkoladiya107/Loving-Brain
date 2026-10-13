import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'invite_caregiver_state.freezed.dart';

@freezed
abstract class InviteCaregiverState with _$InviteCaregiverState {
  const factory InviteCaregiverState({
    @Default('Grandparent') String selectedRole,
    @Default('your child') String childName,
    @Default('') String emailOrPhone,
    @Default(false) bool isSending,
    @Default(ApiResultStatus.initial()) ApiResultStatus sendStatus,
  }) = _InviteCaregiverState;
}
