import 'package:freezed_annotation/freezed_annotation.dart';

part 'consistency_recognition_state.freezed.dart';

@freezed
abstract class ConsistencyRecognitionState with _$ConsistencyRecognitionState {
  const factory ConsistencyRecognitionState() = _ConsistencyRecognitionState;
}
