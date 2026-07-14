import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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
    ApiResultStatus? uploadFileApiResultStatus,
    UserModel? userModel,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        uploadFileApiResultStatus:
            uploadFileApiResultStatus ?? ApiResultStatus.initial(),
        logoutApiResultStatus:
            logoutApiResultStatus ?? ApiResultStatus.initial(),
        deleteAccountApiResultStatus:
            deleteAccountApiResultStatus ?? ApiResultStatus.initial(),
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

  void updateNotification() {
    // Optimistic update: flip the value in UI immediately
    if (state.userModel != null) {
      final newVal = !(state.userModel!.isNotification ?? false);
      changeProps(userModel: state.userModel!.copyWith(isNotification: newVal));
    }
    // Persist to SharedPrefs + Firestore in the background
    UserRepo.instance.updateNotification();
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

  Future<void> selectImage(String? imageLocalPath) async {
    if (imageLocalPath != null) {
      changeProps(uploadFileApiResultStatus: ApiResultStatus.loading());
      var uploadFileApiResultStatus = await UserRepo.instance
          .uploadFileToFirebaseStorage(
            file: File(imageLocalPath),
            referenceId: state.userModel?.uid,
          );
      changeProps(uploadFileApiResultStatus: uploadFileApiResultStatus);
      uploadFileApiResultStatus.whenOrNull(
        data: (data) async {
          if (data is TaskSnapshot) {
            data.ref.fullPath;
            var imageNetworkUrl = await data.ref.getDownloadURL();
            UserRepo.instance.updateUserToFireStore(
              request: {"profile_image": imageNetworkUrl},
            );
          }
        },
        error: (error) {},
      );
    }
  }
}
