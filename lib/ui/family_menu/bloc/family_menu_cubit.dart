import 'dart:async';
import 'dart:convert';
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

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _childSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _inviteSubscription;

  Future<void> init() async {
    final ChildModel? child = preferences.getChildModel();
    final String? childName = child?.childName?.trim();
    final String cName = (childName != null && childName.isNotEmpty)
        ? childName
        : 'your child';

    changeProps(childName: cName, fetchStatus: const ApiResultStatus.loading());
    await _loadCaregivers();

    final UserModel? user = preferences.getUserModel();
    final String? childId = child?.reference?.id;
    final String? userEmail = user?.email?.trim();
    _setupStreams(childId, userEmail);
  }

  void reset() {
    _childSubscription?.cancel();
    _childSubscription = null;
    _inviteSubscription?.cancel();
    _inviteSubscription = null;
    emit(const FamilyMenuState());
  }

  void _setupStreams(String? childId, String? userEmail) {
    _childSubscription?.cancel();
    _inviteSubscription?.cancel();

    if (childId != null && childId.isNotEmpty) {
      try {
        _childSubscription = FirebaseFirestore.instance
            .collection('children')
            .doc(childId)
            .snapshots()
            .listen((DocumentSnapshot<Map<String, dynamic>> snap) {
              if (!isClosed) {
                _loadCaregivers();
              }
            }, onError: (_) {});
      } catch (_) {}
    }

    if (userEmail != null && userEmail.isNotEmpty) {
      try {
        _inviteSubscription = FirebaseFirestore.instance
            .collection('co-parent-invitation')
            .where('from_parent', isEqualTo: userEmail)
            .snapshots()
            .listen((QuerySnapshot<Map<String, dynamic>> snap) {
              if (!isClosed) {
                _loadCaregivers();
              }
            }, onError: (_) {});
      } catch (_) {}
    }
  }

  Future<void> _loadCaregivers() async {
    final UserModel? user = preferences.getUserModel();
    ChildModel? child = preferences.getChildModel();
    final List<CaregiverItem> linked = <CaregiverItem>[];
    final String currentUid = user?.uid ?? '';
    String ownerUid = '';
    if (child != null) {
      final String? primary = child.primaryParentUid?.trim();
      if (primary != null && primary.isNotEmpty) {
        ownerUid = primary;
      } else if (child.parentReferenceIds != null &&
          child.parentReferenceIds!.isNotEmpty) {
        ownerUid = child.parentReferenceIds!.first;
      }
    }
    if (ownerUid.isEmpty) ownerUid = currentUid;
    final bool isCurrentUserOwner =
        currentUid.isNotEmpty && currentUid == ownerUid;

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

    final String childId = child?.reference?.id ?? '';
    if (childId.isNotEmpty) {
      try {
        final QuerySnapshot<Map<String, dynamic>> permsSnap =
            await FirebaseFirestore.instance
                .collection('children')
                .doc(childId)
                .collection('caregiver_permissions')
                .get();
        for (final QueryDocumentSnapshot<Map<String, dynamic>> pDoc
            in permsSnap.docs) {
          final Map<String, dynamic> data = pDoc.data();
          await preferences.saveCaregiverPermissions(data);
          await preferences.putString(
            'caregiver_permissions_${pDoc.id}',
            json.encode(data),
          );
        }
      } catch (_) {}
    }

    // List every linked parent on the active child (not a single partner_user_id).
    final List<String> parentIds = child?.parentReferenceIds ?? <String>[];
    for (final String pid in parentIds) {
      if (pid.isEmpty || pid == currentUid) continue;
      UserModel? partnerUser;
      try {
        partnerUser = await UserRepo.instance.getUserById(uid: pid);
      } catch (_) {}

      final String? partnerName = partnerUser?.parentName?.trim();
      final String? dispName = partnerUser?.displayName?.trim();
      final String? rel = partnerUser?.relationshipToChild?.trim();
      final String email = partnerUser?.email ?? partnerUser?.parentEmail ?? '';
      final String emailLocal = email.contains('@')
          ? email.split('@')[0].toLowerCase()
          : '';

      String name = 'Partner';
      if (partnerName != null &&
          partnerName.isNotEmpty &&
          partnerName.toLowerCase() != emailLocal) {
        name = partnerName;
      } else if (rel != null && rel.isNotEmpty) {
        name = rel;
      } else if (dispName != null &&
          dispName.isNotEmpty &&
          !dispName.contains('@') &&
          dispName.toLowerCase() != emailLocal &&
          dispName != 'Parent') {
        name = dispName;
      } else {
        name = rel?.isNotEmpty == true ? rel! : 'Co-Parent';
      }
      final bool isPartnerOwner = pid == ownerUid;

      linked.add(
        CaregiverItem(
          id: pid,
          name: name,
          email: email,
          role:
              partnerUser?.relationshipToChild ??
              (isPartnerOwner ? 'Primary Parent' : 'Co-Parent'),
          status: isPartnerOwner ? 'Primary Parent' : 'Linked',
          isOwner: isPartnerOwner,
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
      isCurrentUserOwner: isCurrentUserOwner,
      linkedCaregivers: linked,
      pendingInvites: pending,
      fetchStatus: const ApiResultStatus.data(data: null),
    );
  }

  Future<void> leaveFamily() async {
    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();
    final String currentUid = user?.uid ?? '';
    final String childId = child?.reference?.id ?? '';
    if (currentUid.isEmpty || childId.isEmpty) return;

    changeProps(leaveStatus: const ApiResultStatus.loading());

    final ApiResultStatus result = await CoParentRepo.instance.leaveChildFamily(
      childId: childId,
      userUid: currentUid,
    );

    result.whenOrNull(
      data: (_) {
        changeProps(leaveStatus: const ApiResultStatus.data(data: true));
      },
      error: (Exception err) {
        changeProps(leaveStatus: ApiResultStatus.error(error: err));
      },
    );
  }

  @override
  Future<void> close() {
    _childSubscription?.cancel();
    _inviteSubscription?.cancel();
    return super.close();
  }

  void changeProps({
    bool? isLoading,
    String? childName,
    bool? isCurrentUserOwner,
    List<CaregiverItem>? linkedCaregivers,
    List<CaregiverItem>? pendingInvites,
    ApiResultStatus? fetchStatus,
    ApiResultStatus? leaveStatus,
  }) {
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        childName: childName ?? state.childName,
        isCurrentUserOwner: isCurrentUserOwner ?? state.isCurrentUserOwner,
        linkedCaregivers: linkedCaregivers ?? state.linkedCaregivers,
        pendingInvites: pendingInvites ?? state.pendingInvites,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
        leaveStatus: leaveStatus ?? ApiResultStatus.initial(),
      ),
    );
  }
}
