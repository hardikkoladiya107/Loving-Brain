import 'dart:io';

void main() {
  final file = File('lib/ui/onboarding/onboarding_screen.dart');
  var content = file.readAsStringSync();
  
  final regex = RegExp(r'void _onNextTap\(OnboardingState state\)\s*\{[\s\S]*?if \(!isValid\) \{[\s\S]*?return;\s*\}');
  
  final newNextTap = '''void _onNextTap(OnboardingState state) {
    bool isValid = true;

    setState(() {
      _parentNameError = "";
      _locationError = "";
      _childNameError = "";
      _childDobError = "";
      _wakeTimeError = "";
      _bedTimeError = "";
    });

    switch (state.currentPage) {
      case 0:
        if (state.parentName.isEmpty) {
          _parentNameError = "Please enter your name";
          isValid = false;
        }
        if (state.location.isEmpty) {
          _locationError = "Please select a location";
          isValid = false;
        }
        // Let them pass if role/language is empty as they are chips
        break;
      case 1:
        if (state.childName.isEmpty) {
          _childNameError = "Please enter child's name";
          isValid = false;
        }
        if (state.dateOfBirth.isEmpty) {
          _childDobError = "Please select date of birth";
          isValid = false;
        }
        break;
      case 2:
        break;
      case 3:
        if (state.usualWakeTime.isEmpty) {
          _wakeTimeError = "Please select wake time";
          isValid = false;
        }
        if (state.usualBedtime.isEmpty) {
          _bedTimeError = "Please select bedtime";
          isValid = false;
        }
        break;
      case 4:
        break;
      case 5:
        break;
    }

    if (!isValid) {
      setState(() {});
      return;
    }''';

  content = content.replaceFirst(regex, newNextTap);

  file.writeAsStringSync(content);
}
