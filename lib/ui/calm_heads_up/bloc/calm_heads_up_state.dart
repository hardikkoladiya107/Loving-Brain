import 'package:freezed_annotation/freezed_annotation.dart';

part 'calm_heads_up_state.freezed.dart';

@freezed
abstract class CalmHeadsUpState with _$CalmHeadsUpState {
  const factory CalmHeadsUpState({@Default(false) bool isLoading}) =
      _CalmHeadsUpState;
}
