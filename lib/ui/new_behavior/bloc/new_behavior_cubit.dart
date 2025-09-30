import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/api_result_status.dart';
import '../../../model/behaviour_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/behaviours_repo.dart';
import 'new_behavior_state.dart';

class NewBehaviorCubit extends Cubit<NewBehaviorState> {
  NewBehaviorCubit() : super(NewBehaviorState());

  void init() {
    emit(NewBehaviorState(userModel: preferences.getUserModel()));
    _getAllBehaviours();
  }

  void changeProps({
    List<BehaviourModel>? behaviourList,
    ApiResultStatus? getBehaviourApiResultStatus,
    UserModel? userModel,
    String? selectedBehaviour,
    String? tellUsMoreText,
  }) {
    emit(
      state.copyWith(
        behaviourList: behaviourList ?? state.behaviourList,
        tellUsMoreText: tellUsMoreText ?? state.tellUsMoreText,
        selectedBehaviour: selectedBehaviour ?? state.selectedBehaviour,
        userModel: userModel ?? state.userModel,
        getBehaviourApiResultStatus:
            getBehaviourApiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> _getAllBehaviours() async {
    changeProps(getBehaviourApiResultStatus: ApiResultStatus.loading());
    var apiResultStatus = await BehavioursRepo.instance.getAllBehaviours();
    changeProps(getBehaviourApiResultStatus: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (data) {
        if (data is List<BehaviourModel>) {
          changeProps(behaviourList: data);
        }
      },
    );
  }

  void logBehaviour() {

  }
}
