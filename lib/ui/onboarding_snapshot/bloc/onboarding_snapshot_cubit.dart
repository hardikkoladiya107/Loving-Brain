import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/api_result_status.dart';
import 'onboarding_snapshot_state.dart';

class OnboardingSnapshotCubit extends Cubit<OnboardingSnapshotState> {
  OnboardingSnapshotCubit() : super(const OnboardingSnapshotState());

  void init() {
    emit(const OnboardingSnapshotState());
  }

  void changeProps({ApiResultStatus? status}) {
    emit(state.copyWith(status: status ?? ApiResultStatus.initial()));
  }
}
