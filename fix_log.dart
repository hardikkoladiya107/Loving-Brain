import 'dart:io';

void main() {
  final file = File('functions/controllers/authController.js');
  var content = file.readAsStringSync();
  
  final regex = RegExp(r'if \(!response\.ok\) \{[\s\S]*?throw new HttpsError\("internal", "Failed to send OTP email via Brevo\."\);\s*\}');
  final replacement = '''
    if (!response.ok) {
      const errorText = await response.text();
      logger.error(Brevo email failed with status \: \);
      throw new HttpsError("internal", "Failed to send OTP email via Brevo.");
    } else {
      const successData = await response.json();
      logger.info(Brevo email sent successfully! Response: \);
    }
''';

  content = content.replaceFirst(regex, replacement.trim());
  file.writeAsStringSync(content);
}
