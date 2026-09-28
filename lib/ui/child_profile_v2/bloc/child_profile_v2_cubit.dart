import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import 'child_profile_v2_state.dart';

class ChildProfileV2Cubit extends Cubit<ChildProfileV2State> {
  ChildProfileV2Cubit() : super(const ChildProfileV2State());

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

  Future<void> init({bool createNew = false}) async {
    if (createNew) {
      final UserModel? user = preferences.getUserModel();
      emit(
        ChildProfileV2State(
          location: user?.location ?? '',
        ),
      );
      return;
    }

    final UserModel? user = preferences.getUserModel();
    final ChildModel? localChild = preferences.getChildModel();

    if (localChild != null) {
      final String initialAge = localChild.childAge ?? user?.childAge ?? '';
      emit(
        state.copyWith(
          childModel: localChild,
          name: localChild.childName ?? user?.childName ?? '',
          age: initialAge,
          childDob: localChild.childDob,
          dob: formatDobWithAge(localChild.childDob, initialAge),
          conditions: (localChild.conditions ?? const <String>[]).join(', '),
          concerns: _extractConcernsText(localChild, null),
          location: localChild.location ?? user?.location ?? '',
        ),
      );
    } else if (user != null) {
      emit(
        state.copyWith(
          name: user.childName ?? '',
          age: user.childAge ?? '',
          dob: user.childAge ?? '',
          location: user.location ?? '',
        ),
      );
    }

    final DocumentReference<Object?>? childRef =
        user?.defaultChild ??
        localChild?.reference ??
        ((user?.children != null && user!.children!.isNotEmpty)
            ? user.children!.first
            : null);

    if (childRef != null) {
      try {
        final DocumentSnapshot<Object?> doc = await childRef.get();
        if (doc.exists && doc.data() is Map<String, dynamic>) {
          final Map<String, dynamic> data =
              doc.data()! as Map<String, dynamic>;
          final ChildModel childModel = ChildModel.fromJson(
            data,
            doc.reference,
          );
          await preferences.saveDefaultChildModel(childModel);

          final String resolvedAge =
              childModel.childAge ?? user?.childAge ?? '';
          final DateTime? resolvedDob = childModel.childDob;
          final String conditionsStr = data['conditions'] is List
              ? (data['conditions'] as List)
                    .map((e) => e?.toString() ?? '')
                    .where((s) => s.isNotEmpty)
                    .join(', ')
              : (data['conditions']?.toString() ?? '');

          emit(
            state.copyWith(
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
                  : (user?.location ?? ''),
            ),
          );
        }
      } catch (_) {}
    }
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
    emit(
      state.copyWith(
        name: name ?? state.name,
        age: age ?? state.age,
        conditions: conditions ?? state.conditions,
        dob: dob ?? state.dob,
        childDob: childDob ?? state.childDob,
        concerns: concerns ?? state.concerns,
        location: location ?? state.location,
        saveStatus: const ApiResultStatus.initial(),
      ),
    );
  }

  void updateDob(DateTime picked) {
    final int months = AgeUtils.resolvedAgeInMonths(
      dob: picked,
      legacyAgeText: state.age,
    );
    final String ageLabel = AgeUtils.ageLabelFromMonths(months);
    final String formatted = formatDobWithAge(picked, ageLabel);
    emit(
      state.copyWith(
        childDob: picked,
        age: ageLabel,
        dob: formatted,
        saveStatus: const ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> saveProfile() async {
    final String trimmedName = state.name.trim();
    if (trimmedName.isEmpty) {
      emit(
        state.copyWith(
          saveStatus: ApiResultStatus.error(
            error: Exception("Please enter child's name"),
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(saveStatus: const ApiResultStatus.loading()));

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

      final List<String> concernsList = state.concerns
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
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
          'location': state.location.trim(),
        };
        if (selectedDob != null) {
          updatePayload['child_dob'] = Timestamp.fromDate(selectedDob);
        }
        if (state.conditions.trim().isNotEmpty) {
          updatePayload['conditions'] = state.conditions
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        }

        await childRef.update(updatePayload);

        if (user?.uid != null && user!.uid!.isNotEmpty) {
          final Map<String, dynamic> userUpdate = <String, dynamic>{
            'child_name': trimmedName,
            'child_age': computedAge,
          };
          if (state.location.trim().isNotEmpty) {
            userUpdate['location'] = state.location.trim();
          }
          await AuthRepo.instance.updateUserToFireStore(
            uId: user.uid,
            request: userUpdate,
          );
          await AuthRepo.instance.syncUserAndDefaultChild(uId: user.uid!);
        }

        final DocumentSnapshot<Object?> doc = await childRef.get();
        if (doc.exists && doc.data() is Map<String, dynamic>) {
          final ChildModel newChild = ChildModel.fromJson(
            doc.data()! as Map<String, dynamic>,
            doc.reference,
          );
          await preferences.saveDefaultChildModel(newChild);
          emit(
            state.copyWith(
              childModel: newChild,
              name: trimmedName,
              age: computedAge,
              childDob: selectedDob,
              dob: formatDobWithAge(selectedDob, computedAge),
              saveStatus: const ApiResultStatus.data(
                data: 'Profile saved successfully',
              ),
            ),
          );
          return;
        }
      } else {
        // Create a new child and link it to the user (as in old ChildProfileCubit)
        final Map<String, dynamic> createRequest = <String, dynamic>{
          'child_name': trimmedName,
          'child_age': computedAge,
          'relationship_to_child': user?.relationshipToChild ?? 'Parent',
          'concerns': concernsList,
          'primary_concern': concernsList.isNotEmpty
              ? concernsList.first
              : null,
          'location': state.location.trim(),
        };
        if (selectedDob != null) {
          createRequest['child_dob'] = Timestamp.fromDate(selectedDob);
        }
        final ApiResultStatus<UserModel> result = await AuthRepo.instance
            .addChild(request: createRequest);
        if (result is Data<UserModel>) {
          final ChildModel? newChild = preferences.getChildModel();
          emit(
            state.copyWith(
              childModel: newChild,
              name: trimmedName,
              age: computedAge,
              childDob: selectedDob,
              dob: formatDobWithAge(selectedDob, computedAge),
              saveStatus: const ApiResultStatus.data(
                data: 'Profile saved successfully',
              ),
            ),
          );
          return;
        }
      }

      emit(
        state.copyWith(
          saveStatus: const ApiResultStatus.data(
            data: 'Profile saved successfully',
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          saveStatus: ApiResultStatus.error(error: Exception(e.toString())),
        ),
      );
    }
  }
}
