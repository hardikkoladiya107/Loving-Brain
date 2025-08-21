import 'package:freezed_annotation/freezed_annotation.dart';

part 'write_your_thought_state.freezed.dart';

@freezed
abstract class WriteYourThoughtState with _$WriteYourThoughtState {
  const factory WriteYourThoughtState({@Default("") String xyz}) =
      _WriteYourThoughtState;
}
