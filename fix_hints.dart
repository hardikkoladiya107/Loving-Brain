import 'dart:io';

void main() {
  final file = File('lib/ui/onboarding/onboarding_screen.dart');
  var content = file.readAsStringSync();
  
  // 1. Fix Location hint
  content = content.replaceAll(
    '''
                        state.location.appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: greyColor9,
                          textAlign: TextAlign.start,
                        ),
''',
    '''
                        (state.location.isEmpty ? 'Select Location' : state.location).appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: state.location.isEmpty ? greyColor : greyColor9,
                          textAlign: TextAlign.start,
                        ),
'''
  );

  // 2. Fix Date of Birth hint
  content = content.replaceAll(
    '''
                        state.dateOfBirth.appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: greyColor9,
                          textAlign: TextAlign.start,
                        ),
''',
    '''
                        (state.dateOfBirth.isEmpty ? 'Select Date' : state.dateOfBirth).appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: state.dateOfBirth.isEmpty ? greyColor : greyColor9,
                          textAlign: TextAlign.start,
                        ),
'''
  );

  // 3. Fix Wake Time hint
  content = content.replaceAll(
    '''
                        state.usualWakeTime.appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: greyColor9,
                          textAlign: TextAlign.start,
                        ),
''',
    '''
                        (state.usualWakeTime.isEmpty ? 'Select Time' : state.usualWakeTime).appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: state.usualWakeTime.isEmpty ? greyColor : greyColor9,
                          textAlign: TextAlign.start,
                        ),
'''
  );

  // 4. Fix Bedtime hint
  content = content.replaceAll(
    '''
                        state.usualBedtime.appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: greyColor9,
                          textAlign: TextAlign.start,
                        ),
''',
    '''
                        (state.usualBedtime.isEmpty ? 'Select Time' : state.usualBedtime).appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: state.usualBedtime.isEmpty ? greyColor : greyColor9,
                          textAlign: TextAlign.start,
                        ),
'''
  );

  file.writeAsStringSync(content);
}
