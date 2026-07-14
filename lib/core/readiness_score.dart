import 'package:loving_brain/model/child_state_model.dart';

/// Sprint 3 readiness score per Hardik guide.
///
/// `readiness = (mood*40) + (sleep*35) + (stability*25)` with each weight 0–100.
class ReadinessScore {
  ReadinessScore._();

  static int calculate({
    required bool moodLoggedToday,
    required double sleepHoursLastNight,
    required ChildState? childState,
  }) {
    final int moodWeight = moodLoggedToday ? 100 : 0;
    final int sleepWeight = _sleepWeight(sleepHoursLastNight);
    final int stabilityWeight = _stabilityWeight(childState);
    return ((moodWeight * 40) +
            (sleepWeight * 35) +
            (stabilityWeight * 25)) ~/
        100;
  }

  static bool isReadyNow({
    required int score,
    required ChildState? childState,
    required double sleepHoursLastNight,
  }) {
    return score >= 75 &&
        childState == ChildState.calm &&
        sleepHoursLastNight >= 8;
  }

  static int _sleepWeight(double hours) {
    if (hours >= 8) {
      return 100;
    }
    if (hours <= 0) {
      return 0;
    }
    return (hours / 8 * 100).round().clamp(0, 100);
  }

  static int _stabilityWeight(ChildState? childState) {
    if (childState == ChildState.calm) {
      return 100;
    }
    if (childState == ChildState.tired || childState == ChildState.highEnergy) {
      return 60;
    }
    if (childState == ChildState.fussy) {
      return 30;
    }
    return 50;
  }
}
