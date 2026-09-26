import 'package:flutter_bloc/flutter_bloc.dart';
import 'sleep_details_state.dart';

class SleepDetailsCubit extends Cubit<SleepDetailsState> {
  SleepDetailsCubit() : super(const SleepDetailsState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isLoading: false));
  }
}
