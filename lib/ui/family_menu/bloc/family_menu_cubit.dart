import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/repo/user_repo.dart';

import 'family_menu_state.dart';

/// Cubit managing Family Menu (Screen 54).
/// Conforms to AGENTS.md Rule 4.2.
class FamilyMenuCubit extends Cubit<FamilyMenuState> {
  FamilyMenuCubit() : super(const FamilyMenuState());

  void init() {
    final ChildModel? child = preferences.getChildModel();
    final String? childName = child?.childName?.trim();
    final String cName = (childName != null && childName.isNotEmpty)
        ? childName
        : 'your child';

    changeProps(childName: cName, fetchStatus: const ApiResultStatus.loading());
    _loadCaregivers();
  }

  Future<void> _loadCaregivers() async {
    final UserModel? user = preferences.getUserModel();
    ChildModel? child = preferences.getChildModel();
    final List<CaregiverItem> linked = <CaregiverItem>[];
    String? partnerId = user?.partnerUserId?.trim();

    final String currentUid = user?.uid ?? '';

    // Refresh child doc from Firestore to ensure real-time parent_reference_ids
    if (child?.reference != null) {
      try {
        final DocumentSnapshot<Map<String, dynamic>> snap =
            await (child!.reference as DocumentReference<Map<String, dynamic>>)
                .get();
        if (snap.exists && snap.data() != null) {
          child = ChildModel.fromJson(snap.data()!, snap.reference);
          await preferences.saveChildModel(child);
        }
      } catch (_) {}
    }

    // Auto-discover linked co-parents via child parent_reference_ids if partnerUserId is unset
    if ((partnerId == null || partnerId.isEmpty) &&
        child?.parentReferenceIds != null &&
        child!.parentReferenceIds!.length > 1) {
      for (final String pid in child.parentReferenceIds!) {
        if (pid.isNotEmpty && pid != currentUid) {
          partnerId = pid;
          // Self-heal partnerUserId on current user document
          if (currentUid.isNotEmpty) {
            UserRepo.instance.userCollection
                .doc(currentUid)
                .update(<String, dynamic>{'partner_user_id': partnerId})
                .catchError((_) => null);
          }
          break;
        }
      }
    }

    if (partnerId != null && partnerId.isNotEmpty) {
      UserModel? partnerUser;
      try {
        partnerUser = await UserRepo.instance.getUserById(uid: partnerId);
      } catch (_) {}

      final String? partnerName = partnerUser?.parentName?.trim();
      final String? dispName = partnerUser?.displayName?.trim();
      final String? rel = partnerUser?.relationshipToChild?.trim();
      String name = 'Partner';
      if (partnerName != null && partnerName.isNotEmpty) {
        name = partnerName;
      } else if (dispName != null &&
          dispName.isNotEmpty &&
          !dispName.contains('@')) {
        name = dispName;
      } else if (rel != null && rel.isNotEmpty) {
        name = rel;
      } else {
        name = 'Partner';
      }
      final String email = partnerUser?.email ?? partnerUser?.parentEmail ?? '';

      linked.add(
        CaregiverItem(
          id: partnerId,
          name: name,
          email: email,
          role: partnerUser?.relationshipToChild ?? 'Co-Parent',
          status: 'Linked',
        ),
      );
    }

    final List<CaregiverItem> pending = <CaregiverItem>[];
    final String? userEmail = user?.email?.trim();
    if (userEmail != null && userEmail.isNotEmpty) {
      final ApiResultStatus<List<Map<String, dynamic>>> pendingRes =
          await CoParentRepo.instance.getPendingInvitations(
            fromEmail: userEmail,
          );
      pendingRes.whenOrNull(
        data: (List<Map<String, dynamic>> items) {
          for (final Map<String, dynamic> item in items) {
            final String id = item['id'] as String? ?? '';
            final String toEmail = item['to_parent'] as String? ?? '';
            final String role = item['role'] as String? ?? 'Co-Parent';
            final String name = role.isNotEmpty ? role : 'Co-Parent';
            int daysRemaining = 14;
            final DateTime now = DateTime.now();
            if (item['created_at'] != null) {
              final DateTime? created = DateTime.tryParse(
                item['created_at'].toString(),
              );
              if (created != null) {
                final int daysPassed = now.difference(created).inDays;
                daysRemaining = (14 - daysPassed).clamp(0, 14);
              }
            } else if (item['expires_at'] != null) {
              final DateTime? expires = DateTime.tryParse(
                item['expires_at'].toString(),
              );
              if (expires != null) {
                daysRemaining = (expires.difference(now).inMinutes / 1440.0)
                    .ceil();
                if (daysRemaining < 0) daysRemaining = 0;
                if (daysRemaining > 14) daysRemaining = 14;
              }
            }
            pending.add(
              CaregiverItem(
                id: id,
                name: name.isNotEmpty ? name : toEmail,
                email: toEmail,
                role: role,
                status: 'Awaiting response',
                daysRemaining: daysRemaining,
              ),
            );
          }
        },
      );
    }

    changeProps(
      linkedCaregivers: linked,
      pendingInvites: pending,
      fetchStatus: const ApiResultStatus.data(data: null),
    );
  }

  void changeProps({
    bool? isLoading,
    String? childName,
    List<CaregiverItem>? linkedCaregivers,
    List<CaregiverItem>? pendingInvites,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        childName: childName ?? state.childName,
        linkedCaregivers: linkedCaregivers ?? state.linkedCaregivers,
        pendingInvites: pendingInvites ?? state.pendingInvites,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }
}
