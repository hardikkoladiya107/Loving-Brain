import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/extra_methods.dart';

import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/auth_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void init() {
    emit(HomeState(userModel: preferences.getUserModel()));
    _listenToUser();
    _updateStreak();
  }

  void changeProps({
    UserModel? userModel,
    ApiResultStatus? apiResultStatus,
    bool? moodLoggedForToday,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        moodLoggedForToday: moodLoggedForToday ?? state.moodLoggedForToday,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  StreamSubscription? profileSubscription;
  StreamSubscription? moodSubscription;

  void _listenToUser() {
    if ((state.userModel?.uid ?? "").isNotEmpty) {
      profileSubscription?.cancel();
      profileSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .snapshots()
          .listen((event) {
            if (event.data() != null) {
              changeProps(userModel: UserModel.fromJson(event.data()));
            }
          });

      moodSubscription?.cancel();
      moodSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .collection("mood")
          .snapshots()
          .listen((event) {
            if (event.docs.any(
              (element) => element.id == getStringDate(DateTime.now()),
            )) {
              changeProps(moodLoggedForToday: true);
            }
          });
    }
  }

  void dispose() {
    profileSubscription?.cancel();
    moodSubscription?.cancel();
  }

  Future<void> _updateStreak() async {
    if (state.userModel?.lastOpened != null) {
      if (!isSameDate(state.userModel!.lastOpened!, DateTime.now())) {
        Map<String, dynamic> request = {};
        if (isBeforeYesterday(state.userModel!.lastOpened!)) {
          request = {"streak": 1, "last_opened": DateTime.now()};
        } else {
          request = {
            "streak": (state.userModel?.streak ?? 0) + 1,
            "last_opened": DateTime.now(),
          };
        }
        final credential = await AuthRepo.instance.updateUserToFireStore(
          request: request,
        );
        changeProps(apiResultStatus: credential);
      }
    }
  }
}
