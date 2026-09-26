import 'dart:io';

void main() {
  final file = File('lib/ui/onboarding/onboarding_screen.dart');
  var content = file.readAsStringSync();
  
  // 1. Remove local error fields
  content = content.replaceFirst(
    '''  String _parentNameError = "";
  String _locationError = "";
  String _childNameError = "";
  String _childDobError = "";
  String _wakeTimeError = "";
  String _bedTimeError = "";

  static const List<String> _genders = <String>[''',
    '''  static const List<String> _genders = <String>['''
  );

  // 2. Replace _onNextTap with one that delegates to cubit
  final oldNextTapRegex = RegExp(r'void _onNextTap\(OnboardingState state\) \{[\s\S]*?if \(!isValid\) \{\s*setState\(\(\) \{\}\);\s*return;\s*\}');
  
  final newNextTap = '''void _onNextTap(OnboardingState state) {
    bool isValid = context.read<OnboardingCubit>().validateCurrentPage();
    
    if (!isValid) return;''';
    
  content = content.replaceFirst(oldNextTapRegex, newNextTap);
  
  // 3. Replace all local error variables with state variables in the UI
  content = content.replaceAll('_parentNameError', 'state.parentNameError');
  content = content.replaceAll('_locationError', 'state.locationError');
  content = content.replaceAll('_childNameError', 'state.childNameError');
  content = content.replaceAll('_childDobError', 'state.dateOfBirthError');
  content = content.replaceAll('_wakeTimeError', 'state.usualWakeTimeError');
  content = content.replaceAll('_bedTimeError', 'state.usualBedtimeError');
  
  // 4. Remove any local setState calls from UI taps (like onChanged / onTap resetting the error)
  content = content.replaceAll(RegExp(r'if \(state\.[a-zA-Z]+Error\.isNotEmpty\) setState\(\(\) => state\.[a-zA-Z]+Error = ""\);'), '');
  content = content.replaceAll(RegExp(r'if \(state\.[a-zA-Z]+Error\.isNotEmpty\)\s*setState\(\(\) => state\.[a-zA-Z]+Error = ""\);'), '');

  file.writeAsStringSync(content);
}
