import 'package:flutter_bloc/flutter_bloc.dart';
import 'sleep_forecast_state.dart';

class SleepForecastCubit extends Cubit<SleepForecastState> {
  SleepForecastCubit() : super(const SleepForecastState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isLoading: false));
  }

  void selectDay(int index) => emit(state.copyWith(selectedDayIndex: index));
}
