import 'package:freezed_annotation/freezed_annotation.dart';

part 'play_and_connect_state.freezed.dart';

@freezed
abstract class PlayAndConnectState with _$PlayAndConnectState {
  const factory PlayAndConnectState({@Default("message") String message}) =
      _PlayAndConnectState;
}
