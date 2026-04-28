import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../model/behaviour_category_model.dart';
import '../../../model/behaviour_model.dart';
import '../../../model/user_model.dart';
import '../../../other/energy_bridge_rules.dart';
import '../../../other/preferances.dart';
import '../../../repo/behaviours_repo.dart';
import '../../../repo/energy_bridge_repo.dart';
import 'new_behavior_state.dart';

class NewBehaviorCubit extends Cubit<NewBehaviorState> {
  NewBehaviorCubit() : super(NewBehaviorState());

  void init() {
    emit(NewBehaviorState(userModel: preferences.getUserModel()));
    _getAllBehaviours();
    _listenToBehaviours();
  }

  void changeProps({
    List<BehaviourCategoryModel>? behaviourCategoryList,
    List<BehaviourModel>? behaviourList,
    ApiResultStatus? getBehaviourApiResultStatus,
    ApiResultStatus? addBehaviourApiResultStatus,
    UserModel? userModel,
    String? selectedBehaviour,
    String? tellUsMoreText,
    String? behaviourError,
  }) {
    emit(
      state.copyWith(
        behaviourCategoryList:
            behaviourCategoryList ?? state.behaviourCategoryList,
        behaviourList: behaviourList ?? state.behaviourList,
        tellUsMoreText: tellUsMoreText ?? state.tellUsMoreText,
        selectedBehaviour: selectedBehaviour ?? state.selectedBehaviour,
        userModel: userModel ?? state.userModel,
        behaviourError: behaviourError ?? state.behaviourError,
        addBehaviourApiResultStatus:
            addBehaviourApiResultStatus ?? ApiResultStatus.initial(),
        getBehaviourApiResultStatus:
            getBehaviourApiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> _getAllBehaviours() async {
    changeProps(getBehaviourApiResultStatus: ApiResultStatus.loading());
    var apiResultStatus = await BehavioursRepo.instance
        .getAllBehaviourCategories();
    changeProps(getBehaviourApiResultStatus: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (data) {
        if (data is List<BehaviourCategoryModel>) {
          changeProps(behaviourCategoryList: data);
        }
      },
    );
  }

  bool _isValidate() {
    if (state.selectedBehaviour.isEmpty) {
      changeProps(behaviourError: LocaleKeys.pleaseSelectBehaviour.tr());
      return false;
    }
    changeProps(behaviourError: "");
    return true;
  }

  Future<void> logBehaviour() async {
    if (_isValidate()) {
      changeProps(addBehaviourApiResultStatus: ApiResultStatus.loading());
      var apiResultStatus = await BehavioursRepo.instance.addChildBehaviour(
        id: state.userModel?.defaultChild?.id,
        request: {
          "behaviour": state.selectedBehaviour,
          "note": state.tellUsMoreText,
          "time_stamp": Timestamp.now(),
        },
      );
      changeProps(addBehaviourApiResultStatus: apiResultStatus);
      await _syncEnergyBridgeByBehavior(apiResultStatus);
    }
  }

  Future<void> _syncEnergyBridgeByBehavior(
    ApiResultStatus apiResultStatus,
  ) async {
    final String? childId = state.userModel?.defaultChild?.id;
    final String uid = state.userModel?.uid ?? '';
    final String selected = state.selectedBehaviour;
    if ((childId ?? '').isEmpty || uid.isEmpty) return;

    bool isSuccess = false;
    apiResultStatus.whenOrNull(data: (_) => isSuccess = true);
    if (!isSuccess) return;

    if (EnergyBridgeRules.isHighEnergy(selected)) {
      await EnergyBridgeRepo.instance.startTimer(
        childId: childId!,
        actorUid: uid,
        durationMinutes: 105,
      );
    } else if (EnergyBridgeRules.isResetMood(selected)) {
      await EnergyBridgeRepo.instance.resetTimer(
        childId: childId!,
        actorUid: uid,
        reason: selected.toLowerCase(),
      );
    }
  }

  void _listenToBehaviours() {
    if (state.userModel?.defaultChild != null) {
      state.userModel?.defaultChild!
          .collection("behaviours")
          .orderBy("time_stamp", descending: true)
          .snapshots()
          .listen((event) {
            changeProps(
              behaviourList: event.docs
                  .map((e) => BehaviourModel.fromJson(e.data()))
                  .toList(),
            );
          });
    }
  }
}
