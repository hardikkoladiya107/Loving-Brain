import 'package:freezed_annotation/freezed_annotation.dart';

part 'brainy_home_state.freezed.dart';

@freezed
abstract class BrainyHomeState with _$BrainyHomeState {
  const factory BrainyHomeState({@Default('Behaviour') String selectedTopic}) =
      _BrainyHomeState;
}
