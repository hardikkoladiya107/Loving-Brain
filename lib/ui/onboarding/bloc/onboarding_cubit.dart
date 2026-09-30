import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/location_data_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import '../../../../model/api_result_status.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  LocationDataModel? _locationData;
  LocationDataModel? get locationData => _locationData;

  void init() {
    final UserModel? user = preferences.getUserModel();
    final String initialParentName =
        (user?.parentName != null && user!.parentName!.trim().isNotEmpty)
        ? user.parentName!.trim()
        : '';
    _locationData = user?.locationData;
    final DateTime today = DateTime.now();
    final String todayFormatted = DateFormat('d MMMM yyyy').format(today);
    emit(
      OnboardingState(
        parentName: initialParentName,
        location: user?.location ?? '',
        childDob: today,
        dateOfBirth: todayFormatted,
      ),
    );
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
    String? activeTimeField,
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
        preferredLanguageError:
            preferredLanguageError ?? state.preferredLanguageError,
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
        possibleTriggersError:
            possibleTriggersError ?? state.possibleTriggersError,
        activeTimeField: activeTimeField ?? state.activeTimeField,
        completeStatus: completeStatus ?? const ApiResultStatus.initial(),
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
        if (state.parentName.trim().isEmpty) {
          changeProps(parentNameError: "Please enter your name");
          isValid = false;
        }
        if (state.parentRole.isEmpty) {
          changeProps(parentRoleError: "Please select your relationship");
          isValid = false;
        }
        if (state.preferredLanguage.isEmpty) {
          changeProps(
            preferredLanguageError: "Please select preferred language",
          );
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
        if (state.childName.trim().isEmpty) {
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
          changeProps(
            difficultTimesError: "Please select at least one difficult time",
          );
          isValid = false;
        }
        if (state.possibleTriggers.isEmpty) {
          changeProps(
            possibleTriggersError: "Please select at least one trigger",
          );
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
    changeProps(parentName: name, parentNameError: "");
  }

  void selectParentRole(String role) {
    changeProps(parentRole: role, parentRoleError: "");
  }

  void selectPreferredLanguage(String language) {
    changeProps(preferredLanguage: language, preferredLanguageError: "");
  }

  void updateLocation(String location) {
    _locationData = LocationDataModel.tryParse(location);
    changeProps(location: location, locationError: "");
  }

  void updateLocationData(LocationDataModel data) {
    _locationData = data;
    changeProps(location: data.formatted, locationError: "");
  }

  void selectConcern(String concern) {
    if (state.isMoreThanOneSelected) {
      final List<String> updated = List<String>.from(state.concerns);
      if (updated.contains(concern)) {
        updated.remove(concern);
      } else {
        updated.add(concern);
      }
      changeProps(
        concerns: updated,
        primaryConcern: updated.isNotEmpty ? updated.first : '',
        concernsError: "",
      );
    } else {
      changeProps(
        primaryConcern: concern,
        concerns: <String>[concern],
        concernsError: "",
      );
    }
  }

  void toggleMoreThanOne() {
    final bool updated = !state.isMoreThanOneSelected;
    if (!updated && state.concerns.length > 1) {
      changeProps(
        isMoreThanOneSelected: false,
        concerns: const <String>[],
        primaryConcern: '',
      );
    } else {
      changeProps(isMoreThanOneSelected: updated);
    }
  }

  void selectSuccessGoal(String goal) {
    changeProps(successGoal: goal, successGoalError: "");
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

  void setActiveTimeField(String field) {
    changeProps(activeTimeField: field);
  }

  void updateWakeTime(String time) {
    changeProps(
      usualWakeTime: time,
      usualWakeTimeError: "",
      activeTimeField: 'wake',
    );
  }

  void updateBedtime(String time) {
    changeProps(
      usualBedtime: time,
      usualBedtimeError: "",
      activeTimeField: 'bed',
    );
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
    changeProps(completeStatus: const ApiResultStatus.loading());
    try {
      final UserModel? user = preferences.getUserModel();
      if (user == null || user.uid == null) {
        throw Exception("User not found. Please log in again.");
      }

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final int ageInMonths = AgeUtils.resolvedAgeInMonths(
        dob: state.childDob,
        legacyAgeText: '',
      );
      final String computedChildAge = AgeUtils.ageLabelFromMonths(ageInMonths);
      final LocationDataModel? resolvedLoc =
          _locationData ?? LocationDataModel.tryParse(state.location);

      // 1. Create Child Document with full onboarding details
      final DocumentReference<Map<String, dynamic>> childDoc =
          firestore.collection('children').doc();
      final ChildModel childModel = ChildModel(
        childName: state.childName.trim().isNotEmpty
            ? state.childName.trim()
            : null,
        childDob: state.childDob,
        childAge: computedChildAge.isNotEmpty ? computedChildAge : null,
        childGender: state.childGender.isNotEmpty ? state.childGender : null,
        relationshipToChild: state.parentRole.isNotEmpty
            ? state.parentRole
            : null,
        parentReferenceIds: <String>[user.uid!],
        reference: childDoc,
        concerns: state.concerns,
        primaryConcern: state.primaryConcern.isNotEmpty
            ? state.primaryConcern
            : (state.concerns.isNotEmpty ? state.concerns.first : null),
        successGoal: state.successGoal.isNotEmpty ? state.successGoal : null,
        usualWakeTime: state.usualWakeTime.isNotEmpty
            ? state.usualWakeTime
            : null,
        usualBedtime: state.usualBedtime.isNotEmpty
            ? state.usualBedtime
            : null,
        usualNaps: state.usualNaps.toString(),
        nightWakings: state.nightWakings.isNotEmpty
            ? state.nightWakings
            : null,
        difficultTimes: state.difficultTimes,
        possibleTriggers: state.possibleTriggers,
        location: state.location.isNotEmpty ? state.location : null,
        locationData: resolvedLoc,
      );
      await childDoc.set(childModel.toJson());

      // 2. Update User Document in Firestore with location JSON
      final Map<String, dynamic> userUpdate = <String, dynamic>{
        'parent_name': state.parentName.trim(),
        'relationship_to_child': state.parentRole,
        'preferred_language': state.preferredLanguage,
        'location': resolvedLoc?.toJson() ?? state.location,
        if (resolvedLoc != null) 'location_data': resolvedLoc.toJson(),
        'child_name': state.childName.trim(),
        'child_age': computedChildAge,
        'children': <DocumentReference>[childDoc],
        'default_child': childDoc,
        'is_onboarding_completed': true,
      };

      await AuthRepo.instance.updateUserToFireStore(
        uId: user.uid,
        request: userUpdate,
      );

      // 3. Sync User & Child models into local SharedPreferences
      await AuthRepo.instance.syncUserAndDefaultChild(uId: user.uid!);
      await preferences.saveDefaultChildModel(childModel);

      changeProps(completeStatus: const ApiResultStatus.data(data: true));
    } catch (e) {
      changeProps(
        completeStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }
}
