import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../repo/auth_repo.dart';
import 'child_profile_state.dart';

class ChildProfileCubit extends Cubit<ChildProfileState> {
  ChildProfileCubit() : super(ChildProfileState());

  void init() {
    emit(
      ChildProfileState(
        relationshipList: ["Mother", "Father", "Other"],
        childAgeList: ["0-3 year", "3-6 years", "6-9 years"],
      ),
    );
  }

  void changeProps({
    String? childName,
    String? childNameError,
    String? childAge,
    String? childAgeError,
    String? relationShipToChild,
    String? relationShipToChildError,
    ApiResultStatus? apiResultStatus,
  }) {
    emit(
      state.copyWith(
        childName: childName ?? state.childName,
        childNameError: childNameError ?? state.childNameError,
        childAge: childAge ?? state.childAge,
        childAgeError: childAgeError ?? state.childAgeError,
        relationShipToChild: relationShipToChild ?? state.relationShipToChild,
        relationShipToChildError:
            relationShipToChildError ?? state.relationShipToChildError,
        apiResultStatus: apiResultStatus ?? state.apiResultStatus,
      ),
    );
  }



  bool _isValidate() {
    if (state.childName.trim().isEmpty ||
        state.childAge.trim().isEmpty ||
        state.relationShipToChild.trim().isEmpty) {
      if (state.childName.trim().isEmpty) {
        changeProps(childNameError: LocaleKeys.pleaseEnterChildName.tr());
      } else {
        changeProps(childNameError: "");
      }

      if (state.childAge.trim().isEmpty) {
        changeProps(childAgeError: LocaleKeys.pleaseEnterChildAge.tr());
      } else {
        changeProps(childAgeError: "");
      }

      if (state.relationShipToChild.trim().isEmpty) {
        changeProps(
          relationShipToChildError: LocaleKeys.pleaseEnterRelationshipToChild
              .tr(),
        );
      } else {
        changeProps(relationShipToChildError: "");
      }
      return false;
    }

    changeProps(
      childNameError: "",
      childAgeError: "",
      relationShipToChildError: "",
    );
    return true;
  }

  Future<void> addChildDetail(String userId) async {
    if (_isValidate()) {
      changeProps(apiResultStatus: ApiResultStatus.loading());
      final credential = await AuthRepo.instance.addChild(
        request: {
          "child_name": state.childName,
          "child_age": state.childAge,
          "relationship_to_child": state.relationShipToChild,
        },
      );
      changeProps(apiResultStatus: credential);
    }
  }

  void clearFields() {
    emit(ChildProfileState());
  }
}
