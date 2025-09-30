import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../../model/behaviour_model.dart';
import '../../../model/user_model.dart';

part 'new_behavior_state.freezed.dart';

@freezed
abstract class NewBehaviorState with _$NewBehaviorState {
  const factory NewBehaviorState({
    @Default("") String selectedBehaviour,
    @Default("") String tellUsMoreText,
    @Default([]) List<BehaviourModel> behaviourList,
    UserModel? userModel,
    @Default(ApiResultStatus.initial()) ApiResultStatus getBehaviourApiResultStatus,
  }) = _NewBehaviorState;
}
