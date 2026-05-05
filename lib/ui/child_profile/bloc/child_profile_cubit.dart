import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/age_utils.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../repo/auth_repo.dart';
import 'child_profile_state.dart';

class ChildProfileCubit extends Cubit<ChildProfileState> {
  ChildProfileCubit() : super(ChildProfileState());

  void init() {
    emit(ChildProfileState());
  }

  void changeProps({
    String? childName,
    String? childNameError,
    DateTime? childDob,
    String? childDobError,
    ApiResultStatus? apiResultStatus,
  }) {
    emit(
      state.copyWith(
        childName: childName ?? state.childName,
        childNameError: childNameError ?? state.childNameError,
        childDob: childDob ?? state.childDob,
        childDobError: childDobError ?? state.childDobError,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  bool _isValidate() {
    if (state.childName.trim().isEmpty || state.childDob == null) {
      if (state.childName.trim().isEmpty) {
        changeProps(childNameError: LocaleKeys.pleaseEnterChildName.tr());
      } else {
        changeProps(childNameError: "");
      }

      if (state.childDob == null) {
        changeProps(childDobError: "Please select date of birth.");
      } else {
        changeProps(childDobError: "");
      }
      return false;
    }

    changeProps(childNameError: "", childDobError: "");
    return true;
  }

  Future<void> addChildDetail(String userId) async {
    if (_isValidate()) {
      changeProps(apiResultStatus: ApiResultStatus.loading());
      final DateTime selectedDob = state.childDob!;
      final int ageInMonths = AgeUtils.resolvedAgeInMonths(
        dob: selectedDob,
        legacyAgeText: '',
      );
      final credential = await AuthRepo.instance.addChild(
        request: <String, dynamic>{
          "child_name": state.childName,
          "child_dob": selectedDob,
          "child_age": AgeUtils.ageLabelFromMonths(ageInMonths),
          "relationship_to_child": "Parent",
        },
      );
      changeProps(apiResultStatus: credential);
    }
  }

  void clearFields() {
    emit(ChildProfileState());
  }
}
