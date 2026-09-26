import 'dart:io';

void main() {
  final pFile = File('lib/ui/parent_profile_v2/parent_profile_screen.dart');
  var pContent = pFile.readAsStringSync();
  pContent = pContent.replaceAll('cubit.saveProfile();', 'context.read<ParentProfileV2Cubit>().saveProfile();');
  pFile.writeAsStringSync(pContent);

  final cFile = File('lib/ui/child_profile_v2/child_profile_screen.dart');
  var cContent = cFile.readAsStringSync();
  cContent = cContent.replaceAll('cubit.saveProfile();', 'context.read<ChildProfileV2Cubit>().saveProfile();');
  cFile.writeAsStringSync(cContent);
}
