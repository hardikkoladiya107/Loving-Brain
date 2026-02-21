import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../model/routine_category_model.dart';
import '../../../model/routine_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/child_repo.dart';
import 'daily_routine_state.dart';

class DailyRoutineCubit extends Cubit<DailyRoutineState> {
  DailyRoutineCubit() : super(DailyRoutineState());

  void init() {
    emit(DailyRoutineState(userModel: preferences.getUserModel()));
    _fetchDailyRoutine();
    _listenToRoutine();
  }

  void changeProps({
    UserModel? userModel,
    ChildModel? childModel,
    DateTime? selectedDateTime,
    String? descriptionText,
    String? selectedType,
    String? timeError,
    String? descriptionError,
    String? typeError,
    ApiResultStatus? getRoutineTypeApiResult,
    ApiResultStatus? addRoutineApiResult,
    List<RoutineCategoryModel>? routineCategoryList,
    List<RoutineModel>? routinesList,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        selectedDateTime: selectedDateTime ?? state.selectedDateTime,
        descriptionText: descriptionText ?? state.descriptionText,
        selectedType: selectedType ?? state.selectedType,
        timeError: timeError ?? state.timeError,
        descriptionError: descriptionError ?? state.descriptionError,
        typeError: typeError ?? state.typeError,
        routinesList: routinesList ?? state.routinesList,
        routineCategoryList: routineCategoryList ?? state.routineCategoryList,
        getRoutineTypeApiResult:
            getRoutineTypeApiResult ?? state.getRoutineTypeApiResult,
        addRoutineApiResult:
            addRoutineApiResult ?? state.addRoutineApiResult,
      ),
    );
  }

  bool _isValid() {
    if (state.selectedDateTime == null ||
        state.descriptionText.isEmpty ||
        state.selectedType.isEmpty) {
      if (state.selectedDateTime == null) {
        changeProps(timeError: LocaleKeys.pleaseSelectTime.tr());
      } else {
        changeProps(timeError: "");
      }

      if (state.descriptionText.isEmpty) {
        changeProps(descriptionError: LocaleKeys.pleaseEnterDescription.tr());
      } else {
        changeProps(descriptionError: "");
      }

      if (state.selectedType.isEmpty) {
        changeProps(typeError: LocaleKeys.pleaseSelectType.tr());
      } else {
        changeProps(typeError: "");
      }
      return false;
    }
    changeProps(typeError: "", descriptionError: "", timeError: "");
    return true;
  }

  Future<void> addActivity() async {
    if (!_isValid()) return;
    final String? childId = state.userModel?.defaultChild?.id;
    if (childId == null || childId.isEmpty) {
      changeProps(
        addRoutineApiResult: ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChild.tr()),
        ),
      );
      return;
    }

    changeProps(addRoutineApiResult: ApiResultStatus.loading());
    final ApiResultStatus apiResultStatus = await ChildRepo.instance.addRoutine(
      request: {
        "time_stamp": Timestamp.fromDate(state.selectedDateTime!),
        "description": state.descriptionText,
        "type": state.selectedType,
      },
      id: childId,
    );
    changeProps(addRoutineApiResult: apiResultStatus);
  }

  Future<void> _fetchDailyRoutine() async {
    changeProps(getRoutineTypeApiResult: ApiResultStatus.loading());
    final ApiResultStatus apiResultStatus =
        await ChildRepo.instance.getAllRoutineCategories();
    changeProps(getRoutineTypeApiResult: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (dynamic data) {
        if (data is List<RoutineCategoryModel>) {
          changeProps(routineCategoryList: data);
        }
      },
    );
  }

  StreamSubscription? routineStreamSubscription;

  void _listenToRoutine() {
    if (state.userModel?.defaultChild != null) {
      routineStreamSubscription?.cancel();
      routineStreamSubscription = state.userModel?.defaultChild!
          .snapshots()
          .listen((event) {
            if (event.data() != null) {
              final ChildModel childModel = ChildModel.fromJson(
                event.data() as Map<String, dynamic>,
                event.reference,
              );
              changeProps(
                childModel: childModel,
                routinesList: childModel.routinesList ?? [],
              );
            }
          });
    }
  }

  @override
  Future<void> close() {
    routineStreamSubscription?.cancel();
    return super.close();
  }
}
