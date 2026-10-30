import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';

import 'permissions_state.dart';

/// Cubit managing Caregiver Permissions (Screen 58).
/// Conforms to AGENTS.md Rule 4.2.
class PermissionsCubit extends Cubit<PermissionsState> {
  PermissionsCubit() : super(const PermissionsState());

  String? _caregiverId;
  String? _caregiverEmail;

  void reset() {
    _caregiverId = null;
    _caregiverEmail = null;
    emit(const PermissionsState());
  }

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
        (caregiverEmail != null && caregiverEmail.trim().isNotEmpty)
        ? caregiverEmail.trim()
        : (name.contains('@')
              ? name
              : '${name.toLowerCase().replaceAll(' ', '')}@lovingbrain.test');

    Map<String, dynamic>? saved = preferences.getCaregiverPermissions(email);
    if (saved == null && caregiverId != null && caregiverId.isNotEmpty) {
      saved = preferences.getCaregiverPermissions(caregiverId);
    }

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
    } else {
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

    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';
    if (childId.isNotEmpty) {
      _loadRemotePermissions(
        childId: childId,
        email: email,
        caregiverId: caregiverId,
        fallbackName: name,
        fallbackRole: cleanRole,
      );
    }
  }

  Future<void> _loadRemotePermissions({
    required String childId,
    required String email,
    String? caregiverId,
    required String fallbackName,
    required String fallbackRole,
  }) async {
    try {
      final CollectionReference<Map<String, dynamic>> col = FirebaseFirestore
          .instance
          .collection('children')
          .doc(childId)
          .collection('caregiver_permissions');

      DocumentSnapshot<Map<String, dynamic>>? snap;
      if (email.isNotEmpty) {
        snap = await col.doc(email).get();
      }
      if ((snap == null || !snap.exists) &&
          caregiverId != null &&
          caregiverId.isNotEmpty) {
        snap = await col.doc(caregiverId).get();
      }

      if (snap != null && snap.exists && snap.data() != null) {
        final CaregiverPermissionsModel p = CaregiverPermissionsModel.fromMap(
          snap.data()!,
        );
        final Map<String, dynamic> pMap = p.toMap();
        await preferences.saveCaregiverPermissions(pMap);
        if (caregiverId != null && caregiverId.isNotEmpty) {
          await preferences.putString(
            'caregiver_permissions_$caregiverId',
            json.encode(pMap),
          );
        }
        if (!isClosed) {
          changeProps(
            caregiverName: p.name ?? fallbackName,
            caregiverRole: p.role.isNotEmpty ? p.role : fallbackRole,
            sleepEnabled: p.canViewSleep,
            behaviourEnabled: p.canViewBehaviour,
            healthNotesEnabled: p.canViewHealthNotes,
            plansEnabled: p.canViewPlans,
            mentorshipEnabled: p.canViewMentorSummaries,
          );
        }
      }
    } catch (_) {}
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

    final ChildModel? child = preferences.getChildModel();
    final String ownerUid =
        (child?.parentReferenceIds != null &&
            child!.parentReferenceIds!.isNotEmpty)
        ? child.parentReferenceIds!.first
        : '';
    final String targetId = _caregiverId ?? '';
    if (ownerUid.isNotEmpty && targetId.isNotEmpty && targetId == ownerUid) {
      changeProps(
        isSaving: false,
        saveStatus: ApiResultStatus.error(
          error: Exception("Cannot modify the primary parent's access."),
        ),
      );
      return false;
    }

    final String name = state.caregiverName;
    final String email =
        (_caregiverEmail != null && _caregiverEmail!.trim().isNotEmpty)
        ? _caregiverEmail!.trim()
        : (name.contains('@')
              ? name
              : '${name.toLowerCase().replaceAll(' ', '')}@lovingbrain.test');

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

    final Map<String, dynamic> pMap = permissionsModel.toMap();
    await preferences.saveCaregiverPermissions(pMap);
    if (email.isNotEmpty) {
      await preferences.putString(
        'caregiver_permissions_$email',
        json.encode(pMap),
      );
    }
    if (_caregiverId != null && _caregiverId!.isNotEmpty) {
      await preferences.putString(
        'caregiver_permissions_$_caregiverId',
        json.encode(pMap),
      );
    }

    final String childId = child?.reference?.id ?? '';
    if (childId.isNotEmpty) {
      try {
        final CollectionReference<Map<String, dynamic>> col = FirebaseFirestore
            .instance
            .collection('children')
            .doc(childId)
            .collection('caregiver_permissions');
        final String permDocId =
            (_caregiverId != null && _caregiverId!.isNotEmpty)
            ? _caregiverId!
            : email;
        if (permDocId.isNotEmpty) {
          await col.doc(permDocId).set(pMap, SetOptions(merge: true));
        }
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

    final ChildModel? child = preferences.getChildModel();
    final String ownerUid =
        (child?.parentReferenceIds != null &&
            child!.parentReferenceIds!.isNotEmpty)
        ? child.parentReferenceIds!.first
        : '';
    final String targetId = _caregiverId ?? '';
    if (ownerUid.isNotEmpty && targetId.isNotEmpty && targetId == ownerUid) {
      changeProps(
        isSaving: false,
        saveStatus: ApiResultStatus.error(
          error: Exception("Cannot revoke the primary parent's access."),
        ),
      );
      return false;
    }

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

    if (childId.isEmpty || partnerId.isEmpty) {
      changeProps(
        isSaving: false,
        saveStatus: ApiResultStatus.error(
          error: Exception('Missing caregiver or child.'),
        ),
      );
      return false;
    }

    try {
      final ApiResultStatus result = await CoParentRepo.instance
          .revokeCaregiver(childId: childId, targetUid: partnerId);
      bool ok = false;
      result.whenOrNull(
        data: (_) => ok = true,
        error: (Exception err) {
          changeProps(
            isSaving: false,
            saveStatus: ApiResultStatus.error(error: err),
          );
        },
      );
      if (!ok) return false;

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

      changeProps(
        isSaving: false,
        saveStatus: const ApiResultStatus.data(data: 'access_revoked'),
      );
      return true;
    } catch (e) {
      changeProps(
        isSaving: false,
        saveStatus: ApiResultStatus.error(
          error: e is Exception ? e : Exception(e.toString()),
        ),
      );
      return false;
    }
  }
}
