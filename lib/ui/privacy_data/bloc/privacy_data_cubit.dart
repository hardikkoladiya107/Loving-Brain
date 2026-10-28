import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

    final String lastSync =
        preferences.getString('last_offline_sync_time') ?? '';

    changeProps(
      childName: cName,
      lastSyncedTime: lastSync.isNotEmpty ? lastSync : 'Just now',
    );
    _checkPendingUpdates();
  }

  Future<void> _checkPendingUpdates() async {
    final List<dynamic> pending = await OfflineSyncRepo.instance
        .getPendingUpdates();
    if (isClosed) return;
    changeProps(pendingOfflineUpdatesCount: pending.length);
  }

  void changeProps({
    String? childName,
    bool? isDeletingAccount,
    bool? isAccountDeleted,
    int? pendingOfflineUpdatesCount,
    bool? isSyncing,
    String? lastSyncedTime,
    ApiResultStatus? syncStatus,
    ApiResultStatus? exportStatus,
    ApiResultStatus? importStatus,
    ApiResultStatus? deleteStatus,
    bool? isExporting,
    bool? isImporting,
    int? importedCount,
    String? lastExportedPath,
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
        lastSyncedTime: lastSyncedTime ?? state.lastSyncedTime,
        syncStatus: syncStatus ?? ApiResultStatus.initial(),
        exportStatus: exportStatus ?? ApiResultStatus.initial(),
        importStatus: importStatus ?? ApiResultStatus.initial(),
        deleteStatus: deleteStatus ?? ApiResultStatus.initial(),
        isExporting: isExporting ?? state.isExporting,
        isImporting: isImporting ?? state.isImporting,
        importedCount: importedCount ?? state.importedCount,
        lastExportedPath: lastExportedPath ?? state.lastExportedPath,
        exportedData: exportedData ?? state.exportedData,
      ),
    );
  }

  Future<void> manualSyncOfflineUpdates() async {
    changeProps(isSyncing: true, syncStatus: const ApiResultStatus.loading());
    // Minimum visual delay so user sees smooth active sync state
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final ApiResultStatus<int> res = await OfflineSyncRepo.instance
        .syncPendingUpdates();
    final List<dynamic> pending = await OfflineSyncRepo.instance
        .getPendingUpdates();
    final String nowFormatted = DateFormat('h:mm a').format(DateTime.now());
    await preferences.putString('last_offline_sync_time', nowFormatted);
    if (isClosed) return;
    changeProps(
      isSyncing: false,
      lastSyncedTime: nowFormatted,
      pendingOfflineUpdatesCount: pending.length,
      syncStatus: res,
    );
  }

  Future<void> exportData({bool saveToFileManager = false}) async {
    changeProps(
      isExporting: true,
      exportStatus: const ApiResultStatus.loading(),
    );
    try {
      final UserModel? user = preferences.getUserModel();
      final String uid = user?.uid ?? 'local_user';

      final ApiResultStatus<Map<String, dynamic>> result = await OfflineSyncRepo
          .instance
          .exportUserData(userId: uid);

      if (result is Data<Map<String, dynamic>>) {
        String jsonStr;
        try {
          const JsonEncoder encoder = JsonEncoder.withIndent(
            '  ',
            OfflineSyncRepo.sanitizeForJson,
          );
          jsonStr = encoder.convert(result.data);
        } catch (_) {
          jsonStr = json.encode(OfflineSyncRepo.sanitizeForJson(result.data));
        }

        final String nowStamp = DateFormat(
          'yyyyMMdd_HHmmss',
        ).format(DateTime.now());
        final String fileName = 'loving_brain_backup_$nowStamp.json';

        if (saveToFileManager) {
          try {
            final Uint8List bytes = Uint8List.fromList(utf8.encode(jsonStr));
            final Uri? outputUri = await FilePicker.saveFile(
              dialogTitle: 'Save LovingBrain Data Backup',
              fileName: fileName,
              bytes: bytes,
              mimeType: 'application/json',
            );

            if (outputUri != null) {
              final String savedPath = outputUri.path.isNotEmpty
                  ? outputUri.path
                  : outputUri.toString();
              changeProps(
                isExporting: false,
                exportStatus: ApiResultStatus.data(data: result.data),
                exportedData: result.data,
                lastExportedPath: savedPath,
              );
              return;
            } else {
              // User cancelled file picker
              changeProps(
                isExporting: false,
                exportStatus: const ApiResultStatus.initial(),
              );
              return;
            }
          } catch (pickerErr) {
            // FilePicker saveFile failed (e.g., unsupported platform/channel) - fallback to Share
          }
        }

        // Share fallback / default flow
        try {
          final Directory tempDir = await getTemporaryDirectory();
          final File file = File('${tempDir.path}/$fileName');
          await file.writeAsString(jsonStr);

          await SharePlus.instance.share(
            ShareParams(
              files: <XFile>[XFile(file.path, mimeType: 'application/json')],
              subject: 'LovingBrain Data Export',
              text:
                  'Here is your LovingBrain personal data export in standard JSON format.',
            ),
          );

          changeProps(
            isExporting: false,
            exportStatus: ApiResultStatus.data(data: result.data),
            exportedData: result.data,
            lastExportedPath: file.path,
          );
        } catch (shareErr) {
          changeProps(
            isExporting: false,
            exportStatus: ApiResultStatus.data(data: result.data),
            exportedData: result.data,
          );
        }
      } else if (result is Error<Map<String, dynamic>>) {
        changeProps(isExporting: false, exportStatus: result);
      }
    } catch (e) {
      changeProps(
        isExporting: false,
        exportStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }

  Future<void> importDataFromFile() async {
    try {
      final List<PlatformFile> picked = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: <String>['json'],
      );

      if (picked.isEmpty) {
        // User cancelled file picking
        changeProps(
          isImporting: false,
          importStatus: const ApiResultStatus.initial(),
        );
        return;
      }

      changeProps(
        isImporting: true,
        importStatus: const ApiResultStatus.loading(),
      );

      final PlatformFile platformFile = picked.first;
      final String jsonString = await platformFile.xFile.readAsString();

      final dynamic decoded = json.decode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        changeProps(
          isImporting: false,
          importStatus: ApiResultStatus.error(
            error: Exception('The selected file is not a valid JSON document.'),
          ),
        );
        return;
      }

      if (!decoded.containsKey('child_profile') &&
          !decoded.containsKey('user_profile') &&
          !decoded.containsKey('sleep_logs') &&
          !decoded.containsKey('app')) {
        changeProps(
          isImporting: false,
          importStatus: ApiResultStatus.error(
            error: Exception(
              'Selected file does not contain LovingBrain backup data.',
            ),
          ),
        );
        return;
      }

      final ApiResultStatus<int> res = await OfflineSyncRepo.instance
          .importUserData(payload: decoded);

      if (res is Data<int>) {
        final ChildModel? child = preferences.getChildModel();
        final String cName =
            (child?.childName != null && child!.childName!.trim().isNotEmpty)
            ? child.childName!.trim()
            : state.childName;

        changeProps(
          isImporting: false,
          childName: cName,
          importedCount: res.data,
          importStatus: res,
        );
      } else if (res is Error<int>) {
        changeProps(isImporting: false, importStatus: res);
      }
    } catch (e) {
      changeProps(
        isImporting: false,
        importStatus: ApiResultStatus.error(
          error: Exception(
            'Failed to import backup: ${e.toString().replaceAll("Exception: ", "")}',
          ),
        ),
      );
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
