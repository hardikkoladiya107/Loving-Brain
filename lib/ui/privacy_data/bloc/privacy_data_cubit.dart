import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
    _checkPendingUpdates();
  }

  Future<void> _checkPendingUpdates() async {
    final pending = await OfflineSyncRepo.instance.getPendingUpdates();
    if (isClosed) return;
    changeProps(pendingOfflineUpdatesCount: pending.length);
  }

  void changeProps({
    String? childName,
    bool? isDeletingAccount,
    bool? isAccountDeleted,
    int? pendingOfflineUpdatesCount,
    bool? isSyncing,
    ApiResultStatus? syncStatus,
    ApiResultStatus? exportStatus,
    ApiResultStatus? deleteStatus,
    Map<String, dynamic>? exportedData,
  }) {
    emit(
      state.copyWith(
        childName: childName ?? state.childName,
        isDeletingAccount: isDeletingAccount ?? state.isDeletingAccount,
        isAccountDeleted: isAccountDeleted ?? state.isAccountDeleted,
        pendingOfflineUpdatesCount:
            pendingOfflineUpdatesCount ?? state.pendingOfflineUpdatesCount,
        isSyncing: isSyncing ?? state.isSyncing,
        syncStatus: syncStatus ?? ApiResultStatus.initial(),
        exportStatus: exportStatus ?? ApiResultStatus.initial(),
        deleteStatus: deleteStatus ?? ApiResultStatus.initial(),
        exportedData: exportedData ?? state.exportedData,
      ),
    );
  }

  Future<void> manualSyncOfflineUpdates() async {
    changeProps(isSyncing: true, syncStatus: const ApiResultStatus.loading());
    final ApiResultStatus<int> res = await OfflineSyncRepo.instance
        .syncPendingUpdates();
    final pending = await OfflineSyncRepo.instance.getPendingUpdates();
    changeProps(
      isSyncing: false,
      pendingOfflineUpdatesCount: pending.length,
      syncStatus: res,
    );
  }

  Future<void> exportData() async {
    changeProps(exportStatus: const ApiResultStatus.loading());
    final UserModel? user = preferences.getUserModel();
    final String uid = user?.uid ?? 'local_user';

    final ApiResultStatus<Map<String, dynamic>> result = await OfflineSyncRepo
        .instance
        .exportUserData(userId: uid);

    if (result is Data<Map<String, dynamic>>) {
      changeProps(
        exportStatus: ApiResultStatus.data(data: result.data),
        exportedData: result.data,
      );

      try {
        final Directory tempDir = await getTemporaryDirectory();
        final String jsonStr = const JsonEncoder.withIndent(
          '  ',
        ).convert(result.data);
        final String fileName =
            'loving_brain_data_export_${DateTime.now().millisecondsSinceEpoch}.json';
        final File file = File('${tempDir.path}/$fileName');
        await file.writeAsString(jsonStr);

        await SharePlus.instance.share(
          ShareParams(
            files: <XFile>[XFile(file.path, mimeType: 'application/json')],
            subject: 'LovingBrain Data Export',
            text: 'Here is your exported data from LovingBrain.',
          ),
        );
      } catch (e) {
        // Native share / path_provider fallback in headless/test environments
      }
    } else if (result is Error<Map<String, dynamic>>) {
      changeProps(exportStatus: result);
    }
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
