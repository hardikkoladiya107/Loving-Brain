import 'package:flutter_bloc/flutter_bloc.dart';
import 'session_request_confirmation_state.dart';

class SessionRequestConfirmationCubit
    extends Cubit<SessionRequestConfirmationState> {
  SessionRequestConfirmationCubit()
    : super(const SessionRequestConfirmationState());

  void init() {}
}
