import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../model/api_result_status.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void init() {
    emit(const OnboardingState());
  }

  void changeProps({
    int? currentPage,
    int? totalPages,
    String? parentName,
    String? parentRole,
    String? preferredLanguage,
    String? location,
    String? primaryConcern,
    List<String>? concerns,
    bool? isMoreThanOneSelected,
    String? successGoal,
    String? childName,
    String? dateOfBirth,
    DateTime? childDob,
    String? childGender,
    String? usualWakeTime,
    String? usualBedtime,
    int? usualNaps,
    String? nightWakings,
    List<String>? difficultTimes,
    List<String>? possibleTriggers,
    ApiResultStatus? completeStatus,
  }) {
    emit(
      state.copyWith(
        currentPage: currentPage ?? state.currentPage,
        totalPages: totalPages ?? state.totalPages,
        parentName: parentName ?? state.parentName,
        parentRole: parentRole ?? state.parentRole,
        preferredLanguage: preferredLanguage ?? state.preferredLanguage,
        location: location ?? state.location,
        primaryConcern: primaryConcern ?? state.primaryConcern,
        concerns: concerns ?? state.concerns,
        isMoreThanOneSelected:
            isMoreThanOneSelected ?? state.isMoreThanOneSelected,
        successGoal: successGoal ?? state.successGoal,
        childName: childName ?? state.childName,
        dateOfBirth: dateOfBirth ?? state.dateOfBirth,
        childDob: childDob ?? state.childDob,
        childGender: childGender ?? state.childGender,
        usualWakeTime: usualWakeTime ?? state.usualWakeTime,
        usualBedtime: usualBedtime ?? state.usualBedtime,
        usualNaps: usualNaps ?? state.usualNaps,
        nightWakings: nightWakings ?? state.nightWakings,
        difficultTimes: difficultTimes ?? state.difficultTimes,
        possibleTriggers: possibleTriggers ?? state.possibleTriggers,
        completeStatus: completeStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void onPageChanged(int index) {
    changeProps(currentPage: index);
  }

  void updateParentName(String name) {
    changeProps(parentName: name);
  }

  void selectParentRole(String role) {
    changeProps(parentRole: role);
  }

  void selectPreferredLanguage(String language) {
    changeProps(preferredLanguage: language);
  }

  void updateLocation(String location) {
    changeProps(location: location);
  }

  void selectConcern(String concern) {
    if (state.isMoreThanOneSelected) {
      final List<String> updated = List<String>.from(state.concerns);
      if (updated.contains(concern)) {
        if (updated.length > 1) {
          updated.remove(concern);
        }
      } else {
        updated.add(concern);
      }
      changeProps(
        concerns: updated,
        primaryConcern: updated.isNotEmpty ? updated.first : concern,
      );
    } else {
      changeProps(primaryConcern: concern, concerns: <String>[concern]);
    }
  }

  void toggleMoreThanOne() {
    final bool updated = !state.isMoreThanOneSelected;
    changeProps(isMoreThanOneSelected: updated);
  }

  void selectSuccessGoal(String goal) {
    changeProps(successGoal: goal);
  }

  void updateChildName(String name) {
    changeProps(childName: name);
  }

  void updateChildDob({required String formattedDate, required DateTime dob}) {
    changeProps(dateOfBirth: formattedDate, childDob: dob);
  }

  void selectChildGender(String gender) {
    changeProps(childGender: gender);
  }

  void updateWakeTime(String time) {
    changeProps(usualWakeTime: time);
  }

  void updateBedtime(String time) {
    changeProps(usualBedtime: time);
  }

  void updateUsualNaps(int delta) {
    final int updated = (state.usualNaps + delta).clamp(0, 10);
    changeProps(usualNaps: updated);
  }

  void selectNightWakings(String option) {
    changeProps(nightWakings: option);
  }

  void toggleDifficultTime(String time) {
    final List<String> updated = List<String>.from(state.difficultTimes);
    if (updated.contains(time)) {
      updated.remove(time);
    } else {
      updated.add(time);
    }
    changeProps(difficultTimes: updated);
  }

  void togglePossibleTrigger(String trigger) {
    final List<String> updated = List<String>.from(state.possibleTriggers);
    if (updated.contains(trigger)) {
      updated.remove(trigger);
    } else {
      updated.add(trigger);
    }
    changeProps(possibleTriggers: updated);
  }

  Future<void> completeOnboarding() async {
    changeProps(completeStatus: ApiResultStatus.loading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      changeProps(completeStatus: ApiResultStatus.data(data: true));
    } catch (e) {
      changeProps(
        completeStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }
}
