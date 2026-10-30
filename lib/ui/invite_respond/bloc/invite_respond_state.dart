import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'invite_respond_state.freezed.dart';

@freezed
abstract class InviteRespondState with _$InviteRespondState {
  const factory InviteRespondState({
    @Default('') String invitationId,
    @Default('') String fromParentName,
    @Default('') String childNames,
    @Default('') String invitedEmailMasked,
    @Default('') String role,
    @Default('') String status,
    @Default(false) bool isLoadingPreview,
    @Default(ApiResultStatus.initial()) ApiResultStatus previewStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus actionStatus,
  }) = _InviteRespondState;
}
