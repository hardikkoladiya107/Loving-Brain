import 'package:freezed_annotation/freezed_annotation.dart';

part 'connect_detail_state.freezed.dart';

@freezed
abstract class ConnectDetailState with _$ConnectDetailState {
  const factory ConnectDetailState({@Default("message") String message}) =
      _ConnectDetailState;
}
