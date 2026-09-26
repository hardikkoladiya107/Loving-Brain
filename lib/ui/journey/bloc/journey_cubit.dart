import 'package:flutter_bloc/flutter_bloc.dart';
import 'journey_state.dart';

class JourneyCubit extends Cubit<JourneyState> {
  JourneyCubit() : super(const JourneyState());
  void cycleMode() {
    final nextMode =
        JourneyMode.values[(state.mode.index + 1) % JourneyMode.values.length];
    emit(state.copyWith(mode: nextMode));
  }
}
