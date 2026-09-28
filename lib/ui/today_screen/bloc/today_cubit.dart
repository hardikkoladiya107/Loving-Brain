import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import 'today_state.dart';

class TodayCubit extends Cubit<TodayState> {
  void toggleMode() {
    final current = state.mode;
    if (current == TodayMode.normal) {
      emit(state.copyWith(mode: TodayMode.newParent));
    } else if (current == TodayMode.newParent) {
      emit(state.copyWith(mode: TodayMode.importantHeadsUp));
    } else {
      emit(state.copyWith(mode: TodayMode.normal));
    }
  }

  TodayCubit() : super(const TodayState());

  Future<void> init() async {
    final hour = DateTime.now().hour;
    String greeting = 'GOOD MORNING';
    if (hour >= 12 && hour < 17) {
      greeting = 'GOOD AFTERNOON';
    } else if (hour >= 17) {
      greeting = 'GOOD EVENING';
    }

    var user = preferences.getUserModel();
    var child = preferences.getChildModel();

    String initialPName = user?.parentName ?? 'Parent';
    String initialCName = child?.childName ?? user?.childName ?? 'Child';
    if (initialPName.trim().isEmpty) initialPName = 'Parent';
    if (initialCName.trim().isEmpty) initialCName = 'Child';

    emit(
      state.copyWith(
        isLoading: true,
        timeOfDayGreeting: greeting,
        parentName: initialPName.toUpperCase(),
        childName: initialCName,
      ),
    );

    if (user?.uid != null && user!.uid!.isNotEmpty) {
      try {
        final freshUser = await AuthRepo.instance.syncUserAndDefaultChild(
          uId: user.uid!,
        );
        if (freshUser != null) {
          user = freshUser;
          child = preferences.getChildModel();
        }
      } catch (_) {}
    } else if (user != null && user.defaultChild != null) {
      try {
        final childSnap = await user.defaultChild!.get();
        if (childSnap.data() != null) {
          child = ChildModel.fromJson(
            childSnap.data() as Map<String, dynamic>,
            childSnap.reference,
          );
          await preferences.saveChildModel(child);
        }
      } catch (_) {}
    }

    String pName = user?.parentName ?? 'Parent';
    String cName = child?.childName ?? user?.childName ?? 'Child';
    if (pName.trim().isEmpty) pName = 'Parent';
    if (cName.trim().isEmpty) cName = 'Child';

    emit(
      state.copyWith(
        isLoading: false,
        timeOfDayGreeting: greeting,
        parentName: pName.toUpperCase(),
        childName: cName,
      ),
    );
  }

  // Sleep
  void setSleepQuality(int index) =>
      emit(state.copyWith(sleepQualityIndex: index));
  void setFellAsleepTime(String time) =>
      emit(state.copyWith(fellAsleepTime: time, showSleepUpdateErrors: false));
  void setWokeUpTime(String time) =>
      emit(state.copyWith(wokeUpTime: time, showSleepUpdateErrors: false));
  void triggerSleepUpdateErrors() =>
      emit(state.copyWith(showSleepUpdateErrors: true));
  void toggleNightWaking(bool val) => emit(state.copyWith(isNightWaking: val));

  // Mood
  void setChildMood(int index) => emit(
    state.copyWith(selectedChildMoodIndex: index, showMoodUpdateErrors: false),
  );
  void setParentMood(String mood) =>
      emit(state.copyWith(selectedParentMood: mood));
  void triggerMoodUpdateErrors() =>
      emit(state.copyWith(showMoodUpdateErrors: true));

  // Tantrum
  void setTantrumWhatHappened(String val) => emit(
    state.copyWith(tantrumWhatHappened: val, showTantrumUpdateErrors: false),
  );
  void setTantrumTime(String time) =>
      emit(state.copyWith(tantrumTime: time, showTantrumUpdateErrors: false));
  void setTantrumIntensity(double value) =>
      emit(state.copyWith(tantrumIntensity: value));
  void toggleTantrumTrigger(String trigger) {
    final triggers = List<String>.from(state.selectedTantrumTriggers);
    if (triggers.contains(trigger)) {
      triggers.remove(trigger);
    } else {
      triggers.add(trigger);
    }
    emit(
      state.copyWith(
        selectedTantrumTriggers: triggers,
        showTantrumUpdateErrors: false,
      ),
    );
  }

  void setTantrumWhatHelped(String val) => emit(
    state.copyWith(tantrumWhatHelped: val, showTantrumUpdateErrors: false),
  );
  void triggerTantrumUpdateErrors() =>
      emit(state.copyWith(showTantrumUpdateErrors: true));

  // Health
  void toggleHealthIssue(String issue) {
    final issues = List<String>.from(state.selectedHealthIssues);
    if (issues.contains(issue)) {
      issues.remove(issue);
    } else {
      issues.add(issue);
    }
    emit(
      state.copyWith(
        selectedHealthIssues: issues,
        showHealthUpdateErrors: false,
      ),
    );
  }

  void setHealthNotes(String val) =>
      emit(state.copyWith(healthNotes: val, showHealthUpdateErrors: false));
  void triggerHealthUpdateErrors() =>
      emit(state.copyWith(showHealthUpdateErrors: true));

  // Notes
  void setQuickNoteText(String val) =>
      emit(state.copyWith(quickNoteText: val, showNotesUpdateErrors: false));
  void triggerNotesUpdateErrors() =>
      emit(state.copyWith(showNotesUpdateErrors: true));

  Future<void> saveUpdate() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false, isSuccess: true));

    // Reset success state so it can trigger again later
    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(isSuccess: false));
  }
}
