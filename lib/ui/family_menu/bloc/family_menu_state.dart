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

  const CaregiverItem({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.status = 'Linked',
    this.daysRemaining = 14,
  });
}

@freezed
abstract class FamilyMenuState with _$FamilyMenuState {
  const factory FamilyMenuState({
    @Default(false) bool isLoading,
    @Default('your child') String childName,
    @Default(<CaregiverItem>[
      CaregiverItem(
        id: 'user_ravi',
        name: 'Ravi',
        email: 'ravi@example.com',
        role: 'Partner',
        status: 'Linked',
      ),
    ])
    List<CaregiverItem> linkedCaregivers,
    @Default(<CaregiverItem>[
      CaregiverItem(
        id: 'invite_grandma',
        name: 'Grandma Susan',
        email: 'susan@example.com',
        role: 'Grandparent',
        status: 'Awaiting response',
        daysRemaining: 12,
      ),
    ])
    List<CaregiverItem> pendingInvites,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _FamilyMenuState;
}
