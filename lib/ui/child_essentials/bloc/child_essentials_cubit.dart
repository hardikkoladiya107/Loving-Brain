import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/preferances.dart';

import 'child_essentials_state.dart';

/// Cubit managing Child Essentials (Screen 53).
/// Conforms to AGENTS.md Rule 4.2.
class ChildEssentialsCubit extends Cubit<ChildEssentialsState> {
  ChildEssentialsCubit() : super(const ChildEssentialsState());

  void init() {
    final ChildModel? child = preferences.getChildModel();
    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : 'your child';

    changeProps(
      childName: cName,
      fetchStatus: const ApiResultStatus.data(data: null),
    );
  }

  void changeProps({
    bool? isLoading,
    String? childName,
    List<String>? allergies,
    List<String>? medications,
    List<String>? emergencyContacts,
    String? pediatrician,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        childName: childName ?? state.childName,
        allergies: allergies ?? state.allergies,
        medications: medications ?? state.medications,
        emergencyContacts: emergencyContacts ?? state.emergencyContacts,
        pediatrician: pediatrician ?? state.pediatrician,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void addAllergy(String item) {
    if (item.trim().isEmpty) return;
    final List<String> list = List<String>.from(state.allergies)
      ..add(item.trim());
    changeProps(allergies: list);
  }

  void addMedication(String item) {
    if (item.trim().isEmpty) return;
    final List<String> list = List<String>.from(state.medications)
      ..add(item.trim());
    changeProps(medications: list);
  }
}
