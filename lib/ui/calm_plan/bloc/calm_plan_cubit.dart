import 'package:flutter_bloc/flutter_bloc.dart';
import 'calm_plan_state.dart';

class CalmPlanCubit extends Cubit<CalmPlanState> {
  CalmPlanCubit() : super(const CalmPlanState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isLoading: false));
  }

  void toggleAudio() {
    emit(state.copyWith(isAudioPlaying: !state.isAudioPlaying));
  }
}
