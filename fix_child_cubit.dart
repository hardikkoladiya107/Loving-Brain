import 'dart:io';

void main() {
  final file = File('lib/ui/child_profile_v2/bloc/child_profile_v2_state.dart');
  var content = file.readAsStringSync();
  
  if (!content.contains('concerns')) {
    content = content.replaceFirst(
      '''    @Default('') String conditions,''',
      '''    @Default('') String conditions,
    @Default('') String dob,
    @Default('') String concerns,
    @Default('') String location,'''
    );
    file.writeAsStringSync(content);
  }

  final cubitFile = File('lib/ui/child_profile_v2/bloc/child_profile_v2_cubit.dart');
  var cubitContent = cubitFile.readAsStringSync();
  
  if (!cubitContent.contains('concerns')) {
    cubitContent = cubitContent.replaceAll(
      '''  void updateField({String? name, String? age, String? conditions}) {
    emit(state.copyWith(
      name: name ?? state.name,
      age: age ?? state.age,
      conditions: conditions ?? state.conditions,
    ));
  }''',
      '''  void updateField({String? name, String? age, String? conditions, String? dob, String? concerns, String? location}) {
    emit(state.copyWith(
      name: name ?? state.name,
      age: age ?? state.age,
      conditions: conditions ?? state.conditions,
      dob: dob ?? state.dob,
      concerns: concerns ?? state.concerns,
      location: location ?? state.location,
    ));
  }'''
    );
    
    // add them to toJson
    cubitContent = cubitContent.replaceAll(
      '''      updatedChild['conditions'] = state.conditions;''',
      '''      updatedChild['conditions'] = state.conditions;
      updatedChild['dob'] = state.dob;
      updatedChild['concerns'] = state.concerns;
      updatedChild['location'] = state.location;'''
    );
    
    // add to init
    cubitContent = cubitContent.replaceAll(
      '''            conditions: conditionsStr,''',
      '''            conditions: conditionsStr,
            dob: data['dob']?.toString() ?? '',
            concerns: data['concerns']?.toString() ?? '',
            location: data['location']?.toString() ?? '','''
    );

    cubitFile.writeAsStringSync(cubitContent);
  }
}
