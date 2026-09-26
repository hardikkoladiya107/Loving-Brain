import 'dart:io';

void main() {
  final file = File('lib/router/app_router.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceFirst(
    "import 'package:loving_brain/ui/child_profile/child_profile_screen.dart';",
    "import 'package:loving_brain/ui/child_profile_v2/child_profile_screen.dart';"
  );

  file.writeAsStringSync(content);
}
