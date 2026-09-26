import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'child_profile_v2_state.dart';

class ChildProfileV2Cubit extends Cubit<ChildProfileV2State> {
  ChildProfileV2Cubit() : super(const ChildProfileV2State());

  Future<void> init() async {
    final user = preferences.getUserModel();
    if (user != null && user.defaultChild != null) {
      try {
        final doc = await user.defaultChild!.get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          final childModel = ChildModel.fromJson(data, doc.reference);
          final conditionsStr = data.containsKey('conditions') ? data['conditions'].toString() : '';
          
          emit(state.copyWith(
            childModel: childModel,
            name: childModel.childName ?? '',
            age: childModel.childAge ?? '',
            conditions: conditionsStr,
            dob: data['dob']?.toString() ?? '',
            concerns: data['concerns']?.toString() ?? '',
            location: data['location']?.toString() ?? '',
          ));
        }
      } catch (e) {
        // Log or handle error if needed
      }
    }
  }

  void updateField({String? name, String? age, String? conditions, String? dob, String? concerns, String? location}) {
    emit(state.copyWith(
      name: name ?? state.name,
      age: age ?? state.age,
      conditions: conditions ?? state.conditions,
      dob: dob ?? state.dob,
      concerns: concerns ?? state.concerns,
      location: location ?? state.location,
    ));
  }

  Future<void> saveProfile() async {
    final child = state.childModel;
    if (child == null || child.reference == null) return;
    
    emit(state.copyWith(saveStatus: const ApiResultStatus.loading()));
    
    try {
      final updatedChild = child.toJson();
      updatedChild['child_name'] = state.name;
      updatedChild['child_age'] = state.age;
      updatedChild['conditions'] = state.conditions;
      updatedChild['dob'] = state.dob;
      updatedChild['concerns'] = state.concerns;
      updatedChild['location'] = state.location;

      await child.reference!.update(updatedChild);

      final doc = await child.reference!.get();
      final updatedData = doc.data() as Map<String, dynamic>;
      final newChild = ChildModel.fromJson(updatedData, doc.reference);
      
      await preferences.saveChildModel(newChild);
      
      emit(state.copyWith(
        childModel: newChild,
        saveStatus: const ApiResultStatus.data(data: 'Profile saved successfully')
      ));
    } catch (e) {
      emit(state.copyWith(saveStatus: ApiResultStatus.error(error: Exception(e.toString()))));
    }
  }
}
