import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/location_data_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import 'add_child_state.dart';

class AddChildCubit extends Cubit<AddChildState> {
  AddChildCubit() : super(const AddChildState());

  LocationDataModel? _locationData;
  LocationDataModel? get locationData => _locationData;

  void init() {
    final UserModel? user = preferences.getUserModel();
    _locationData =
        user?.locationData ?? LocationDataModel.tryParse(user?.location);
    final DateTime defaultDob = DateTime(
      DateTime.now().year - 2,
      DateTime.now().month,
      DateTime.now().day,
    );
    emit(
      AddChildState(
        childDob: defaultDob,
        dob: formatDobWithAge(defaultDob),
        location: _locationData?.formatted ?? (user?.location ?? ''),
        selectedConcerns: const <String>[],
      ),
    );
  }

  void reset() {
    _locationData = null;
    emit(const AddChildState());
  }

  void changeProps({
    String? name,
    String? dob,
    DateTime? childDob,
    String? concerns,
    String? location,
    List<String>? selectedConcerns,
    ApiResultStatus? saveStatus,
  }) {
    emit(
      state.copyWith(
        name: name ?? state.name,
        dob: dob ?? state.dob,
        childDob: childDob ?? state.childDob,
        concerns: concerns ?? state.concerns,
        location: location ?? state.location,
        selectedConcerns: selectedConcerns ?? state.selectedConcerns,
        saveStatus: saveStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  static String formatDobWithAge(DateTime? dob) {
    if (dob == null) return '';
    final String datePart = DateFormat('d MMMM yyyy').format(dob);
    final int months = AgeUtils.resolvedAgeInMonths(
      dob: dob,
      legacyAgeText: '',
    );
    final String agePart = AgeUtils.ageLabelFromMonths(months);
    if (agePart.isEmpty) return datePart;
    return '$datePart · $agePart';
  }

  void updateName(String name) {
    changeProps(name: name);
  }

  void updateDob(DateTime dob) {
    changeProps(childDob: dob, dob: formatDobWithAge(dob));
  }

  void toggleConcern(String concern) {
    final List<String> current = List<String>.from(state.selectedConcerns);
    if (current.contains(concern)) {
      current.remove(concern);
    } else {
      current.add(concern);
    }
    changeProps(selectedConcerns: current, concerns: current.join(', '));
  }

  void updateCustomConcerns(String text) {
    changeProps(concerns: text);
  }

  void updateLocationData(LocationDataModel? loc) {
    _locationData = loc;
    if (loc != null) {
      changeProps(location: loc.formatted);
    }
  }

  Future<void> submit() async {
    final String trimmedName = state.name.trim();
    if (trimmedName.isEmpty) {
      changeProps(
        saveStatus: ApiResultStatus.error(
          error: Exception("Please enter child's name"),
        ),
      );
      return;
    }

    changeProps(saveStatus: const ApiResultStatus.loading());

    try {
      final UserModel? user = preferences.getUserModel();
      final DateTime selectedDob = state.childDob ?? DateTime.now();
      final int ageInMonths = AgeUtils.resolvedAgeInMonths(
        dob: selectedDob,
        legacyAgeText: '',
      );
      final String computedAge = ageInMonths > 0
          ? AgeUtils.ageLabelFromMonths(ageInMonths)
          : '0 months';
      final LocationDataModel? resolvedLoc =
          _locationData ?? LocationDataModel.tryParse(state.location);

      final List<String> concernsList = state.concerns
          .split(',')
          .map((String e) => e.trim())
          .where((String e) => e.isNotEmpty)
          .toList();

      final Map<String, dynamic> createRequest = <String, dynamic>{
        'child_name': trimmedName,
        'child_age': computedAge,
        'relationship_to_child': user?.relationshipToChild ?? 'Parent',
        'concerns': concernsList,
        'primary_concern': concernsList.isNotEmpty ? concernsList.first : null,
        'location': resolvedLoc?.toJson() ?? state.location.trim(),
        if (resolvedLoc != null) 'location_data': resolvedLoc.toJson(),
        'child_dob': Timestamp.fromDate(selectedDob),
      };

      final ApiResultStatus<UserModel> result = await AuthRepo.instance
          .addChild(request: createRequest);

      if (result is Data<UserModel>) {
        changeProps(
          saveStatus: ApiResultStatus.data(
            data: "Added $trimmedName successfully",
          ),
        );
      } else if (result is Error<UserModel>) {
        changeProps(saveStatus: result);
      } else {
        changeProps(
          saveStatus: ApiResultStatus.data(
            data: "Added $trimmedName successfully",
          ),
        );
      }
    } catch (e) {
      changeProps(
        saveStatus: ApiResultStatus.error(
          error: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}
