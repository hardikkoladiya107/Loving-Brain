import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';

part 'consistency_recognition_state.freezed.dart';

@freezed
abstract class ConsistencyRecognitionState with _$ConsistencyRecognitionState {
  const factory ConsistencyRecognitionState({
    @Default(0) int daysCheckedIn,
    @Default('') String consistencyTitle,
    @Default('') String consistencySubtitle,
    @Default('') String consistencyDetail,
    ChildModel? child,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _ConsistencyRecognitionState;
}
