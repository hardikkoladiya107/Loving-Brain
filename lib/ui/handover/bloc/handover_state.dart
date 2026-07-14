import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';

part 'handover_state.freezed.dart';

@freezed
abstract class HandoverState with _$HandoverState {
  const factory HandoverState({
    UserModel? userModel,
    @Default(ApiResultStatus.initial()) ApiResultStatus transferStatus,
  }) = _HandoverState;
}
