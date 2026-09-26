import 'package:flutter_bloc/flutter_bloc.dart';
import 'sleep_pattern_state.dart';

class SleepPatternCubit extends Cubit<SleepPatternState> {
  SleepPatternCubit() : super(const SleepPatternState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isLoading: false));
  }

  void setToggleIndex(int index) =>
      emit(state.copyWith(selectedToggleIndex: index));
}
