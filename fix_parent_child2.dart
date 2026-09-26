import 'dart:io';

void main() {
  final pFile = File('lib/ui/parent_profile_v2/parent_profile_screen.dart');
  var pContent = pFile.readAsStringSync();
  
  // Strip \r
  pContent = pContent.replaceAll('\r', '');

  if (!pContent.contains('BlocProvider')) {
    pContent = pContent.replaceFirst(
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

    pContent = pContent.replaceFirst(
'''      ),
    );
  }''',
'''      ),
    );
      },
    );
  }'''
    );
    
    pContent = pContent.replaceFirst(
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
    pContent = pContent.replaceFirst(
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
    pContent = pContent.replaceFirst(
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
    pContent = pContent.replaceFirst(
      '''                      EditableFieldCard(
                        label: "LOCATION / TIME ZONE",
                        value: "Chennai, India (GMT+5:30)",
                        onEdit: () {},
                      ),''',
      '''                      EditableFieldCard(
                        label: "LOCATION / TIME ZONE",
                        value: state.location ?? "Chennai, India",
                        onChanged: (v) => cubit.updateField(location: v),
                        onEdit: () {},
                      ),'''
    );
    pContent = pContent.replaceFirst(
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
    
    pFile.writeAsStringSync(pContent);
  }


  final cFile = File('lib/ui/child_profile_v2/child_profile_screen.dart');
  var cContent = cFile.readAsStringSync();
  cContent = cContent.replaceAll('\r', '');
  
  if (!cContent.contains('BlocProvider')) {
    cContent = cContent.replaceFirst(
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

    cContent = cContent.replaceFirst(
'''      ),
    );
  }''',
'''      ),
    );
      },
    );
  }'''
    );
    
    cContent = cContent.replaceFirst(
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
    // Replace the exact line with the dot properly:
    cContent = cContent.replaceAll(
      '14 March 2024 · 17 months',
      '14 March 2024'
    );
    cContent = cContent.replaceFirst(
      '''                      EditableFieldCard(
                        label: "DATE OF BIRTH",
                        value: "14 March 2024",
                        onEdit: () {},
                      ),''',
      '''                      EditableFieldCard(
                        label: "DATE OF BIRTH",
                        value: state.dob,
                        onChanged: (v) => cubit.updateField(dob: v),
                        onEdit: () {},
                      ),'''
    );
    cContent = cContent.replaceFirst(
      '''                      EditableFieldCard(
                        label: "ROUTINES & CONCERNS",
                        value:
                            "Two naps, bedtime around 8. Evenings are hardest.",
                        onEdit: () {},
                      ),''',
      '''                      EditableFieldCard(
                        label: "ROUTINES & CONCERNS",
                        value: state.concerns,
                        onChanged: (v) => cubit.updateField(concerns: v),
                        onEdit: () {},
                      ),'''
    );
    cContent = cContent.replaceFirst(
      '''                      EditableFieldCard(
                        label: "LOCATION / TIME ZONE",
                        value: "Chennai, India (GMT+5:30)",
                        onEdit: () {},
                      ),''',
      '''                      EditableFieldCard(
                        label: "LOCATION / TIME ZONE",
                        value: state.location,
                        onChanged: (v) => cubit.updateField(location: v),
                        onEdit: () {},
                      ),'''
    );
    cContent = cContent.replaceFirst(
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

    cFile.writeAsStringSync(cContent);
  }
}
