import 'package:flutter_bloc/flutter_bloc.dart';
import 'brainy_home_state.dart';

class BrainyHomeCubit extends Cubit<BrainyHomeState> {
  BrainyHomeCubit() : super(const BrainyHomeState());

  void setTopic(String topic) {
    emit(state.copyWith(selectedTopic: topic));
  }
}
