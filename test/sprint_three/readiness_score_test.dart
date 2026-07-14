import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/readiness_score.dart';
import 'package:loving_brain/model/child_state_model.dart';

void main() {
  test('ReadinessScore isReadyNow when calm, 8h sleep, score >= 75', () {
    final int score = ReadinessScore.calculate(
      moodLoggedToday: true,
      sleepHoursLastNight: 8,
      childState: ChildState.calm,
    );
    expect(score, greaterThanOrEqualTo(75));
    expect(
      ReadinessScore.isReadyNow(
        score: score,
        childState: ChildState.calm,
        sleepHoursLastNight: 8,
      ),
      isTrue,
    );
  });

  test('ReadinessScore not ready when fussy', () {
    final int score = ReadinessScore.calculate(
      moodLoggedToday: true,
      sleepHoursLastNight: 8,
      childState: ChildState.fussy,
    );
    expect(
      ReadinessScore.isReadyNow(
        score: score,
        childState: ChildState.fussy,
        sleepHoursLastNight: 8,
      ),
      isFalse,
    );
  });
}
