import 'package:flutter_bloc/flutter_bloc.dart';
import 'choose_support_area_state.dart';

class ChooseSupportAreaCubit extends Cubit<ChooseSupportAreaState> {
  ChooseSupportAreaCubit() : super(const ChooseSupportAreaState());
  void selectArea(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
