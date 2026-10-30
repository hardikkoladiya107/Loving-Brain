import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'family_menu_state.freezed.dart';

class CaregiverItem {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final int daysRemaining;
  final bool isOwner;

  const CaregiverItem({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.status = 'Linked',
    this.daysRemaining = 14,
    this.isOwner = false,
  });
}

@freezed
abstract class FamilyMenuState with _$FamilyMenuState {
  const factory FamilyMenuState({
    @Default(false) bool isLoading,
    @Default('your child') String childName,
    @Default(true) bool isCurrentUserOwner,
    @Default(<CaregiverItem>[]) List<CaregiverItem> linkedCaregivers,
    @Default(<CaregiverItem>[]) List<CaregiverItem> pendingInvites,
    @Default(<CaregiverItem>[]) List<CaregiverItem> incomingInvites,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus leaveStatus,
  }) = _FamilyMenuState;
}
