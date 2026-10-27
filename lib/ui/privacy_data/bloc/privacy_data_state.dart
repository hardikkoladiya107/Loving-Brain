import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'privacy_data_state.freezed.dart';

/// State for Screen 62 (Privacy & Data).
/// Conforms to AGENTS.md §4.1.
@freezed
abstract class PrivacyDataState with _$PrivacyDataState {
  const factory PrivacyDataState({
    @Default('your child') String childName,
    @Default(false) bool isDeletingAccount,
    @Default(false) bool isAccountDeleted,
    @Default(0) int pendingOfflineUpdatesCount,
    @Default(false) bool isSyncing,
    @Default('') String lastSyncedTime,
    @Default(ApiResultStatus.initial()) ApiResultStatus syncStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus exportStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus deleteStatus,
    Map<String, dynamic>? exportedData,
  }) = _PrivacyDataState;
}
