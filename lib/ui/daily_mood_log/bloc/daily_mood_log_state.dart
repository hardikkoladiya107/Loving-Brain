import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/user_model.dart';

import '../../../model/api_result_status.dart';

part 'daily_mood_log_state.freezed.dart';

@freezed
abstract class DailyMoodLogState with _$DailyMoodLogState {
  const factory DailyMoodLogState({
    UserModel? userModel,
    @Default([]) List<MoodLogModel> logs,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus logsApiResultStatus,
  }) = _DailyMoodLogState;
}
