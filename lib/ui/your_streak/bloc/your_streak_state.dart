import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/user_model.dart';

part 'your_streak_state.freezed.dart';

@freezed
abstract class YourStreakState with _$YourStreakState {
  const factory YourStreakState({UserModel? userModel}) = _YourStreakState;
}
