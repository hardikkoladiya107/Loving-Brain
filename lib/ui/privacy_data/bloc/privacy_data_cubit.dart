import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';

import 'privacy_data_state.dart';

/// Cubit managing Privacy & Data interactions (Screen 62).
/// Conforms to AGENTS.md §4.2.
class PrivacyDataCubit extends Cubit<PrivacyDataState> {
  PrivacyDataCubit() : super(const PrivacyDataState());

  void init() {
    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();
    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'your child';

    changeProps(childName: cName);
  }

  void changeProps({
    String? childName,
    bool? isDeletingAccount,
    bool? isAccountDeleted,
    ApiResultStatus? exportStatus,
    ApiResultStatus? deleteStatus,
    Map<String, dynamic>? exportedData,
  }) {
    emit(
      state.copyWith(
        childName: childName ?? state.childName,
        isDeletingAccount: isDeletingAccount ?? state.isDeletingAccount,
        isAccountDeleted: isAccountDeleted ?? state.isAccountDeleted,
        exportStatus: exportStatus ?? ApiResultStatus.initial(),
        deleteStatus: deleteStatus ?? ApiResultStatus.initial(),
        exportedData: exportedData ?? state.exportedData,
      ),
    );
  }

  Future<void> exportData() async {
    changeProps(exportStatus: const ApiResultStatus.loading());
    final UserModel? user = preferences.getUserModel();
    final String uid = user?.uid ?? 'local_user';

    final ApiResultStatus<Map<String, dynamic>> result = await OfflineSyncRepo
        .instance
        .exportUserData(userId: uid);

    result.whenOrNull(
      data: (Map<String, dynamic> data) {
        changeProps(
          exportStatus: ApiResultStatus.data(data: data),
          exportedData: data,
        );
      },
      error: (Exception error) {
        changeProps(exportStatus: ApiResultStatus.error(error: error));
      },
    );
  }

  Future<void> deleteAccount() async {
    changeProps(
      isDeletingAccount: true,
      deleteStatus: const ApiResultStatus.loading(),
    );
    try {
      await AuthRepo.instance.deleteAccount();
      await preferences.clearUser();
      changeProps(
        isDeletingAccount: false,
        isAccountDeleted: true,
        deleteStatus: const ApiResultStatus.data(data: null),
      );
    } catch (e) {
      changeProps(
        isDeletingAccount: false,
        deleteStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }
}
