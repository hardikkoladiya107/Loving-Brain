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
    final List<CaregiverItem> linked = <CaregiverItem>[];
    final String? partnerId = user?.partnerUserId?.trim();

    if (partnerId != null && partnerId.isNotEmpty) {
      UserModel? partnerUser;
      try {
        partnerUser = await UserRepo.instance.getUserById(uid: partnerId);
      } catch (_) {}

      final String? partnerName = partnerUser?.parentName?.trim();
      final String name = (partnerName != null && partnerName.isNotEmpty)
          ? partnerName
          : (partnerUser?.email?.split('@').first ?? 'Co-Parent');
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
            final String name = toEmail.split('@').first;
            int daysRemaining = 14;
            if (item['expires_at'] != null) {
              final DateTime? expires = DateTime.tryParse(
                item['expires_at'].toString(),
              );
              if (expires != null) {
                daysRemaining = expires.difference(DateTime.now()).inDays;
                if (daysRemaining < 0) daysRemaining = 0;
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
