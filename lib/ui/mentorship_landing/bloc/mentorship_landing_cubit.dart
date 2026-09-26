import 'package:flutter_bloc/flutter_bloc.dart';
import 'mentorship_landing_state.dart';

class MentorshipLandingCubit extends Cubit<MentorshipLandingState> {
  MentorshipLandingCubit() : super(const MentorshipLandingState());
  void toggleAvailability() {
    emit(state.copyWith(isAvailable: !state.isAvailable));
  }
}
