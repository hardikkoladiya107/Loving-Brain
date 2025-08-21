import 'package:freezed_annotation/freezed_annotation.dart';

part 'essentials_state.freezed.dart';

@freezed
abstract class EssentialsState with _$EssentialsState {
  const factory EssentialsState({@Default("") String xyz}) = _EssentialsState;
}
