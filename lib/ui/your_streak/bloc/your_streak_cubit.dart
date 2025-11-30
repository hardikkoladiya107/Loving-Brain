import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/your_streak/bloc/your_streak_state.dart';

import '../../../model/user_model.dart';
import '../../../other/preferances.dart';

class YourStreakCubit extends Cubit<YourStreakState> {
  YourStreakCubit() : super(YourStreakState());

  void init(){
    emit(YourStreakState(userModel: preferences.getUserModel()));
  }

  void changeProps({UserModel? userModel}){
    emit(state.copyWith(userModel: userModel ?? state.userModel));
  }
}
