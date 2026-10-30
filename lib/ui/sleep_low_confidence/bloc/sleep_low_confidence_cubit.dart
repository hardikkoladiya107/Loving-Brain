import 'package:flutter_bloc/flutter_bloc.dart';

import 'sleep_low_confidence_state.dart';

/// Cubit for Screen 69 (Low Confidence Sleep Window).
/// Conforms to AGENTS.md §4.2.
class SleepLowConfidenceCubit extends Cubit<SleepLowConfidenceState> {
  SleepLowConfidenceCubit() : super(const SleepLowConfidenceState());

  void init() {
    emit(const SleepLowConfidenceState());
  }

  void reset() {
    emit(const SleepLowConfidenceState());
  }

  void changeProps({
    String? windowTimeRange,
    int? nightsCount,
    String? confidence,
    String? explanation,
    bool? isLoading,
  }) {
    emit(
      state.copyWith(
        windowTimeRange: windowTimeRange ?? state.windowTimeRange,
        nightsCount: nightsCount ?? state.nightsCount,
        confidence: confidence ?? state.confidence,
        explanation: explanation ?? state.explanation,
        isLoading: isLoading ?? state.isLoading,
      ),
    );
  }
}
