import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';

import '../../../model/user_model.dart';

part 'reflect_emotion_state.freezed.dart';

@freezed
abstract class ReflectEmotionState with _$ReflectEmotionState {
  const factory ReflectEmotionState({
    UserModel? userModel,
    ChildModel? childModel,
    List<ChildModel>? children,
    WeekRange? selectedWeek,
    @Default([]) List<MoodLogModel> logs,
    @Default(ApiResultStatus.initial()) ApiResultStatus emotionsLogApiResult,

    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus childrenListApiResult,
  }) = _ReflectEmotionState;
}
