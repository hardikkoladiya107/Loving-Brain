import 'dart:convert';
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
        if (email.isNotEmpty) {
          await col.doc(email).set(pMap, SetOptions(merge: true));
        }
        if (_caregiverId != null &&
            _caregiverId!.isNotEmpty &&
            _caregiverId != email) {
          await col.doc(_caregiverId!).set(pMap, SetOptions(merge: true));
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

    if (childId.isNotEmpty) {
      try {
        final CollectionReference<Map<String, dynamic>> col = FirebaseFirestore
            .instance
            .collection('children')
            .doc(childId)
            .collection('caregiver_permissions');
        if (email.isNotEmpty) {
          await col.doc(email).delete();
        }
        if (_caregiverId != null && _caregiverId!.isNotEmpty) {
          await col.doc(_caregiverId!).delete();
        }
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
