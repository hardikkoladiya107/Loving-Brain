import 'dart:io';

void main() {
  final file = File('lib/ui/onboarding/bloc/onboarding_cubit.dart');
  var content = file.readAsStringSync();
  
  // Update name clears error
  content = content.replaceFirst(
    '  void updateParentName(String name) {\\n    changeProps(parentName: name);\\n  }',
    '  void updateParentName(String name) {\\n    changeProps(parentName: name, parentNameError: "");\\n  }'
  );
  
  // Update location clears error
  content = content.replaceFirst(
    '  void updateLocation(String loc) {\\n    changeProps(location: loc);\\n  }',
    '  void updateLocation(String loc) {\\n    changeProps(location: loc, locationError: "");\\n  }'
  );

  // Update childName clears error
  content = content.replaceFirst(
    '  void updateChildName(String name) {\\n    changeProps(childName: name);\\n  }',
    '  void updateChildName(String name) {\\n    changeProps(childName: name, childNameError: "");\\n  }'
  );

  // Update date of birth clears error
  content = content.replaceFirst(
    '  void updateDateOfBirth(String dob, DateTime childDob) {\\n    changeProps(dateOfBirth: dob, childDob: childDob);\\n  }',
    '  void updateDateOfBirth(String dob, DateTime childDob) {\\n    changeProps(dateOfBirth: dob, childDob: childDob, dateOfBirthError: "");\\n  }'
  );

  // Update wake time clears error
  content = content.replaceFirst(
    '  void updateWakeTime(String time) {\\n    changeProps(usualWakeTime: time);\\n  }',
    '  void updateWakeTime(String time) {\\n    changeProps(usualWakeTime: time, usualWakeTimeError: "");\\n  }'
  );

  // Update bedtime clears error
  content = content.replaceFirst(
    '  void updateBedtime(String time) {\\n    changeProps(usualBedtime: time);\\n  }',
    '  void updateBedtime(String time) {\\n    changeProps(usualBedtime: time, usualBedtimeError: "");\\n  }'
  );

  file.writeAsStringSync(content);
}
