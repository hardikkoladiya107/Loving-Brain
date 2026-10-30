import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

import 'after_reflection_state.dart';

class AfterReflectionCubit extends Cubit<AfterReflectionState> {
  AfterReflectionCubit() : super(const AfterReflectionState());

  void init() {
    emit(const AfterReflectionState());
  }

  void reset() {
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
    bool? showErrors,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        saveStatus: saveStatus ?? ApiResultStatus.initial(),
        beforeEvent: beforeEvent ?? state.beforeEvent,
        durationText: durationText ?? state.durationText,
        intensityValue: intensityValue ?? state.intensityValue,
        selectedHelped: selectedHelped ?? state.selectedHelped,
        selectedFeeling: selectedFeeling ?? state.selectedFeeling,
        showErrors: showErrors ?? state.showErrors,
      ),
    );
  }

  void setBeforeEvent(String value) =>
      changeProps(beforeEvent: value, showErrors: false);
  void setDuration(String value) => changeProps(durationText: value);
  void setIntensity(double value) => changeProps(intensityValue: value);
  void setHelped(String value) =>
      changeProps(selectedHelped: value, showErrors: false);
  void setFeeling(String value) =>
      changeProps(selectedFeeling: value, showErrors: false);

  Future<bool> saveReflection() async {
    final bool hasInput =
        state.beforeEvent.trim().isNotEmpty ||
        state.selectedHelped.trim().isNotEmpty ||
        state.selectedFeeling.trim().isNotEmpty ||
        state.durationText.trim().isNotEmpty;

    if (!hasInput) {
      changeProps(
        showErrors: true,
        saveStatus: ApiResultStatus.error(
          error: Exception('Please add details or select what helped.'),
        ),
      );
      return false;
    }

    changeProps(isLoading: true, saveStatus: const ApiResultStatus.loading());

    try {
      final ChildModel? child = preferences.getChildModel();
      final String childId =
          child?.reference?.id ??
          TodayLogRepo.instance.resolveActiveChildId() ??
          '';

      final String eventDesc = state.beforeEvent.trim().isNotEmpty
          ? state.beforeEvent.trim()
          : (state.selectedHelped.isNotEmpty
                ? 'Calm reflection · Helped: ${state.selectedHelped}'
                : 'Calm reflection');
      final List<String> triggers = state.beforeEvent.trim().isNotEmpty
          ? <String>[state.beforeEvent.trim()]
          : <String>[];

      final TantrumLogModel log = TantrumLogModel(
        whatHappened: eventDesc,
        time: DateFormat('h:mm a').format(DateTime.now()),
        timestamp: DateTime.now(),
        intensity: state.intensityValue > 0 ? state.intensityValue : 0.5,
        triggers: triggers,
        whatHelped: state.selectedHelped.isNotEmpty ? state.selectedHelped : '',
        childId: childId.isNotEmpty ? childId : null,
      );

      if (childId.isNotEmpty) {
        final ApiResultStatus<String> result = await TodayLogRepo.instance
            .addTantrumLog(childId: childId, log: log);
        changeProps(isLoading: false, saveStatus: result);
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
