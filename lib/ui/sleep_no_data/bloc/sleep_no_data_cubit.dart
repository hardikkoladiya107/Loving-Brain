import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'sleep_no_data_state.dart';

class SleepNoDataCubit extends Cubit<SleepNoDataState> {
  SleepNoDataCubit() : super(const SleepNoDataState());

  String childName = 'your child';
  String childAge = '17 months';

  void init() {
    final user = preferences.getUserModel();
    final child = preferences.getChildModel();
    childName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'your child';

    if (child?.childAge != null && child!.childAge!.trim().isNotEmpty) {
      childAge = child.childAge!.trim();
    } else if (user?.childAge != null && user!.childAge!.trim().isNotEmpty) {
      childAge = user.childAge!.trim();
    }
    emit(const SleepNoDataState());
  }
}
