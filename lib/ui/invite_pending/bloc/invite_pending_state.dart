import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'invite_pending_state.freezed.dart';

@freezed
abstract class InvitePendingState with _$InvitePendingState {
  const factory InvitePendingState({
    @Default('susan@example.com') String recipientEmail,
    @Default('Grandparent') String role,
    @Default(14) int daysUntilExpiry,
    @Default(<String>['Sleep patterns', "Tonight's plan"])
    List<String> sharedCategories,
    @Default(false) bool isResending,
    @Default(false) bool isCancelled,
    @Default(ApiResultStatus.initial()) ApiResultStatus actionStatus,
  }) = _InvitePendingState;
}
