import re

with open('lib/ui/parent_profile_v2/parent_profile_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

if 'flutter_bloc.dart' not in content:
    content = content.replace(
        '''import 'package:flutter/material.dart';''',
        '''import 'package:flutter/material.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart';\nimport 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_state.dart';\nimport 'package:flutter_easyloading/flutter_easyloading.dart';\nimport 'package:loving_brain/other/snack_bar.dart';\nimport 'package:loving_brain/model/api_result_status.dart';'''
    )

content = content.replace(
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
)

content = content.replace(
'''      ),
    );
  }''',
'''      ),
    );
      },
    );
  }'''
)

content = content.replace(
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
)
content = content.replace(
    '''                      EditableFieldCard(
                        label: "YOUR EMAIL",
                        value: "ashan@example.com",
                        onEdit: () {},
                      ),''',
    '''                      EditableFieldCard(
                        label: "YOUR EMAIL",
                        value: state.user?.email ?? "",
                      ),'''
)
content = content.replace(
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
)
content = content.replace(
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
)

content = content.replace(
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
)

with open('lib/ui/parent_profile_v2/parent_profile_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
