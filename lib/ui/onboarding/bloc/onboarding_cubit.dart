import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/api_result_status.dart';
import 'onboarding_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/model/child_model.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void init() {
    emit(const OnboardingState());
  }

  void changeProps({
    int? currentPage,
    int? totalPages,
    String? parentName,
    String? parentNameError,
    String? locationError,
    String? childNameError,
    String? dateOfBirthError,
    String? usualWakeTimeError,
    String? usualBedtimeError,
    String? parentRole,
    String? parentRoleError,
    String? preferredLanguage,
    String? preferredLanguageError,
    String? location,
    String? primaryConcern,
    List<String>? concerns,
    String? concernsError,
    bool? isMoreThanOneSelected,
    String? successGoal,
    String? successGoalError,
    String? childName,
    String? dateOfBirth,
    DateTime? childDob,
    String? childGender,
    String? childGenderError,
    String? usualWakeTime,
    String? usualBedtime,
    int? usualNaps,
    String? nightWakings,
    String? nightWakingsError,
    List<String>? difficultTimes,
    String? difficultTimesError,
    List<String>? possibleTriggers,
    String? possibleTriggersError,
    ApiResultStatus? completeStatus,
  }) {
    emit(
      state.copyWith(
        currentPage: currentPage ?? state.currentPage,
        totalPages: totalPages ?? state.totalPages,
        parentName: parentName ?? state.parentName,
        parentNameError: parentNameError ?? state.parentNameError,
        locationError: locationError ?? state.locationError,
        childNameError: childNameError ?? state.childNameError,
        dateOfBirthError: dateOfBirthError ?? state.dateOfBirthError,
        usualWakeTimeError: usualWakeTimeError ?? state.usualWakeTimeError,
        usualBedtimeError: usualBedtimeError ?? state.usualBedtimeError,
        parentRole: parentRole ?? state.parentRole,
        parentRoleError: parentRoleError ?? state.parentRoleError,
        preferredLanguage: preferredLanguage ?? state.preferredLanguage,
        preferredLanguageError: preferredLanguageError ?? state.preferredLanguageError,
        location: location ?? state.location,
        primaryConcern: primaryConcern ?? state.primaryConcern,
        concerns: concerns ?? state.concerns,
        concernsError: concernsError ?? state.concernsError,
        isMoreThanOneSelected:
            isMoreThanOneSelected ?? state.isMoreThanOneSelected,
        successGoal: successGoal ?? state.successGoal,
        successGoalError: successGoalError ?? state.successGoalError,
        childName: childName ?? state.childName,
        dateOfBirth: dateOfBirth ?? state.dateOfBirth,
        childDob: childDob ?? state.childDob,
        childGender: childGender ?? state.childGender,
        childGenderError: childGenderError ?? state.childGenderError,
        usualWakeTime: usualWakeTime ?? state.usualWakeTime,
        usualBedtime: usualBedtime ?? state.usualBedtime,
        usualNaps: usualNaps ?? state.usualNaps,
        nightWakings: nightWakings ?? state.nightWakings,
        nightWakingsError: nightWakingsError ?? state.nightWakingsError,
        difficultTimes: difficultTimes ?? state.difficultTimes,
        difficultTimesError: difficultTimesError ?? state.difficultTimesError,
        possibleTriggers: possibleTriggers ?? state.possibleTriggers,
        possibleTriggersError: possibleTriggersError ?? state.possibleTriggersError,
        completeStatus: completeStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  bool validateCurrentPage() {
    bool isValid = true;
    
    // Reset errors first
    changeProps(
      parentNameError: "",
      parentRoleError: "",
      preferredLanguageError: "",
      locationError: "",
      concernsError: "",
      successGoalError: "",
      childNameError: "",
      dateOfBirthError: "",
      childGenderError: "",
      usualWakeTimeError: "",
      usualBedtimeError: "",
      nightWakingsError: "",
      difficultTimesError: "",
      possibleTriggersError: "",
    );

    switch (state.currentPage) {
      case 0:
        if (state.parentName.isEmpty) {
          changeProps(parentNameError: "Please enter your name");
          isValid = false;
        }
        if (state.parentRole.isEmpty) {
          changeProps(parentRoleError: "Please select your relationship");
          isValid = false;
        }
        if (state.preferredLanguage.isEmpty) {
          changeProps(preferredLanguageError: "Please select preferred language");
          isValid = false;
        }
        if (state.location.isEmpty) {
          changeProps(locationError: "Please select a location");
          isValid = false;
        }
        break;
      case 1:
        if (state.concerns.isEmpty) {
          changeProps(concernsError: "Please select at least one concern");
          isValid = false;
        }
        break;
      case 2:
        if (state.successGoal.isEmpty) {
          changeProps(successGoalError: "Please select a goal");
          isValid = false;
        }
        break;
      case 3:
        if (state.childName.isEmpty) {
          changeProps(childNameError: "Please enter child's name");
          isValid = false;
        }
        if (state.dateOfBirth.isEmpty) {
          changeProps(dateOfBirthError: "Please select date of birth");
          isValid = false;
        }
        if (state.childGender.isEmpty) {
          changeProps(childGenderError: "Please select a gender");
          isValid = false;
        }
        break;
      case 4:
        if (state.usualWakeTime.isEmpty) {
          changeProps(usualWakeTimeError: "Please select wake time");
          isValid = false;
        }
        if (state.usualBedtime.isEmpty) {
          changeProps(usualBedtimeError: "Please select bedtime");
          isValid = false;
        }
        if (state.nightWakings.isEmpty) {
          changeProps(nightWakingsError: "Please select night wakings");
          isValid = false;
        }
        break;
      case 5:
        if (state.difficultTimes.isEmpty) {
          changeProps(difficultTimesError: "Please select at least one difficult time");
          isValid = false;
        }
        if (state.possibleTriggers.isEmpty) {
          changeProps(possibleTriggersError: "Please select at least one trigger");
          isValid = false;
        }
        break;
    }
    
    return isValid;
  }

  void onPageChanged(int index) {
    changeProps(currentPage: index);
  }

  void updateParentName(String name) {
    changeProps(parentName: name);
  }

  void selectParentRole(String role) {
    changeProps(parentRole: role);
  }

  void selectPreferredLanguage(String language) {
    changeProps(preferredLanguage: language);
  }

  void updateLocation(String location) {
    changeProps(location: location);
  }

  void selectConcern(String concern) {
    if (state.isMoreThanOneSelected) {
      final List<String> updated = List<String>.from(state.concerns);
      if (updated.contains(concern)) {
        if (updated.length > 1) {
          updated.remove(concern);
        }
      } else {
        updated.add(concern);
      }
      changeProps(
        concerns: updated,
        primaryConcern: updated.isNotEmpty ? updated.first : concern,
      );
    } else {
      changeProps(primaryConcern: concern, concerns: <String>[concern]);
    }
  }

  void toggleMoreThanOne() {
    final bool updated = !state.isMoreThanOneSelected;
    changeProps(isMoreThanOneSelected: updated);
  }

  void selectSuccessGoal(String goal) {
    changeProps(successGoal: goal);
  }

  void updateChildName(String name) {
    changeProps(childName: name, childNameError: "");
  }

  void updateChildDob({required String formattedDate, required DateTime dob}) {
    changeProps(dateOfBirth: formattedDate, childDob: dob, dateOfBirthError: "");
  }

  void selectChildGender(String gender) {
    changeProps(childGender: gender, childGenderError: "");
  }

  void updateWakeTime(String time) {
    changeProps(usualWakeTime: time, usualWakeTimeError: "");
  }

  void updateBedtime(String time) {
    changeProps(usualBedtime: time, usualBedtimeError: "");
  }

  void updateUsualNaps(int delta) {
    final int updated = (state.usualNaps + delta).clamp(0, 10);
    changeProps(usualNaps: updated);
  }

  void selectNightWakings(String option) {
    changeProps(nightWakings: option, nightWakingsError: "");
  }

  void toggleDifficultTime(String time) {
    final List<String> updated = List<String>.from(state.difficultTimes);
    if (updated.contains(time)) {
      updated.remove(time);
    } else {
      updated.add(time);
    }
    changeProps(difficultTimes: updated, difficultTimesError: "");
  }

  void togglePossibleTrigger(String trigger) {
    final List<String> updated = List<String>.from(state.possibleTriggers);
    if (updated.contains(trigger)) {
      updated.remove(trigger);
    } else {
      updated.add(trigger);
    }
    changeProps(possibleTriggers: updated, possibleTriggersError: "");
  }

  Future<void> completeOnboarding() async {
    changeProps(completeStatus: ApiResultStatus.loading());
    try {
      final user = preferences.getUserModel();
      if (user == null || user.uid == null) {
        throw Exception("User not found. Please log in again.");
      }

      final firestore = FirebaseFirestore.instance;

      // 1. Create Child Document
      final childDoc = firestore.collection('children').doc();
      final childModel = ChildModel(
        childName: state.childName.isNotEmpty ? state.childName : null,
        childDob: state.childDob,
        relationshipToChild: state.parentRole.isNotEmpty
            ? state.parentRole
            : null,
        parentReferenceIds: [user.uid!],
      );
      await childDoc.set(childModel.toJson());

      // 2. Update User Document
      final updatedUser = user.toJson();
      updatedUser['parent_name'] = state.parentName;
      updatedUser['relationship_to_child'] = state.parentRole;
      updatedUser['children'] = [childDoc.path];
      updatedUser['default_child'] = childDoc.path;

      await AuthRepo.instance.updateUserToFireStore(
        uId: user.uid,
        request: updatedUser,
      );

      // Update local storage
      final newUserModel = await AuthRepo.instance.getUserFromUid(
        uId: user.uid!,
      );
      if (newUserModel != null) {
        await preferences.saveUserModel(newUserModel);
        await preferences.saveChildModel(childModel);
      }

      changeProps(completeStatus: ApiResultStatus.data(data: true));
    } catch (e) {
      changeProps(
        completeStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }
}
