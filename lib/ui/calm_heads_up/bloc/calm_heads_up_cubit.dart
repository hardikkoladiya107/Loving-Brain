import 'package:flutter_bloc/flutter_bloc.dart';
import 'calm_heads_up_state.dart';

class CalmHeadsUpCubit extends Cubit<CalmHeadsUpState> {
  CalmHeadsUpCubit() : super(const CalmHeadsUpState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isLoading: false));
  }
}
