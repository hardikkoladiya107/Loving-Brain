import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/location_data_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import 'child_profile_v2_state.dart';

class ChildProfileV2Cubit extends Cubit<ChildProfileV2State> {
  ChildProfileV2Cubit() : super(const ChildProfileV2State());

  LocationDataModel? _locationData;
  LocationDataModel? get locationData => _locationData;

  void changeProps({
    ChildModel? childModel,
    String? name,
    String? age,
    String? conditions,
    String? dob,
    DateTime? childDob,
    String? concerns,
    String? location,
    bool? isEdited,
    ApiResultStatus? saveStatus,
  }) {
    emit(
      state.copyWith(
        childModel: childModel ?? state.childModel,
        name: name ?? state.name,
        age: age ?? state.age,
        conditions: conditions ?? state.conditions,
        dob: dob ?? state.dob,
        childDob: childDob ?? state.childDob,
        concerns: concerns ?? state.concerns,
        location: location ?? state.location,
        isEdited: isEdited ?? state.isEdited,
        saveStatus: saveStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  static String formatDobWithAge(DateTime? dob, String fallbackAge) {
    if (dob == null) {
      return fallbackAge;
    }
    final String datePart = DateFormat('d MMMM yyyy').format(dob);
    final int months = AgeUtils.resolvedAgeInMonths(
      dob: dob,
      legacyAgeText: fallbackAge,
    );
    final String agePart = AgeUtils.ageLabelFromMonths(months);
    if (agePart.isEmpty) {
      return datePart;
    }
    return '$datePart · $agePart';
  }

  static String _extractConcernsText(
    ChildModel childModel,
    Map<String, dynamic>? rawData,
  ) {
    if (childModel.concerns != null && childModel.concerns!.isNotEmpty) {
      return childModel.concerns!.join(', ');
    }
    final dynamic rawConcerns = rawData?['concerns'];
    if (rawConcerns is List) {
      return rawConcerns
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .join(', ');
    }
    if (rawConcerns is String && rawConcerns.trim().isNotEmpty) {
      return rawConcerns.trim();
    }
    if ((childModel.primaryConcern ?? '').trim().isNotEmpty) {
      return childModel.primaryConcern!.trim();
    }
    return '';
  }

  void reset() {
    _locationData = null;
    emit(const ChildProfileV2State());
  }

  Future<void> init({bool createNew = false}) async {
    final DateTime today = DateTime.now();
    if (createNew) {
      final UserModel? user = preferences.getUserModel();
      _locationData =
          user?.locationData ?? LocationDataModel.tryParse(user?.location);
      changeProps(
        childDob: today,
        dob: formatDobWithAge(today, ''),
        location: _locationData?.formatted ?? (user?.location ?? ''),
        isEdited: false,
      );
      return;
    }

    final UserModel? user = preferences.getUserModel();
    final ChildModel? localChild = preferences.getChildModel();

    if (localChild != null) {
      final String initialAge = localChild.childAge ?? user?.childAge ?? '';
      final DateTime initialDob = localChild.childDob ?? today;
      _locationData =
          localChild.locationData ??
          user?.locationData ??
          LocationDataModel.tryParse(localChild.location ?? user?.location);
      changeProps(
        childModel: localChild,
        name: localChild.childName ?? user?.childName ?? '',
        age: initialAge,
        childDob: initialDob,
        dob: formatDobWithAge(initialDob, initialAge),
        conditions: (localChild.conditions ?? const <String>[]).join(', '),
        concerns: _extractConcernsText(localChild, null),
        location:
            _locationData?.formatted ??
            localChild.location ??
            user?.location ??
            '',
        isEdited: false,
      );
    } else if (user != null) {
      _locationData =
          user.locationData ?? LocationDataModel.tryParse(user.location);
      changeProps(
        name: user.childName ?? '',
        age: user.childAge ?? '',
        childDob: today,
        dob: formatDobWithAge(today, user.childAge ?? ''),
        location: _locationData?.formatted ?? user.location ?? '',
        isEdited: false,
      );
    }

    final List<DocumentReference<Object?>?>? userChildren = user?.children;
    final DocumentReference<Object?>? childRef =
        user?.defaultChild ??
        localChild?.reference ??
        ((userChildren != null && userChildren.isNotEmpty)
            ? userChildren.first
            : null);

    if (childRef != null) {
      try {
        final DocumentSnapshot<Object?> doc = await childRef.get();
        final Object? docData = doc.data();
        if (doc.exists && docData is Map<String, dynamic>) {
          final Map<String, dynamic> data = docData;
          final ChildModel childModel = ChildModel.fromJson(
            data,
            doc.reference,
          );
          await preferences.saveDefaultChildModel(childModel);

          final String resolvedAge =
              childModel.childAge ?? user?.childAge ?? '';
          final DateTime resolvedDob = childModel.childDob ?? today;
          final String conditionsStr = data['conditions'] is List
              ? (data['conditions'] as List)
                    .map((e) => e?.toString() ?? '')
                    .where((s) => s.isNotEmpty)
                    .join(', ')
              : (data['conditions']?.toString() ?? '');
          _locationData =
              childModel.locationData ??
              user?.locationData ??
              LocationDataModel.tryParse(childModel.location ?? user?.location);

          changeProps(
            childModel: childModel,
            name: childModel.childName ?? user?.childName ?? '',
            age: resolvedAge,
            conditions: conditionsStr,
            childDob: resolvedDob,
            dob: formatDobWithAge(resolvedDob, resolvedAge),
            concerns: _extractConcernsText(childModel, data),
            location:
                (childModel.location != null &&
                    childModel.location!.trim().isNotEmpty)
                ? childModel.location!
                : (user?.location ?? _locationData?.formatted ?? ''),
          );
        }
      } catch (_) {}
    }
  }

  void updateLocationData(LocationDataModel data) {
    _locationData = data;
    updateField(location: data.formatted);
  }

  void updateField({
    String? name,
    String? age,
    String? conditions,
    String? dob,
    DateTime? childDob,
    String? concerns,
    String? location,
  }) {
    if (location != null && _locationData?.formatted != location) {
      _locationData = LocationDataModel.tryParse(location);
    }
    changeProps(
      name: name ?? state.name,
      age: age ?? state.age,
      conditions: conditions ?? state.conditions,
      dob: dob ?? state.dob,
      childDob: childDob ?? state.childDob,
      concerns: concerns ?? state.concerns,
      location: location ?? state.location,
      isEdited: true,
      saveStatus: const ApiResultStatus.initial(),
    );
  }

  void updateDob(DateTime picked) {
    final int months = AgeUtils.resolvedAgeInMonths(
      dob: picked,
      legacyAgeText: state.age,
    );
    final String ageLabel = AgeUtils.ageLabelFromMonths(months);
    final String formatted = formatDobWithAge(picked, ageLabel);
    updateField(childDob: picked, age: ageLabel, dob: formatted);
  }

  Future<void> saveProfile() async {
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
      final ChildModel? child = state.childModel;
      final DateTime? selectedDob = state.childDob ?? child?.childDob;
      final int ageInMonths = AgeUtils.resolvedAgeInMonths(
        dob: selectedDob,
        legacyAgeText: state.age,
      );
      final String computedAge = ageInMonths > 0
          ? AgeUtils.ageLabelFromMonths(ageInMonths)
          : state.age;
      final LocationDataModel? resolvedLoc =
          _locationData ?? LocationDataModel.tryParse(state.location);

      final List<String> concernsList = state.concerns
          .split(',')
          .map((String e) => e.trim())
          .where((String e) => e.isNotEmpty)
          .toList();

      final DocumentReference<Object?>? childRef =
          child?.reference ?? user?.defaultChild;

      if (childRef != null) {
        final Map<String, dynamic> updatePayload = <String, dynamic>{
          'child_name': trimmedName,
          'child_age': computedAge,
          'concerns': concernsList,
          'primary_concern': concernsList.isNotEmpty
              ? concernsList.first
              : null,
          'location': resolvedLoc?.toJson() ?? state.location.trim(),
          if (resolvedLoc != null) 'location_data': resolvedLoc.toJson(),
        };
        if (selectedDob != null) {
          updatePayload['child_dob'] = Timestamp.fromDate(selectedDob);
        }
        if (state.conditions.trim().isNotEmpty) {
          updatePayload['conditions'] = state.conditions
              .split(',')
              .map((String e) => e.trim())
              .where((String e) => e.isNotEmpty)
              .toList();
        }

        await childRef.update(updatePayload);

        final String? userUid = user?.uid;
        if (userUid != null && userUid.isNotEmpty) {
          final Map<String, dynamic> userUpdate = <String, dynamic>{
            'child_name': trimmedName,
            'child_age': computedAge,
          };
          if (state.location.trim().isNotEmpty || resolvedLoc != null) {
            userUpdate['location'] =
                resolvedLoc?.toJson() ?? state.location.trim();
            if (resolvedLoc != null) {
              userUpdate['location_data'] = resolvedLoc.toJson();
            }
          }
          await AuthRepo.instance.updateUserToFireStore(
            uId: userUid,
            request: userUpdate,
          );
          await AuthRepo.instance.syncUserAndDefaultChild(uId: userUid);
        }

        final DocumentSnapshot<Object?> doc = await childRef.get();
        final Object? docData = doc.data();
        if (doc.exists && docData is Map<String, dynamic>) {
          final ChildModel newChild = ChildModel.fromJson(
            docData,
            doc.reference,
          );
          await preferences.saveDefaultChildModel(newChild);
          changeProps(
            childModel: newChild,
            name: trimmedName,
            age: computedAge,
            childDob: selectedDob,
            dob: formatDobWithAge(selectedDob, computedAge),
            isEdited: false,
            saveStatus: const ApiResultStatus.data(
              data: 'Profile saved successfully',
            ),
          );
          return;
        }
      } else {
        final Map<String, dynamic> createRequest = <String, dynamic>{
          'child_name': trimmedName,
          'child_age': computedAge,
          'relationship_to_child': user?.relationshipToChild ?? 'Parent',
          'concerns': concernsList,
          'primary_concern': concernsList.isNotEmpty
              ? concernsList.first
              : null,
          'location': resolvedLoc?.toJson() ?? state.location.trim(),
          if (resolvedLoc != null) 'location_data': resolvedLoc.toJson(),
        };
        if (selectedDob != null) {
          createRequest['child_dob'] = Timestamp.fromDate(selectedDob);
        }
        final ApiResultStatus<UserModel> result = await AuthRepo.instance
            .addChild(request: createRequest);
        if (result is Data<UserModel>) {
          final ChildModel? newChild = preferences.getChildModel();
          changeProps(
            childModel: newChild,
            name: trimmedName,
            age: computedAge,
            childDob: selectedDob,
            dob: formatDobWithAge(selectedDob, computedAge),
            isEdited: false,
            saveStatus: const ApiResultStatus.data(
              data: 'Profile saved successfully',
            ),
          );
          return;
        }
      }

      changeProps(
        isEdited: false,
        saveStatus: const ApiResultStatus.data(
          data: 'Profile saved successfully',
        ),
      );
    } catch (e) {
      changeProps(
        saveStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }
}
