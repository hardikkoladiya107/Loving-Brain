import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';

import '../../../model/user_model.dart';

part 'sleep_summary_state.freezed.dart';

@freezed
abstract class SleepSummaryState with _$SleepSummaryState {
  const factory SleepSummaryState({
    DateTime? selectedDate,
    DateTime? selectedBedTime,
    DateTime? selectedWakeTime,
    @Default("") String? notes,
    @Default("") String? bedTimeError,
    @Default("") String? selectedDateError,
    @Default("") String? wakeUpTimeError,
    @Default("") String? notesError,
    UserModel? userModel,
    ChildModel? childModel,
    WeekRange? selectedWeek,
    @Default([]) List<ChildModel> childList,
    @Default([]) List<WeekRange> weeks,
    @Default([]) List<SleepLogModel> sleepLogs,
    @Default(ApiResultStatus.initial()) ApiResultStatus emotionsLogApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus childrenListApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus addSleepLogApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus getSleepLogsApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
  }) = _SleepSummaryState;
}
