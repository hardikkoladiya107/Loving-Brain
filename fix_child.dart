import 'dart:io';
import 'dart:convert';

void main() {
  final file = File('lib/ui/child_profile_v2/child_profile_screen.dart');
  final bytes = file.readAsBytesSync();
  var content = utf8.decode(bytes, allowMalformed: true);
  
  if (!content.contains('flutter_bloc.dart')) {
    content = content.replaceFirst(
        '''import 'package:flutter/material.dart';''',
        '''import 'package:flutter/material.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:loving_brain/ui/child_profile_v2/bloc/child_profile_v2_cubit.dart';\nimport 'package:loving_brain/ui/child_profile_v2/bloc/child_profile_v2_state.dart';\nimport 'package:flutter_easyloading/flutter_easyloading.dart';\nimport 'package:loving_brain/other/snack_bar.dart';\nimport 'package:loving_brain/model/api_result_status.dart';'''
    );
  }

  content = content.replaceFirst(
    '''  Widget build(BuildContext context) {
    return Scaffold(''',
    '''  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChildProfileV2Cubit()..init(),
      child: const _ChildProfileView(),
    );
  }
}

class _ChildProfileView extends StatelessWidget {
  const _ChildProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildProfileV2Cubit, ChildProfileV2State>(
      listener: (context, state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(status: 'Saving...'),
          data: (String message) {
            EasyLoading.dismiss();
            showSnackBar(message: message, type: SnackBarType.SUCCESS);
          },
          error: (Exception exception) {
            EasyLoading.dismiss();
            showSnackBar(message: exception.toString().replaceAll('Exception: ', ''), type: SnackBarType.ERROR);
          },
        );
      },
      builder: (context, state) {
        final cubit = context.read<ChildProfileV2Cubit>();
        return Scaffold('''
  );

  final lines = content.split('\\n');
  int lastBracketIndex = -1;
  for (int i = lines.length - 1; i >= 0; i--) {
    if (lines[i].contains('}') && lines[i].trim() == '}') {
      if (lastBracketIndex == -1) {
         lastBracketIndex = i;
         break;
      }
    }
  }

  if (lastBracketIndex != -1) {
     lines.insert(lastBracketIndex, '''      },
    );''');
     content = lines.join('\\n');
  }

  content = content.replaceAll(
    '''                      EditableFieldCard(
                        label: "CHILD'S NAME",
                        value: "Ira",

                        onEdit: () {},
                      ),''',
    '''                      EditableFieldCard(
                        label: "CHILD'S NAME",
                        value: state.name,
                        onChanged: (v) => cubit.updateField(name: v),
                        onEdit: () {},
                      ),'''
  );
  content = content.replaceAll(
    '''                      EditableFieldCard(
                        label: "DATE OF BIRTH",
                        value: "14 March 2024 · 17 months",
                        onEdit: () {},
                      ),''',
    '''                      EditableFieldCard(
                        label: "DATE OF BIRTH",
                        value: state.dob ?? "14 March 2024",
                        onChanged: (v) => cubit.updateField(dob: v),
                        onEdit: () {},
                      ),'''
  );
  content = content.replaceAll(
    '''                      EditableFieldCard(
                        label: "ROUTINES & CONCERNS",
                        value:
                            "Two naps, bedtime around 8. Evenings are hardest.",
                        onEdit: () {},
                      ),''',
    '''                      EditableFieldCard(
                        label: "ROUTINES & CONCERNS",
                        value: state.concerns ?? "Two naps, bedtime around 8. Evenings are hardest.",
                        onChanged: (v) => cubit.updateField(concerns: v),
                        onEdit: () {},
                      ),'''
  );
  content = content.replaceAll(
    '''                      EditableFieldCard(
                        label: "LOCATION / TIME ZONE",
                        value: "Chennai, India (GMT+5:30)",
                        onEdit: () {},
                      ),''',
    '''                      EditableFieldCard(
                        label: "LOCATION / TIME ZONE",
                        value: state.location ?? "Chennai, India (GMT+5:30)",
                        onChanged: (v) => cubit.updateField(location: v),
                        onEdit: () {},
                      ),'''
  );

  content = content.replaceAll(
    '''        child: AppButton(
          title: "Save changes",
          onTap: () {
            Navigator.pop(context);
          },
        ),''',
    '''        child: AppButton(
          title: "Save changes",
          onTap: () {
            cubit.saveProfile();
          },
        ),'''
  );
  
  // also inject constructor params if missing
  if (!content.contains('final String? userId;')) {
      content = content.replaceFirst('class ChildProfileScreen extends StatelessWidget {', '''class ChildProfileScreen extends StatelessWidget {
  final String? userId;
  final bool fromManageChildren;
  const ChildProfileScreen({super.key, this.userId, this.fromManageChildren = false});
''');
      content = content.replaceFirst('  const ChildProfileScreen({super.key});', '');
  }

  file.writeAsBytesSync(utf8.encode(content));
}
