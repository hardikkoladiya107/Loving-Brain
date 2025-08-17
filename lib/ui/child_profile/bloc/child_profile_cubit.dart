import 'package:flutter_bloc/flutter_bloc.dart';

import 'child_profile_state.dart';

class ChildProfileCubit extends Cubit<ChildProfileState> {
  ChildProfileCubit() : super(ChildProfileState());

  void changeProps({
    String? message,
    String? childName,
    String? relationShipToChild,
    String? childAge,
  }) {
    emit(
      state.copyWith(
        message: message ?? state.message,
        childName: childName ?? state.childName,
        relationShipToChild: relationShipToChild ?? state.relationShipToChild,
        childAge: childAge ?? state.childAge,
      ),
    );
  }
}
