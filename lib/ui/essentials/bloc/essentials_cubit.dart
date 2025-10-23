import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import 'essentials_state.dart';

class EssentialsCubit extends Cubit<EssentialsState> {
  EssentialsCubit() : super(EssentialsState());

  void init() {
    emit(EssentialsState(userModel: preferences.getUserModel()));
    _listenToChild();
  }

  void changeProps({ChildModel? childModel, UserModel? userModel}) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
      ),
    );
  }

  StreamSubscription? sharedEventStreamSubscription;

  void _listenToChild() {
    if (state.userModel?.defaultChild != null) {
      sharedEventStreamSubscription?.cancel();
      sharedEventStreamSubscription = state.userModel?.defaultChild!
          .snapshots()
          .listen((event) {
            if (event.data() != null) {
              changeProps(
                childModel: ChildModel.fromJson(
                  event.data() as Map<String, dynamic>,
                  event.reference,
                ),
              );
            }
          });
    }
  }
}
