import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'parent_profile_v2_state.dart';

class ParentProfileV2Cubit extends Cubit<ParentProfileV2State> {
  ParentProfileV2Cubit() : super(const ParentProfileV2State());

  void init() {
    final user = preferences.getUserModel();
    if (user != null) {
      String dobStr = '';
      if (user.parentDateOfBirth != null) {
        dobStr = DateFormat('yyyy-MM-dd').format(user.parentDateOfBirth!);
      }
      
      emit(state.copyWith(
        user: user,
        name: user.parentName ?? '',
        relationship: user.relationshipToChild ?? '',
        gender: user.parentGender ?? '',
        language: user.preferredLanguage ?? '',
        location: user.location ?? '',
        dob: dobStr,
      ));
    }
  }

  void updateField({String? name, String? relationship, String? dob, String? gender, String? language, String? location}) {
    emit(state.copyWith(
      name: name ?? state.name,
      relationship: relationship ?? state.relationship,
      dob: dob ?? state.dob,
      gender: gender ?? state.gender,
      language: language ?? state.language,
      location: location ?? state.location,
    ));
  }

  Future<void> saveProfile() async {
    final user = state.user;
    if (user == null || user.uid == null) return;
    
    emit(state.copyWith(saveStatus: ApiResultStatus.loading()));
    
    try {
      final updatedUser = user.toJson();
      updatedUser['parent_name'] = state.name;
      updatedUser['relationship_to_child'] = state.relationship;
      updatedUser['parent_gender'] = state.gender;
      updatedUser['preferred_language'] = state.language;
      updatedUser['location'] = state.location;
      
      if (state.dob.isNotEmpty) {
        try {
          final parsedDate = DateFormat('yyyy-MM-dd').parse(state.dob);
          updatedUser['parent_date_of_birth'] = Timestamp.fromDate(parsedDate);
        } catch (_) {}
      }

      final result = await AuthRepo.instance.updateUserToFireStore(
        uId: user.uid,
        request: updatedUser,
      );

      if (result is Data) {
        final newModel = await AuthRepo.instance.getUserFromUid(
          uId: user.uid!,
        );
        if (newModel != null) {
          await preferences.saveUserModel(newModel);
          emit(state.copyWith(user: newModel));
        }
        emit(state.copyWith(saveStatus: ApiResultStatus.data(data: "Profile saved successfully")));
      } else {
        emit(state.copyWith(saveStatus: ApiResultStatus.error(error: Exception("Failed to save profile"))));
      }
    } catch (e) {
      emit(state.copyWith(saveStatus: ApiResultStatus.error(error: Exception(e.toString()))));
    }
  }
}
