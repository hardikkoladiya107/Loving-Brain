import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

import 'family_sharing_consent_state.dart';

/// Cubit for Screen 74 (Family Sharing Consent Explainer).
/// Conforms to AGENTS.md §4.2.
class FamilySharingConsentCubit extends Cubit<FamilySharingConsentState> {
  FamilySharingConsentCubit() : super(const FamilySharingConsentState());

  void init() {
    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();
    final String? childName = child?.childName?.trim();
    final String? userChildName = user?.childName?.trim();
    final String cName = (childName != null && childName.isNotEmpty)
        ? childName
        : (userChildName != null && userChildName.isNotEmpty)
        ? userChildName
        : 'your child';

    changeProps(childName: cName);
  }

  void changeProps({String? childName, bool? isConsentGiven}) {
    emit(
      state.copyWith(
        childName: childName ?? state.childName,
        isConsentGiven: isConsentGiven ?? state.isConsentGiven,
      ),
    );
  }

  void grantConsent() {
    changeProps(isConsentGiven: true);
  }
}
