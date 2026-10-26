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

    final String? childName = child?.childName?.trim();
    final String? userChildName = user?.childName?.trim();
    final String name = (childName != null && childName.isNotEmpty)
        ? childName
        : (userChildName != null && userChildName.isNotEmpty)
        ? userChildName
        : 'your child';

    final String? childAge = child?.childAge?.trim();
    final String? userChildAge = user?.childAge?.trim();
    final String age = (childAge != null && childAge.isNotEmpty)
        ? childAge
        : (userChildAge != null && userChildAge.isNotEmpty)
        ? userChildAge
        : '17 months';

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
