import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

import 'after_reflection_state.dart';

class AfterReflectionCubit extends Cubit<AfterReflectionState> {
  AfterReflectionCubit() : super(const AfterReflectionState());

  void init() {
    emit(const AfterReflectionState());
  }

  void changeProps({
    bool? isLoading,
    ApiResultStatus? saveStatus,
    String? beforeEvent,
    String? durationText,
    double? intensityValue,
    String? selectedHelped,
    String? selectedFeeling,
  }) {
    emit(state.copyWith(
      isLoading: isLoading ?? state.isLoading,
      saveStatus: saveStatus ?? ApiResultStatus.initial(),
      beforeEvent: beforeEvent ?? state.beforeEvent,
      durationText: durationText ?? state.durationText,
      intensityValue: intensityValue ?? state.intensityValue,
      selectedHelped: selectedHelped ?? state.selectedHelped,
      selectedFeeling: selectedFeeling ?? state.selectedFeeling,
    ));
  }

  void setBeforeEvent(String value) => changeProps(beforeEvent: value);
  void setDuration(String value) => changeProps(durationText: value);
  void setIntensity(double value) => changeProps(intensityValue: value);
  void setHelped(String value) => changeProps(selectedHelped: value);
  void setFeeling(String value) => changeProps(selectedFeeling: value);

  Future<bool> saveReflection() async {
    changeProps(
      isLoading: true,
      saveStatus: const ApiResultStatus.loading(),
    );

    try {
      final ChildModel? child = ChildRepo.instance.selectedChildModel;
      final String childId =
          child?.reference?.id ?? TodayLogRepo.instance.resolveActiveChildId() ?? '';

      final String eventDesc = state.beforeEvent.trim().isNotEmpty
          ? state.beforeEvent.trim()
          : 'Difficult moment';
      final String trigger = state.beforeEvent.trim().isNotEmpty
          ? state.beforeEvent.trim()
          : 'Transition';

      final TantrumLogModel log = TantrumLogModel(
        whatHappened: eventDesc,
        time: DateFormat('h:mm a').format(DateTime.now()),
        timestamp: DateTime.now(),
        intensity: state.intensityValue,
        triggers: <String>[trigger],
        whatHelped: state.selectedHelped,
        childId: childId.isNotEmpty ? childId : null,
      );

      if (childId.isNotEmpty) {
        final ApiResultStatus<String> result =
            await TodayLogRepo.instance.addTantrumLog(childId: childId, log: log);
        changeProps(
          isLoading: false,
          saveStatus: result,
        );
      } else {
        changeProps(
          isLoading: false,
          saveStatus: const ApiResultStatus.data(data: 'offline_saved'),
        );
      }
      return true;
    } catch (e) {
      changeProps(
        isLoading: false,
        saveStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
      return false;
    }
  }
}
