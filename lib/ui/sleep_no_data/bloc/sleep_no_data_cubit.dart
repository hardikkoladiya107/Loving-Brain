import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

import 'sleep_no_data_state.dart';

/// Cubit for Screen 64 (No Sleep Data Yet).
/// Conforms to AGENTS.md §4.2.
class SleepNoDataCubit extends Cubit<SleepNoDataState> {
  SleepNoDataCubit() : super(const SleepNoDataState());

  void init() {
    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();

    final String name =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'your child';

    String age = '17 months';
    if (child?.childAge != null && child!.childAge!.trim().isNotEmpty) {
      age = child.childAge!.trim();
    } else if (user?.childAge != null && user!.childAge!.trim().isNotEmpty) {
      age = user.childAge!.trim();
    }

    changeProps(childName: name, childAge: age, isLoading: false);
  }

  void changeProps({String? childName, String? childAge, bool? isLoading}) {
    emit(
      state.copyWith(
        childName: childName ?? state.childName,
        childAge: childAge ?? state.childAge,
        isLoading: isLoading ?? state.isLoading,
      ),
    );
  }
}
