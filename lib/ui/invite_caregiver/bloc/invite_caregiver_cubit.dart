import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'invite_caregiver_state.dart';

class InviteCaregiverCubit extends Cubit<InviteCaregiverState> {
  InviteCaregiverCubit() : super(const InviteCaregiverState());

  void init() {
    final user = preferences.getUserModel();
    final child = preferences.getChildModel();
    final cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'your child';

    emit(state.copyWith(childName: cName));
  }

  void selectRole(String role) {
    emit(state.copyWith(selectedRole: role));
  }
}
