import 'package:freezed_annotation/freezed_annotation.dart';
part 'propose_change_state.freezed.dart';

@freezed
abstract class ProposeChangeState with _$ProposeChangeState {
  const factory ProposeChangeState({@Default("") String message}) =
  _ProposeChangeState;
}
