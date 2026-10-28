import 'package:flutter_bloc/flutter_bloc.dart';

import 'choose_support_area_state.dart';

/// Cubit managing Choose a Support Area (Screen 45).
/// Conforms to AGENTS.md Rule 4.2.
class ChooseSupportAreaCubit extends Cubit<ChooseSupportAreaState> {
  ChooseSupportAreaCubit() : super(const ChooseSupportAreaState());

  void init({String? initialArea}) {
    int index = -1;
    if (initialArea != null && initialArea.trim().isNotEmpty) {
      final String clean = initialArea.toLowerCase().trim();
      final int found = state.areas.indexWhere(
        (String a) =>
            a.toLowerCase() == clean ||
            clean.contains(a.toLowerCase()) ||
            a.toLowerCase().contains(clean),
      );
      if (found != -1) index = found;
    }
    changeProps(selectedIndex: index);
  }

  void changeProps({int? selectedIndex, List<String>? areas}) {
    emit(
      state.copyWith(
        selectedIndex: selectedIndex ?? state.selectedIndex,
        areas: areas ?? state.areas,
      ),
    );
  }

  void selectArea(int index) {
    changeProps(selectedIndex: index);
  }
}
