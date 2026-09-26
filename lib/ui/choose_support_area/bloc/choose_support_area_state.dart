import 'package:freezed_annotation/freezed_annotation.dart';

part 'choose_support_area_state.freezed.dart';

@freezed
abstract class ChooseSupportAreaState with _$ChooseSupportAreaState {
  const factory ChooseSupportAreaState({@Default(0) int selectedIndex}) =
      _ChooseSupportAreaState;
}
