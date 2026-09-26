import 'dart:io';

void main() {
  final file = File('lib/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart');
  var content = file.readAsStringSync();
  
  if (!content.contains("import 'package:cloud_firestore/cloud_firestore.dart';")) {
    content = "import 'package:cloud_firestore/cloud_firestore.dart';\n" + content;
  }
  
  content = content.replaceFirst(
    '''          final parsedDate = DateFormat('yyyy-MM-dd').parse(state.dob);
          updatedUser['parent_date_of_birth'] = parsedDate; // Note: Firestore needs Timestamp, but our model might convert or we pass DateTime.''',
    '''          final parsedDate = DateFormat('yyyy-MM-dd').parse(state.dob);
          updatedUser['parent_date_of_birth'] = Timestamp.fromDate(parsedDate);'''
  );

  file.writeAsStringSync(content);
}
