import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'privacy_data_state.dart';

class PrivacyDataCubit extends Cubit<PrivacyDataState> {
  PrivacyDataCubit() : super(const PrivacyDataState());

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

  Future<void> deleteAccount() async {
    emit(state.copyWith(isDeletingAccount: true, errorMessage: ''));
    try {
      await AuthRepo.instance.deleteAccount();
      emit(state.copyWith(isDeletingAccount: false, isAccountDeleted: true));
    } catch (e) {
      emit(
        state.copyWith(
          isDeletingAccount: false,
          errorMessage: 'Failed to delete account: $e',
        ),
      );
    }
  }
}
