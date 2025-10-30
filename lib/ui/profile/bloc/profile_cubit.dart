import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/ui/profile/bloc/profile_state.dart';
import 'package:share_plus/share_plus.dart';

import '../../../model/api_result_status.dart';
import '../../../repo/auth_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  void init() {
    emit(ProfileState(userModel: preferences.getUserModel()));
    _listenToUser();
  }

  void changeProps({
    ApiResultStatus? logoutApiResultStatus,
    ApiResultStatus? deleteAccountApiResultStatus,
    UserModel? userModel,
  }) {
    emit(
      state.copyWith(
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
              changeProps(
                userModel: UserModel.fromJson(
                  event.data() as Map<String, dynamic>,
                ),
              );
            }
          });
    }
  }

  void dispose() {
    profileSubscription?.cancel();
  }

  updateGentleReminder() {
    UserRepo.instance.updateGentleReminder();
  }

  updateScheduleReminder() {
    UserRepo.instance.updateScheduleReminder();
  }

  updateDailyEmotion() {
    UserRepo.instance.updateDailyEmotion();
  }

  updateTodaysPlayIdea() {
    UserRepo.instance.updateTodaysPlayIdea();
  }

  void shareApp() {
    SharePlus.instance.share(
      ShareParams(
        text:
            'Check out the Loving Brain app for parents! Download it here: https://www.lovingbrain.com',
      ),
    );
  }

  Future<void> rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      showSnackBar(
        message: "No app available on store",
        type: SnackBarType.ERROR,
      );
    }
  }
}
