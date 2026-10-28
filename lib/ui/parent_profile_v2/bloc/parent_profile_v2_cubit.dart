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

  void changeProps({
    UserModel? user,
    String? name,
    String? nameError,
    bool? isEdited,
    String? relationship,
    String? dob,
    String? gender,
    String? language,
    String? location,
    ApiResultStatus? saveStatus,
    ApiResultStatus? logoutStatus,
    ApiResultStatus? deleteAccountStatus,
  }) {
    emit(
      state.copyWith(
        user: user ?? state.user,
        name: name ?? state.name,
        nameError: nameError ?? state.nameError,
        isEdited: isEdited ?? state.isEdited,
        relationship: relationship ?? state.relationship,
        dob: dob ?? state.dob,
        gender: gender ?? state.gender,
        language: language ?? state.language,
        location: location ?? state.location,
        saveStatus: saveStatus ?? ApiResultStatus.initial(),
        logoutStatus: logoutStatus ?? ApiResultStatus.initial(),
        deleteAccountStatus: deleteAccountStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> init() async {
    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();
    if (user != null) {
      _applyFromUser(user, child);
      final String? uid = user.uid;
      if (uid != null && uid.isNotEmpty) {
        final UserModel? freshUser = await AuthRepo.instance.getUserFromUid(
          uId: uid,
        );
        if (freshUser != null) {
          await preferences.saveUserModel(freshUser);
          _applyFromUser(freshUser, child);
        }
      }
    }
  }

  void _applyFromUser(UserModel user, ChildModel? child) {
    String dobStr = '';
    if (user.parentDateOfBirth != null) {
      dobStr = DateFormat('yyyy-MM-dd').format(user.parentDateOfBirth!);
    }
    _locationData =
        user.locationData ??
        child?.locationData ??
        LocationDataModel.tryParse(user.location ?? child?.location);
    changeProps(
      user: user,
      name: user.parentName ?? user.displayName ?? '',
      nameError: '',
      isEdited: false,
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
    final String nextName = name ?? state.name;
    changeProps(
      name: nextName,
      nameError: nextName.trim().isNotEmpty ? '' : state.nameError,
      isEdited: true,
      relationship: relationship ?? state.relationship,
      dob: dob ?? state.dob,
      gender: gender ?? state.gender,
      language: language ?? state.language,
      location: location ?? state.location,
      saveStatus: const ApiResultStatus.initial(),
    );
  }

  Future<void> saveProfile() async {
    final String trimmedName = state.name.trim();
    if (trimmedName.isEmpty) {
      changeProps(
        nameError: 'Please enter your name',
        saveStatus: ApiResultStatus.error(
          error: Exception('Please enter your name'),
        ),
      );
      return;
    }

    final UserModel? user = state.user ?? preferences.getUserModel();
    if (user == null || user.uid == null) {
      changeProps(
        saveStatus: ApiResultStatus.error(
          error: Exception('User not logged in'),
        ),
      );
      return;
    }

    changeProps(saveStatus: const ApiResultStatus.loading());

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
        final DocumentReference<Object?>? childRef = user.defaultChild;
        if (state.location.trim().isNotEmpty && childRef != null) {
          try {
            await childRef.update(<String, dynamic>{
              'location': resolvedLoc?.toJson() ?? state.location.trim(),
              if (resolvedLoc != null) 'location_data': resolvedLoc.toJson(),
              if (state.relationship.trim().isNotEmpty)
                'relationship_to_child': state.relationship.trim(),
            });
          } catch (_) {}
        }

        final String? userUid = user.uid;
        final UserModel? newModel = (userUid != null && userUid.isNotEmpty)
            ? await AuthRepo.instance.syncUserAndDefaultChild(uId: userUid)
            : null;
        changeProps(
          user: newModel ?? user,
          isEdited: false,
          nameError: '',
          saveStatus: const ApiResultStatus.data(
            data: "Profile saved successfully",
          ),
        );
      } else {
        changeProps(
          saveStatus: ApiResultStatus.error(
            error: Exception("Failed to save profile"),
          ),
        );
      }
    } catch (e) {
      changeProps(
        saveStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }

  Future<void> logout() async {
    changeProps(logoutStatus: const ApiResultStatus.loading());
    await AuthRepo.instance.logout();
    changeProps(logoutStatus: const ApiResultStatus.data(data: ''));
  }

  Future<void> deleteAccount() async {
    changeProps(deleteAccountStatus: const ApiResultStatus.loading());
    final ApiResultStatus status = await AuthRepo.instance.deleteAccount();
    changeProps(deleteAccountStatus: status);
  }
}
