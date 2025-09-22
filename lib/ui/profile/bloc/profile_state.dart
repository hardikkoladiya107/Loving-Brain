import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../../model/user_model.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool dailyEmotionCheck,
    @Default(false) bool todaysPlayIdea,
    @Default(false) bool scheduleReminder,
    @Default(ApiResultStatus.initial()) ApiResultStatus logoutApiResultStatus,
    @Default(ApiResultStatus.initial())
    ApiResultStatus deleteAccountApiResultStatus,
    UserModel? userModel,
  }) = _ProfileState;
}
