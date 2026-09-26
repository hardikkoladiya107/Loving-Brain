import 'package:flutter_bloc/flutter_bloc.dart';
import 'after_reflection_state.dart';

class AfterReflectionCubit extends Cubit<AfterReflectionState> {
  AfterReflectionCubit() : super(const AfterReflectionState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isLoading: false));
  }

  void setIntensity(double value) =>
      emit(state.copyWith(intensityValue: value));
  void setHelped(String value) => emit(state.copyWith(selectedHelped: value));
  void setFeeling(String value) => emit(state.copyWith(selectedFeeling: value));
}
