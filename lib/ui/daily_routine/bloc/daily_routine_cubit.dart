import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        selectedDateTime: selectedDateTime ?? state.selectedDateTime,
        descriptionText: descriptionText ?? state.descriptionText,
        selectedType: selectedType ?? state.selectedType,
        timeError: timeError ?? state.timeError,
        descriptionError: descriptionError ?? state.descriptionError,
        typeError: typeError ?? state.typeError,
        routinesList: routinesList ?? state.routinesList,
        routineCategoryList: routineCategoryList ?? state.routineCategoryList,
        getRoutineTypeApiResult:
            getRoutineTypeApiResult ?? ApiResultStatus.initial(),
        addRoutineApiResult:
        addRoutineApiResult ?? ApiResultStatus.initial(),
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
    if (_isValid()) {
      changeProps(addRoutineApiResult: ApiResultStatus.loading());
      var apiResultStatus = await ChildRepo.instance.addRoutine(
        request: {
          "time_stamp": Timestamp.fromDate(state.selectedDateTime!),
          "description": state.descriptionText,
          "type": "",
        },
        id: state.userModel?.defaultChild?.id
      );
      changeProps(addRoutineApiResult: apiResultStatus);
    }
  }


  Future<void> _fetchDailyRoutine() async {
    changeProps(getRoutineTypeApiResult: ApiResultStatus.loading());
    var apiResultStatus = await ChildRepo.instance.getAllRoutineCategories();
    changeProps(getRoutineTypeApiResult: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (data) {
        if (data is List<RoutineCategoryModel>) {
          changeProps(routineCategoryList: data);
        }
      },
    );
  }

  void _listenToRoutine() {
    if (state.userModel?.defaultChild != null) {
      state.userModel?.defaultChild!
          .collection("routines").orderBy("time_stamp",descending: true)
          .snapshots()
          .listen((event) {
        changeProps(
          routinesList: event.docs
              .map((e) => RoutineModel.fromJson(e.data()))
              .toList(),
        );
      });
    }
  }
}
