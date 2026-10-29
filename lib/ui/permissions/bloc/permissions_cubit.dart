import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

import 'permissions_state.dart';

/// Cubit managing Caregiver Permissions (Screen 58).
/// Conforms to AGENTS.md Rule 4.2.
class PermissionsCubit extends Cubit<PermissionsState> {
  PermissionsCubit() : super(const PermissionsState());

  String? _caregiverId;
  String? _caregiverEmail;

  void init({
    String? caregiverName,
    String? role,
    String? caregiverId,
    String? caregiverEmail,
  }) {
    _caregiverId = caregiverId;
    _caregiverEmail = caregiverEmail;
    final String cleanRole = role ?? 'Partner';
    final bool isGrandparent = cleanRole.toLowerCase() == 'grandparent';
    final String name = caregiverName ?? 'Caregiver';
    final String email =
        caregiverEmail ??
        (name.contains('@')
            ? name
            : '${name.toLowerCase().replaceAll(' ', '')}@lovingbrain.test');

    final Map<String, dynamic>? saved = preferences.getCaregiverPermissions(
      email,
    );
    if (saved != null) {
      final CaregiverPermissionsModel p = CaregiverPermissionsModel.fromMap(
        saved,
      );
      changeProps(
        caregiverName: p.name ?? name,
        caregiverRole: p.role,
        sleepEnabled: p.canViewSleep,
        behaviourEnabled: p.canViewBehaviour,
        healthNotesEnabled: p.canViewHealthNotes,
        plansEnabled: p.canViewPlans,
        mentorshipEnabled: p.canViewMentorSummaries,
        saveStatus: const ApiResultStatus.initial(),
      );
      return;
    }

    changeProps(
      caregiverName: name,
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
    changeProps(isSaving: true, saveStatus: const ApiResultStatus.loading());

    final String name = state.caregiverName;
    final String email = name.contains('@')
        ? name
        : '${name.toLowerCase().replaceAll(' ', '')}@lovingbrain.test';

    final CaregiverPermissionsModel permissionsModel =
        CaregiverPermissionsModel(
          caregiverEmail: email,
          name: name,
          role: state.caregiverRole,
          canViewSleep: state.sleepEnabled,
          canViewBehaviour: state.behaviourEnabled,
          canViewHealthNotes: state.healthNotesEnabled,
          canViewPlans: state.plansEnabled,
          canViewMentorSummaries: state.mentorshipEnabled,
        );

    await preferences.saveCaregiverPermissions(permissionsModel.toMap());

    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';
    if (childId.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('children')
            .doc(childId)
            .collection('caregiver_permissions')
            .doc(email)
            .set(permissionsModel.toMap(), SetOptions(merge: true));
      } catch (_) {}
    }

    changeProps(
      isSaving: false,
      saveStatus: const ApiResultStatus.data(data: 'permissions_saved'),
    );
    return true;
  }

  Future<bool> revokeAccess() async {
    changeProps(isSaving: true, saveStatus: const ApiResultStatus.loading());

    final String name = state.caregiverName;
    final String email =
        _caregiverEmail ??
        (name.contains('@')
            ? name
            : '${name.toLowerCase().replaceAll(' ', '')}@lovingbrain.test');

    final CaregiverPermissionsModel revoked = CaregiverPermissionsModel(
      caregiverEmail: email,
      name: name,
      role: state.caregiverRole,
      canViewSleep: false,
      canViewBehaviour: false,
      canViewHealthNotes: false,
      canViewPlans: false,
      canViewMentorSummaries: false,
    );

    await preferences.saveCaregiverPermissions(revoked.toMap());

    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';
    String partnerId =
        _caregiverId ?? preferences.getUserModel()?.partnerUserId ?? '';
    if (partnerId.isEmpty &&
        child != null &&
        child.parentReferenceIds != null) {
      final String myUid = preferences.getUserModel()?.uid ?? '';
      for (final String pid in child.parentReferenceIds!) {
        if (pid.isNotEmpty && pid != myUid) {
          partnerId = pid;
          break;
        }
      }
    }

    if (childId.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('children')
            .doc(childId)
            .collection('caregiver_permissions')
            .doc(email)
            .delete();
      } catch (_) {}

      // Remove co-parent from child parent_reference_ids so they cannot access child records
      if (partnerId.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection('children')
              .doc(childId)
              .update(<String, dynamic>{
                'parent_reference_ids': FieldValue.arrayRemove(<dynamic>[
                  partnerId,
                ]),
              });
        } catch (_) {}
      }
    }

    // Update local child model in preferences
    if (child != null && child.parentReferenceIds != null) {
      final List<String> updatedParents = List<String>.from(
        child.parentReferenceIds!,
      )..remove(partnerId);
      final ChildModel updatedChild = child.copyWith(
        parentReferenceIds: updatedParents,
      );
      await preferences.saveChildModel(updatedChild);
      await preferences.saveDefaultChildModel(updatedChild);
    }

    final UserModel? user = preferences.getUserModel();
    if (user != null && user.uid != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(<String, dynamic>{'partner_user_id': FieldValue.delete()});
        if (partnerId.isNotEmpty) {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(partnerId)
                .update(<String, dynamic>{
                  'partner_user_id': FieldValue.delete(),
                });
          } catch (_) {}
        }
      } catch (_) {}
      final UserModel updatedUser = user.copyWith(clearPartnerUserId: true);
      await preferences.saveUserModel(updatedUser);
    }

    changeProps(
      isSaving: false,
      saveStatus: const ApiResultStatus.data(data: 'access_revoked'),
    );
    return true;
  }
}
