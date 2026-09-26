import 'package:flutter_bloc/flutter_bloc.dart';
import 'tonights_plan_state.dart';

class TonightsPlanCubit extends Cubit<TonightsPlanState> {
  TonightsPlanCubit() : super(const TonightsPlanState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isLoading: false));
  }

  Future<void> startPlan() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false, isPlanStarted: !state.isPlanStarted));
  }

  Future<void> toggleAudio() async {
    emit(state.copyWith(isAudioPlaying: !state.isAudioPlaying));
  }
}
