import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/user_model.dart';

import '../../../model/api_result_status.dart';

part 'daily_mood_check_in_state.freezed.dart';

@freezed
abstract class DailyMoodCheckInState with _$DailyMoodCheckInState {
  const factory DailyMoodCheckInState({
    @Default("") String childMood,
    @Default("") String parentMood,
    UserModel? userModel,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
  }) = _DailyMoodCheckInState;
}
