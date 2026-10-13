import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

import 'family_menu_state.dart';

/// Cubit managing Family Menu (Screen 54).
/// Conforms to AGENTS.md Rule 4.2.
class FamilyMenuCubit extends Cubit<FamilyMenuState> {
  FamilyMenuCubit() : super(const FamilyMenuState());

  void init() {
    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();

    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : 'your child';

    final List<CaregiverItem> linked = <CaregiverItem>[];
    if (user?.partnerUserId != null && user!.partnerUserId!.trim().isNotEmpty) {
      linked.add(
        CaregiverItem(
          id: user.partnerUserId!,
          name: 'Ravi',
          email: 'partner@lovingbrain.com',
          role: 'Partner',
          status: 'Linked',
        ),
      );
    } else {
      linked.addAll(state.linkedCaregivers);
    }

    changeProps(
      childName: cName,
      linkedCaregivers: linked,
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
