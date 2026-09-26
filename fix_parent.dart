import 'dart:io';
import 'dart:convert';

void main() {
  final file = File('lib/ui/parent_profile_v2/parent_profile_screen.dart');
  final bytes = file.readAsBytesSync();
  var content = utf8.decode(bytes, allowMalformed: true);
  
  if (!content.contains('flutter_bloc.dart')) {
    content = content.replaceFirst(
        '''import 'package:flutter/material.dart';''',
        '''import 'package:flutter/material.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart';\nimport 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_state.dart';\nimport 'package:flutter_easyloading/flutter_easyloading.dart';\nimport 'package:loving_brain/other/snack_bar.dart';\nimport 'package:loving_brain/model/api_result_status.dart';'''
    );
  }

  content = content.replaceFirst(
    '''  Widget build(BuildContext context) {
    return Scaffold(''',
    '''  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentProfileV2Cubit()..init(),
      child: const _ParentProfileView(),
    );
  }
}

class _ParentProfileView extends StatelessWidget {
  const _ParentProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentProfileV2Cubit, ParentProfileV2State>(
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
        final cubit = context.read<ParentProfileV2Cubit>();
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
                        label: "YOUR NAME",
                        value: "Ashan",

                        onEdit: () {},
                      ),''',
    '''                      EditableFieldCard(
                        label: "YOUR NAME",
                        value: state.name,
                        onChanged: (v) => cubit.updateField(name: v),
                        onEdit: () {},
                      ),'''
  );
  content = content.replaceAll(
    '''                      EditableFieldCard(
                        label: "YOUR EMAIL",
                        value: "ashan@example.com",
                        onEdit: () {},
                      ),''',
    '''                      EditableFieldCard(
                        label: "YOUR EMAIL",
                        value: state.user?.email ?? "",
                      ),'''
  );
  content = content.replaceAll(
    '''                      EditableFieldCard(
                        label: "PREFERRED LANGUAGE",
                        value: "English",
                        onEdit: () {},
                      ),''',
    '''                      EditableFieldCard(
                        label: "PREFERRED LANGUAGE",
                        value: state.language ?? "English",
                        onChanged: (v) => cubit.updateField(language: v),
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

  file.writeAsBytesSync(utf8.encode(content));
}
