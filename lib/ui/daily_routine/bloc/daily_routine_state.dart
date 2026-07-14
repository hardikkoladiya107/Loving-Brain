import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/api_result_status.dart';
import '../../../model/child_model.dart';
import '../../../model/routine_category_model.dart';
import '../../../model/routine_model.dart';
import '../../../model/user_model.dart';

part 'daily_routine_state.freezed.dart';

@freezed
abstract class DailyRoutineState with _$DailyRoutineState {
  const factory DailyRoutineState({
    UserModel? userModel,
    ChildModel? childModel,
    DateTime? selectedDateTime,
    @Default("") String descriptionText,
    @Default("") String selectedType,
    @Default("") String timeError,
    @Default("") String descriptionError,
    @Default("") String typeError,
    @Default(ApiResultStatus.initial()) ApiResultStatus getRoutineTypeApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus addRoutineApiResult,
    @Default([]) List<RoutineCategoryModel> routineCategoryList,
    @Default([]) List<RoutineModel> routinesList,
  }) = _DailyRoutineState;
}
