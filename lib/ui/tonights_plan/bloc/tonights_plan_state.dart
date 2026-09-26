import 'package:freezed_annotation/freezed_annotation.dart';

part 'tonights_plan_state.freezed.dart';

@freezed
abstract class TonightsPlanState with _$TonightsPlanState {
  const factory TonightsPlanState({
    @Default(false) bool isLoading,
    @Default(false) bool isPlanStarted,
    @Default(false) bool isAudioPlaying,
  }) = _TonightsPlanState;
}
