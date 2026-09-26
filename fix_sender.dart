import 'dart:io';

void main() {
  final file = File('functions/controllers/authController.js');
  var content = file.readAsStringSync();
  
  content = content.replaceFirst(
    'const SENDER_EMAIL = "noreply@lovingbrain.com";',
    'const SENDER_EMAIL = "hardikkoladiya107@gmail.com";'
  );
  
  file.writeAsStringSync(content);
}
