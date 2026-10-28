import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/essential_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/child_repo.dart';

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

    List<String> allergies = <String>[];
    List<String> medications = <String>[];

    if (child?.essentials != null) {
      for (final EssentialNote note in child!.essentials!) {
        final String t = (note.title ?? '').trim().toLowerCase();
        final String d = (note.description ?? '').trim();
        if (d.isNotEmpty) {
          if (t == 'allergies' || t == 'allergy') {
            allergies.addAll(
              d
                  .split(',')
                  .map((String s) => s.trim())
                  .where((String s) => s.isNotEmpty),
            );
          } else if (t == 'medications' || t == 'medication') {
            medications.addAll(
              d
                  .split(',')
                  .map((String s) => s.trim())
                  .where((String s) => s.isNotEmpty),
            );
          }
        }
      }
    }

    allergies = allergies.toSet().toList();
    medications = medications.toSet().toList();

    changeProps(
      childName: cName,
      allergies: state.allergies.isNotEmpty ? state.allergies : allergies,
      medications: state.medications.isNotEmpty
          ? state.medications
          : medications,
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
    final String trimmed = item.trim();
    if (trimmed.isEmpty) return;
    if (state.allergies.any(
      (String s) => s.toLowerCase() == trimmed.toLowerCase(),
    )) {
      return;
    }
    final List<String> list = List<String>.from(state.allergies)..add(trimmed);
    changeProps(allergies: list);
    _persistEssentials(allergies: list, medications: state.medications);
  }

  void removeAllergy(int index) {
    if (index < 0 || index >= state.allergies.length) return;
    final List<String> list = List<String>.from(state.allergies)
      ..removeAt(index);
    changeProps(allergies: list);
    _persistEssentials(allergies: list, medications: state.medications);
  }

  void updateAllergy(int index, String newName) {
    final String trimmed = newName.trim();
    if (trimmed.isEmpty || index < 0 || index >= state.allergies.length) return;
    final List<String> list = List<String>.from(state.allergies);
    list[index] = trimmed;
    changeProps(allergies: list);
    _persistEssentials(allergies: list, medications: state.medications);
  }

  void addMedication(String item) {
    final String trimmed = item.trim();
    if (trimmed.isEmpty) return;
    if (state.medications.any(
      (String s) => s.toLowerCase() == trimmed.toLowerCase(),
    )) {
      return;
    }
    final List<String> list = List<String>.from(state.medications)
      ..add(trimmed);
    changeProps(medications: list);
    _persistEssentials(allergies: state.allergies, medications: list);
  }

  void updateMedication(int index, String newName) {
    final String trimmed = newName.trim();
    if (trimmed.isEmpty || index < 0 || index >= state.medications.length) {
      return;
    }
    final List<String> list = List<String>.from(state.medications);
    list[index] = trimmed;
    changeProps(medications: list);
    _persistEssentials(allergies: state.allergies, medications: list);
  }

  void removeMedication(int index) {
    if (index < 0 || index >= state.medications.length) return;
    final List<String> list = List<String>.from(state.medications)
      ..removeAt(index);
    changeProps(medications: list);
    _persistEssentials(allergies: state.allergies, medications: list);
  }

  Future<void> _persistEssentials({
    required List<String> allergies,
    required List<String> medications,
  }) async {
    try {
      final ChildModel? currentChild = preferences.getChildModel();
      if (currentChild == null) return;

      final List<EssentialNote> newEssentials = <EssentialNote>[];
      if (allergies.isNotEmpty) {
        newEssentials.add(
          EssentialNote(title: 'Allergies', description: allergies.join(', ')),
        );
      }
      if (medications.isNotEmpty) {
        newEssentials.add(
          EssentialNote(
            title: 'Medications',
            description: medications.join(', '),
          ),
        );
      }
      if (currentChild.essentials != null) {
        for (final EssentialNote note in currentChild.essentials!) {
          final String t = (note.title ?? '').trim().toLowerCase();
          if (t != 'allergies' &&
              t != 'allergy' &&
              t != 'medications' &&
              t != 'medication') {
            newEssentials.add(note);
          }
        }
      }

      final ChildModel updatedChild = currentChild.copyWith(
        essentials: newEssentials,
      );
      await preferences.saveChildModel(updatedChild);

      final String childId = currentChild.reference?.id ?? '';
      if (childId.isNotEmpty) {
        await ChildRepo.instance.updateEssentials(
          documentReference: childId,
          request: <String, dynamic>{
            'essentials': newEssentials
                .map((EssentialNote e) => e.toJson())
                .toList(),
          },
        );
      }
    } catch (_) {}
  }
}
