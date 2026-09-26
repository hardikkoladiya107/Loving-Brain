import 'dart:io';

void main() {
  var file = File('lib/ui/onboarding/onboarding_screen.dart');
  var lines = file.readAsLinesSync();
  
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].contains('if (!isValid) return;')) {
      lines[i] = '''
    if (!isValid) {
      showSnackBar(
        message: 'Please fill all required fields in this step.',
        type: SnackBarType.ERROR,
      );
      return;
    }''';
    }
  }

  file.writeAsStringSync(lines.join('\n'));
  print('Patched onboarding_screen.dart');
}
