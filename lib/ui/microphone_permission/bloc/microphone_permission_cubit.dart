import 'package:flutter_bloc/flutter_bloc.dart';
import 'microphone_permission_state.dart';

class MicrophonePermissionCubit extends Cubit<MicrophonePermissionState> {
  MicrophonePermissionCubit() : super(const MicrophonePermissionState());

  void init() {}
}
