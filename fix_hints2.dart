import 'dart:io';

void main() {
  final file = File('lib/ui/onboarding/onboarding_screen.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceAll(
    RegExp(r'state\.location\.appText\(\s*fontSize:\s*15,\s*fontWeight:\s*FontWeight\.w500,\s*color:\s*greyColor9,\s*textAlign:\s*TextAlign\.start,\s*\)'),
    "(state.location.isEmpty ? 'Select Location' : state.location).appText(\n                          fontSize: 15,\n                          fontWeight: FontWeight.w500,\n                          color: state.location.isEmpty ? greyColor : greyColor9,\n                          textAlign: TextAlign.start,\n                        )"
  );
  
  content = content.replaceAll(
    RegExp(r'state\.dateOfBirth\.appText\(\s*fontSize:\s*15,\s*fontWeight:\s*FontWeight\.w500,\s*color:\s*greyColor9,\s*textAlign:\s*TextAlign\.start,\s*\)'),
    "(state.dateOfBirth.isEmpty ? 'Select Date' : state.dateOfBirth).appText(\n                          fontSize: 15,\n                          fontWeight: FontWeight.w500,\n                          color: state.dateOfBirth.isEmpty ? greyColor : greyColor9,\n                          textAlign: TextAlign.start,\n                        )"
  );

  content = content.replaceAll(
    RegExp(r'state\.usualWakeTime\.appText\(\s*fontSize:\s*15,\s*fontWeight:\s*FontWeight\.w500,\s*color:\s*greyColor9,\s*textAlign:\s*TextAlign\.start,\s*\)'),
    "(state.usualWakeTime.isEmpty ? 'Select Time' : state.usualWakeTime).appText(\n                          fontSize: 15,\n                          fontWeight: FontWeight.w500,\n                          color: state.usualWakeTime.isEmpty ? greyColor : greyColor9,\n                          textAlign: TextAlign.start,\n                        )"
  );

  content = content.replaceAll(
    RegExp(r'state\.usualBedtime\.appText\(\s*fontSize:\s*15,\s*fontWeight:\s*FontWeight\.w500,\s*color:\s*greyColor9,\s*textAlign:\s*TextAlign\.start,\s*\)'),
    "(state.usualBedtime.isEmpty ? 'Select Time' : state.usualBedtime).appText(\n                          fontSize: 15,\n                          fontWeight: FontWeight.w500,\n                          color: state.usualBedtime.isEmpty ? greyColor : greyColor9,\n                          textAlign: TextAlign.start,\n                        )"
  );

  file.writeAsStringSync(content);
}
