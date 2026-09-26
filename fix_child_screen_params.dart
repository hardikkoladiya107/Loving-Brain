import 'dart:io';

void main() {
  final file = File('lib/ui/child_profile_v2/child_profile_screen.dart');
  var content = file.readAsStringSync();
  
  final regex = RegExp(r'class ChildProfileScreen extends StatelessWidget \{(.*?)\}', multiLine: true, dotAll: true);
  
  content = content.replaceFirst(
    'class ChildProfileScreen extends StatelessWidget {\\r\\n  const ChildProfileScreen({super.key});',
    '''class ChildProfileScreen extends StatelessWidget {
  final String? userId;
  final bool fromManageChildren;

  const ChildProfileScreen({
    super.key,
    this.userId,
    this.fromManageChildren = false,
  });'''
  );

  // Fallback if \r\n wasn't the issue
  if (!content.contains('final String? userId;')) {
    content = content.replaceAll(
      'const ChildProfileScreen({super.key});',
      '''final String? userId;
  final bool fromManageChildren;

  const ChildProfileScreen({
    super.key,
    this.userId,
    this.fromManageChildren = false,
  });'''
    );
  }

  file.writeAsStringSync(content);
}
