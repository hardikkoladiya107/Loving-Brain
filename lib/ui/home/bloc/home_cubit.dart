import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/extra_methods.dart';
import 'package:loving_brain/repo/user_repo.dart';

import '../../../model/child_model.dart';
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
    _loadTodayParentingTip();
  }

  void changeProps({
    UserModel? userModel,
    ApiResultStatus? apiResultStatus,
    bool? moodLoggedForToday,
    ChildModel? childModel,
    String? todayParentingTip,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        moodLoggedForToday: moodLoggedForToday ?? state.moodLoggedForToday,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        todayParentingTip: todayParentingTip ?? state.todayParentingTip,
      ),
    );
  }

  StreamSubscription? profileSubscription;
  StreamSubscription? moodSubscription;
  StreamSubscription? childSubscription;

  void _listenToUser() {
    if ((state.userModel?.uid ?? "").isNotEmpty) {
      profileSubscription?.cancel();
      profileSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .snapshots()
          .listen((event) async {
            if (event.data() != null) {
              var userModel = UserModel.fromJson(event.data()!);
              await preferences.saveUserModel(userModel);
              _listenToChild(userModel.defaultChild);
              changeProps(userModel: userModel);
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

  void _listenToChild(DocumentReference<Object?>? defaultChild) {
    childSubscription?.cancel();
    childSubscription = defaultChild?.snapshots().listen((event) {
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

  Future<void> _loadTodayParentingTip() async {
    changeProps(todayParentingTip: await UserRepo.instance.getTipOfTheDay());
  }
}
