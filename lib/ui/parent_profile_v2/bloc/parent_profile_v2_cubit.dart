import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/location_data_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import 'parent_profile_v2_state.dart';

class ParentProfileV2Cubit extends Cubit<ParentProfileV2State> {
  ParentProfileV2Cubit() : super(const ParentProfileV2State());

  LocationDataModel? _locationData;
  LocationDataModel? get locationData => _locationData;

  Future<void> init() async {
    UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();
    if (user != null) {
      _emitFromUser(user, child);
      if (user.uid != null && user.uid!.isNotEmpty) {
        final UserModel? freshUser = await AuthRepo.instance.getUserFromUid(
          uId: user.uid!,
        );
        if (freshUser != null) {
          await preferences.saveUserModel(freshUser);
          _emitFromUser(freshUser, child);
        }
      }
    }
  }

  void _emitFromUser(UserModel user, ChildModel? child) {
    String dobStr = '';
    if (user.parentDateOfBirth != null) {
      dobStr = DateFormat('yyyy-MM-dd').format(user.parentDateOfBirth!);
    }
    _locationData =
        user.locationData ??
        child?.locationData ??
        LocationDataModel.tryParse(user.location ?? child?.location);
    emit(
      state.copyWith(
        user: user,
        name: user.parentName ?? user.displayName ?? '',
        relationship:
            user.relationshipToChild ?? child?.relationshipToChild ?? '',
        gender: user.parentGender ?? '',
        language: (user.preferredLanguage ?? '').isNotEmpty
            ? user.preferredLanguage!
            : 'English',
        location: (user.location ?? '').isNotEmpty
            ? user.location!
            : (child?.location ?? _locationData?.formatted ?? ''),
        dob: dobStr,
      ),
    );
  }

  void updateLocationData(LocationDataModel data) {
    _locationData = data;
    updateField(location: data.formatted);
  }

  void updateField({
    String? name,
    String? relationship,
    String? dob,
    String? gender,
    String? language,
    String? location,
  }) {
    if (location != null && _locationData?.formatted != location) {
      _locationData = LocationDataModel.tryParse(location);
    }
    emit(
      state.copyWith(
        name: name ?? state.name,
        relationship: relationship ?? state.relationship,
        dob: dob ?? state.dob,
        gender: gender ?? state.gender,
        language: language ?? state.language,
        location: location ?? state.location,
        saveStatus: const ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> saveProfile() async {
    final UserModel? user = state.user ?? preferences.getUserModel();
    if (user == null || user.uid == null) return;

    final String trimmedName = state.name.trim();
    if (trimmedName.isEmpty) {
      emit(
        state.copyWith(
          saveStatus: ApiResultStatus.error(
            error: Exception('Please enter your name'),
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(saveStatus: const ApiResultStatus.loading()));

    try {
      final LocationDataModel? resolvedLoc =
          _locationData ?? LocationDataModel.tryParse(state.location);
      final Map<String, dynamic> userUpdate = <String, dynamic>{
        'parent_name': trimmedName,
        'relationship_to_child': state.relationship.trim(),
        'parent_gender': state.gender.trim(),
        'preferred_language': state.language.trim(),
        'location': resolvedLoc?.toJson() ?? state.location.trim(),
        if (resolvedLoc != null) 'location_data': resolvedLoc.toJson(),
      };

      if (state.dob.isNotEmpty) {
        try {
          final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(state.dob);
          userUpdate['parent_date_of_birth'] = Timestamp.fromDate(parsedDate);
        } catch (_) {}
      }

      final ApiResultStatus result = await AuthRepo.instance
          .updateUserToFireStore(uId: user.uid, request: userUpdate);

      if (result is Data) {
        if (state.location.trim().isNotEmpty && user.defaultChild != null) {
          try {
            await user.defaultChild!.update(<String, dynamic>{
              'location': resolvedLoc?.toJson() ?? state.location.trim(),
              if (resolvedLoc != null) 'location_data': resolvedLoc.toJson(),
              if (state.relationship.trim().isNotEmpty)
                'relationship_to_child': state.relationship.trim(),
            });
          } catch (_) {}
        }

        final UserModel? newModel = await AuthRepo.instance
            .syncUserAndDefaultChild(uId: user.uid!);
        emit(
          state.copyWith(
            user: newModel ?? user,
            saveStatus: const ApiResultStatus.data(
              data: "Profile saved successfully",
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            saveStatus: ApiResultStatus.error(
              error: Exception("Failed to save profile"),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          saveStatus: ApiResultStatus.error(error: Exception(e.toString())),
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(logoutStatus: const ApiResultStatus.loading()));
    await AuthRepo.instance.logout();
    emit(state.copyWith(logoutStatus: const ApiResultStatus.data(data: '')));
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(deleteAccountStatus: const ApiResultStatus.loading()));
    await AuthRepo.instance.deleteAccount();
    emit(
      state.copyWith(
        deleteAccountStatus: const ApiResultStatus.data(data: ''),
      ),
    );
  }
}
