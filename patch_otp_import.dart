import 'dart:io';

void main() {
  var file = File('lib/ui/auth/otp/otp_screen.dart');
  var content = file.readAsStringSync();
  
  if (!content.contains('preferances.dart')) {
    content = content.replaceFirst(
      "import 'package:loving_brain/router/route_paths.dart';",
      "import 'package:loving_brain/router/route_paths.dart';\nimport 'package:loving_brain/other/preferances.dart';"
    );
    file.writeAsStringSync(content);
    print('Added preferances.dart import');
  }
}
