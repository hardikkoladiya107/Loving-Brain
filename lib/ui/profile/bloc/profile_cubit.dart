import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/profile/bloc/profile_state.dart';

import '../../../model/api_result_status.dart';
import '../../../repo/auth_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  void init() {
    emit(ProfileState(userModel: preferences.getUserModel()));
    _listenToUser();
  }

  void changeProps({
    bool? dailyEmotionCheck,
    bool? todaysPlayIdea,
    bool? scheduleReminder,
    ApiResultStatus? logoutApiResultStatus,
    ApiResultStatus? deleteAccountApiResultStatus,
    UserModel? userModel,
  }) {
    emit(
      state.copyWith(
        dailyEmotionCheck: dailyEmotionCheck ?? state.dailyEmotionCheck,
        todaysPlayIdea: todaysPlayIdea ?? state.todaysPlayIdea,
        scheduleReminder: scheduleReminder ?? state.scheduleReminder,
        userModel: userModel ?? state.userModel,
        logoutApiResultStatus:
            logoutApiResultStatus ?? state.logoutApiResultStatus,
        deleteAccountApiResultStatus:
            deleteAccountApiResultStatus ?? state.deleteAccountApiResultStatus,
      ),
    );
  }

  Future<void> deleteAccount() async {
    changeProps(deleteAccountApiResultStatus: ApiResultStatus.loading());
    var apiResult = await AuthRepo.instance.deleteAccount();
    changeProps(deleteAccountApiResultStatus: apiResult);
  }

  Future<void> logout() async {
    changeProps(logoutApiResultStatus: ApiResultStatus.loading());
    var apiResult = await AuthRepo.instance.logout();
    changeProps(logoutApiResultStatus: apiResult);
  }

  StreamSubscription? profileSubscription;

  void _listenToUser() {
    if (state.userModel != null) {
      profileSubscription?.cancel();
      profileSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .snapshots()
          .listen((event) {
            if (event.data() != null) {
              changeProps(userModel: UserModel.fromJson(event.data() as Map<String, dynamic>));
            }
          });
    }
  }

  void dispose() {
    profileSubscription?.cancel();
  }
}
