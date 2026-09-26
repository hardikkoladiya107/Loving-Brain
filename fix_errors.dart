import 'dart:io';

void main() {
  final file = File('lib/ui/onboarding/onboarding_screen.dart');
  var content = file.readAsStringSync();
  
  // Replace the Snackbars with inline errors.
  
  // We need to inject state variables for errors.
  content = content.replaceFirst(
    '  static const List<String> _genders = <String>[',
    '''
  String _parentNameError = "";
  String _locationError = "";
  String _childNameError = "";
  String _childDobError = "";
  String _wakeTimeError = "";
  String _bedTimeError = "";

  static const List<String> _genders = <String>['''
  );
  
  // Update _onNextTap
  final oldNextTap = '''  void _onNextTap(OnboardingState state) {
    bool isValid = true;

    switch (state.currentPage) {
      case 0:
        isValid = state.parentName.isNotEmpty &&
            state.parentRole.isNotEmpty &&
            state.preferredLanguage.isNotEmpty &&
            state.location.isNotEmpty;
        break;
      case 1:
        isValid = state.childName.isNotEmpty &&
            state.dateOfBirth.isNotEmpty &&
            state.childGender.isNotEmpty;
        break;
      case 2:
        isValid = state.primaryConcern.isNotEmpty || state.concerns.isNotEmpty;
        break;
      case 3:
        isValid = state.usualWakeTime.isNotEmpty &&
            state.usualBedtime.isNotEmpty &&
            state.nightWakings.isNotEmpty;
        break;
      case 4:
        isValid = state.difficultTimes.isNotEmpty &&
            state.possibleTriggers.isNotEmpty;
        break;
      case 5:
        isValid = state.successGoal.isNotEmpty;
        break;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields to continue."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }''';

  final newNextTap = '''  void _onNextTap(OnboardingState state) {
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
        if (state.parentRole.isEmpty || state.preferredLanguage.isEmpty) {
          isValid = false;
        }
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
        if (state.childGender.isEmpty) isValid = false;
        break;
      case 2:
        isValid = state.primaryConcern.isNotEmpty || state.concerns.isNotEmpty;
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
        if (state.nightWakings.isEmpty) isValid = false;
        break;
      case 4:
        isValid = state.difficultTimes.isNotEmpty &&
            state.possibleTriggers.isNotEmpty;
        break;
      case 5:
        isValid = state.successGoal.isNotEmpty;
        break;
    }

    if (!isValid) {
      setState(() {});
      return;
    }''';
    
  content = content.replaceFirst(oldNextTap, newNextTap);

  // Now inject the UI errors for AppTextFields and Containers
  // 1. Parent Name TextField
  content = content.replaceFirst(
    '''
            AppTextField(
              controller: _nameController,
              title: "Your name",
              hint: "Russell Sprout",
              border: Border.all(color: _accentPurple, width: 1.2),
              borderRadius: BorderRadius.circular(24.r),
              onChanged: (String value) {
                context.read<OnboardingCubit>().updateParentName(value);
              },
            ).appPadding(left: 20.r, right: 20.r),
''',
    '''
            AppTextField(
              controller: _nameController,
              title: "Your name",
              hint: "Russell Sprout",
              showError: _parentNameError.isNotEmpty,
              error: _parentNameError,
              border: Border.all(color: _parentNameError.isNotEmpty ? Colors.redAccent : _accentPurple, width: 1.2),
              borderRadius: BorderRadius.circular(24.r),
              onChanged: (String value) {
                context.read<OnboardingCubit>().updateParentName(value);
                if (_parentNameError.isNotEmpty) setState(() => _parentNameError = "");
              },
            ).appPadding(left: 20.r, right: 20.r),
'''
  );

  // 2. Child Name TextField
  content = content.replaceFirst(
    '''
            AppTextField(
              controller: _childNameController,
              title: "Child's name",
              hint: "Ingredia Nutrisha",
              border: Border.all(color: _accentPurple, width: 1.2),
              borderRadius: BorderRadius.circular(24.r),
              onChanged: (String value) {
                context.read<OnboardingCubit>().updateChildName(value);
              },
            ).appPadding(left: 20.r, right: 20.r),
''',
    '''
            AppTextField(
              controller: _childNameController,
              title: "Child's name",
              hint: "Ingredia Nutrisha",
              showError: _childNameError.isNotEmpty,
              error: _childNameError,
              border: Border.all(color: _childNameError.isNotEmpty ? Colors.redAccent : _accentPurple, width: 1.2),
              borderRadius: BorderRadius.circular(24.r),
              onChanged: (String value) {
                context.read<OnboardingCubit>().updateChildName(value);
                if (_childNameError.isNotEmpty) setState(() => _childNameError = "");
              },
            ).appPadding(left: 20.r, right: 20.r),
'''
  );

  file.writeAsStringSync(content);
}
