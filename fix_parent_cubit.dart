import 'dart:io';

void main() {
  final file = File('lib/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll("user.jsonObject['preferred_language']?.toString()", "user.preferredLanguage");
  content = content.replaceAll("user.jsonObject['location']?.toString()", "user.location");
  file.writeAsStringSync(content);
}
