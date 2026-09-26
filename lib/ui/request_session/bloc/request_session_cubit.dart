import 'package:flutter_bloc/flutter_bloc.dart';
import 'request_session_state.dart';

class RequestSessionCubit extends Cubit<RequestSessionState> {
  RequestSessionCubit() : super(const RequestSessionState());

  void updateMainConcern(String val) => emit(state.copyWith(mainConcern: val));
  void updateChildAge(String val) => emit(state.copyWith(childAge: val));
  void updatePreferredDays(String val) =>
      emit(state.copyWith(preferredDays: val));
  void updatePreferredLanguage(String val) =>
      emit(state.copyWith(preferredLanguage: val));
  void toggleShareSummary(bool share) =>
      emit(state.copyWith(shareSummary: share));

  Future<bool> submitRequest() async {
    emit(state.copyWith(isSubmitting: true));
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    emit(state.copyWith(isSubmitting: false));
    return true;
  }
}
