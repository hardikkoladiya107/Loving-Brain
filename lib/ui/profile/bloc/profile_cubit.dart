import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/profile/bloc/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  void changeProps({
    bool? dailyEmotionCheck,
    bool? todaysPlayIdea,
    bool? scheduleReminder,
  }) {
    emit(
      state.copyWith(
        dailyEmotionCheck: dailyEmotionCheck ?? state.dailyEmotionCheck,
        todaysPlayIdea: todaysPlayIdea ?? state.todaysPlayIdea,
        scheduleReminder: scheduleReminder ?? state.scheduleReminder,
      ),
    );
  }
}
