import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';

import 'permissions_state.dart';

/// Cubit managing Caregiver Permissions (Screen 58).
/// Conforms to AGENTS.md Rule 4.2.
class PermissionsCubit extends Cubit<PermissionsState> {
  PermissionsCubit() : super(const PermissionsState());

  void init({String? caregiverName, String? role}) {
    final String cleanRole = role ?? 'Partner';
    final bool isGrandparent = cleanRole.toLowerCase() == 'grandparent';

    changeProps(
      caregiverName: caregiverName ?? 'Ravi',
      caregiverRole: cleanRole,
      sleepEnabled: true,
      behaviourEnabled: !isGrandparent,
      healthNotesEnabled: false,
      plansEnabled: true,
      mentorshipEnabled: false,
      saveStatus: const ApiResultStatus.initial(),
    );
  }

  void changeProps({
    String? caregiverName,
    String? caregiverRole,
    bool? sleepEnabled,
    bool? behaviourEnabled,
    bool? healthNotesEnabled,
    bool? plansEnabled,
    bool? mentorshipEnabled,
    bool? isSaving,
    ApiResultStatus? saveStatus,
  }) {
    emit(
      state.copyWith(
        caregiverName: caregiverName ?? state.caregiverName,
        caregiverRole: caregiverRole ?? state.caregiverRole,
        sleepEnabled: sleepEnabled ?? state.sleepEnabled,
        behaviourEnabled: behaviourEnabled ?? state.behaviourEnabled,
        healthNotesEnabled: healthNotesEnabled ?? state.healthNotesEnabled,
        plansEnabled: plansEnabled ?? state.plansEnabled,
        mentorshipEnabled: mentorshipEnabled ?? state.mentorshipEnabled,
        isSaving: isSaving ?? state.isSaving,
        saveStatus: saveStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void toggleSleep() => changeProps(sleepEnabled: !state.sleepEnabled);
  void toggleBehaviour() =>
      changeProps(behaviourEnabled: !state.behaviourEnabled);
  void toggleHealthNotes() =>
      changeProps(healthNotesEnabled: !state.healthNotesEnabled);
  void togglePlans() => changeProps(plansEnabled: !state.plansEnabled);
  void toggleMentorship() =>
      changeProps(mentorshipEnabled: !state.mentorshipEnabled);

  Future<bool> savePermissions() async {
    changeProps(
      isSaving: true,
      saveStatus: const ApiResultStatus.loading(),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    changeProps(
      isSaving: false,
      saveStatus: const ApiResultStatus.data(data: 'permissions_saved'),
    );
    return true;
  }

  Future<bool> revokeAccess() async {
    changeProps(
      isSaving: true,
      saveStatus: const ApiResultStatus.loading(),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    changeProps(
      isSaving: false,
      saveStatus: const ApiResultStatus.data(data: 'access_revoked'),
    );
    return true;
  }
}
