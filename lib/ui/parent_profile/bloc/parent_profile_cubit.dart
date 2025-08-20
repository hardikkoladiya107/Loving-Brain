import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/parent_profile/bloc/parent_profile_state.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../repo/auth_repo.dart';

class ParentProfileCubit extends Cubit<ParentProfileState> {
  ParentProfileCubit() : super(ParentProfileState());

  void init() {
    emit(ParentProfileState());
    changeProps(genderList: ["Male", "Female", "Other"]);
  }

  void changeProps({
    List<String>? genderList,
    String? parentName,
    String? parentNameError,
    String? parentEmailAddress,
    String? parentEmailAddressError,
    DateTime? parentDateOfBirth,
    String? parentDateOfBirthError,
    String? parentGender,
    String? parentGenderError,
    ApiResultStatus? apiResultStatus,
  }) {
    emit(
      state.copyWith(
        genderList: genderList ?? state.genderList,
        parentName: parentName ?? state.parentName,
        parentNameError: parentNameError ?? state.parentNameError,
        parentEmailAddress: parentEmailAddress ?? state.parentEmailAddress,
        parentEmailAddressError:
            parentEmailAddressError ?? state.parentEmailAddressError,
        parentDateOfBirth: parentDateOfBirth ?? state.parentDateOfBirth,
        parentDateOfBirthError:
            parentDateOfBirthError ?? state.parentDateOfBirthError,
        parentGender: parentGender ?? state.parentGender,
        parentGenderError: parentGenderError ?? state.parentGenderError,
        apiResultStatus: apiResultStatus ?? state.apiResultStatus,
      ),
    );
  }

  bool _isValidate() {
    if (state.parentEmailAddress.trim().isEmpty ||
        !state.parentEmailAddress.trim().isValidEmail ||
        state.parentName.trim().isEmpty ||
        state.parentGender.trim().isEmpty ||
        state.parentDateOfBirth == null) {
      if (state.parentEmailAddress.trim().isEmpty) {
        changeProps(
          parentEmailAddressError: LocaleKeys.pleaseEnterEmailAddress.tr(),
        );
      } else if (!state.parentEmailAddress.trim().isValidEmail) {
        changeProps(
          parentEmailAddressError: LocaleKeys.pleaseEnterValidEmail.tr(),
        );
      } else {
        changeProps(parentEmailAddressError: "");
      }

      if (state.parentName.trim().isEmpty) {
        changeProps(parentNameError: LocaleKeys.pleaseEnterParentName.tr());
      } else {
        changeProps(parentNameError: "");
      }

      if (state.parentGender.trim().isEmpty) {
        changeProps(parentGenderError: LocaleKeys.pleaseEnterParentGender.tr());
      } else {
        changeProps(parentGenderError: "");
      }

      if (state.parentDateOfBirth == null) {
        changeProps(
          parentDateOfBirthError: LocaleKeys.pleaseEnterParentDateOfBirth.tr(),
        );
      } else {
        changeProps(parentDateOfBirthError: "");
      }
      return false;
    }

    changeProps(
      parentNameError: "",
      parentEmailAddressError: "",
      parentDateOfBirthError: "",
      parentGenderError: "",
    );
    return true;
  }

  Future<void> addParentDetail(String userId) async {
    if (_isValidate()) {
      final credential = await AuthRepo.instance.updateUserToFireStore(
        uId: userId,
        request: {
          "parent_name": state.parentName,
          "parent_email": state.parentEmailAddress,
          "parent_gender": state.parentGender,
          "parent_date_of_birth": Timestamp.fromDate(state.parentDateOfBirth!),
        },
      );
      changeProps(apiResultStatus: credential);
    }
  }

  void clearFields() {
    emit(ParentProfileState());
  }
}
