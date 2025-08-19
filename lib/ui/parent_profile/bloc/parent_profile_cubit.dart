import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/parent_profile/bloc/parent_profile_state.dart';

class ParentProfileCubit extends Cubit<ParentProfileState> {
  ParentProfileCubit() : super(ParentProfileState());

  void changeProps({
    String? selectedGender,
    String? parentName,
    String? parentEmail,
    String? message,
    DateTime? dateOfBirth,
    List<String>? genderList,
  }) {
    emit(
      state.copyWith(
        message: message ?? state.message,
        parentName: parentName ?? state.parentName,
        parentEmail: parentEmail ?? state.parentEmail,
        dateOfBirth: dateOfBirth ?? state.dateOfBirth,
        genderList: genderList ?? state.genderList,
        selectedGender: selectedGender ?? state.selectedGender,
      ),
    );
  }

  void init() {
    emit(ParentProfileState());
    changeProps(genderList: ["Male", "Female", "Other"]);
  }
}
