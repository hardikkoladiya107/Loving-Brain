import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';

part 'essentials_state.freezed.dart';

@freezed
abstract class EssentialsState with _$EssentialsState {
  const factory EssentialsState({
    @Default("") String xyz,
    UserModel? userModel,
    ChildModel? childModel,
  }) = _EssentialsState;
}
