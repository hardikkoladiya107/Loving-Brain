import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    UserModel? userModel,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
    ChildModel? childModel,
    @Default(false) bool moodLoggedForToday,
  }) = _HomeState;
}
