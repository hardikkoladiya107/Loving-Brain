import 'dart:io';

void main() {
  final file = File('lib/ui/onboarding/bloc/onboarding_cubit.dart');
  var content = file.readAsStringSync();
  
  // Update changeProps signature
  content = content.replaceFirst(
    '    String? parentName,',
    '''    String? parentName,
    String? parentNameError,
    String? locationError,
    String? childNameError,
    String? dateOfBirthError,
    String? usualWakeTimeError,
    String? usualBedtimeError,'''
  );

  // Update changeProps body
  content = content.replaceFirst(
    '        parentName: parentName ?? state.parentName,',
    '''        parentName: parentName ?? state.parentName,
        parentNameError: parentNameError ?? state.parentNameError,
        locationError: locationError ?? state.locationError,
        childNameError: childNameError ?? state.childNameError,
        dateOfBirthError: dateOfBirthError ?? state.dateOfBirthError,
        usualWakeTimeError: usualWakeTimeError ?? state.usualWakeTimeError,
        usualBedtimeError: usualBedtimeError ?? state.usualBedtimeError,'''
  );
  
  // Add validateAndProceed
  content = content.replaceFirst(
    '  void onPageChanged(int index) {',
    '''  bool validateCurrentPage() {
    bool isValid = true;
    
    // Reset errors first
    changeProps(
      parentNameError: "",
      locationError: "",
      childNameError: "",
      dateOfBirthError: "",
      usualWakeTimeError: "",
      usualBedtimeError: "",
    );

    switch (state.currentPage) {
      case 0:
        if (state.parentName.isEmpty) {
          changeProps(parentNameError: "Please enter your name");
          isValid = false;
        }
        if (state.location.isEmpty) {
          changeProps(locationError: "Please select a location");
          isValid = false;
        }
        break;
      case 1:
        if (state.childName.isEmpty) {
          changeProps(childNameError: "Please enter child's name");
          isValid = false;
        }
        if (state.dateOfBirth.isEmpty) {
          changeProps(dateOfBirthError: "Please select date of birth");
          isValid = false;
        }
        break;
      case 2:
        break;
      case 3:
        if (state.usualWakeTime.isEmpty) {
          changeProps(usualWakeTimeError: "Please select wake time");
          isValid = false;
        }
        if (state.usualBedtime.isEmpty) {
          changeProps(usualBedtimeError: "Please select bedtime");
          isValid = false;
        }
        break;
      case 4:
      case 5:
        break;
    }
    
    return isValid;
  }

  void onPageChanged(int index) {'''
  );

  file.writeAsStringSync(content);
}
