import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey_state.freezed.dart';

enum JourneyMode { normal, harder, trying }

@freezed
abstract class JourneyState with _$JourneyState {
  const factory JourneyState({@Default(JourneyMode.normal) JourneyMode mode}) =
      _JourneyState;
}
