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
    changeProps(deleteAccountApiResultStatus: const ApiResultStatus.loading());
    final ApiResultStatus apiResult = await AuthRepo.instance.deleteAccount();
    changeProps(deleteAccountApiResultStatus: apiResult);
  }

  Future<void> logout() async {
    profileSubscription?.cancel();
    profileSubscription = null;
    changeProps(logoutApiResultStatus: const ApiResultStatus.loading());
    final ApiResultStatus apiResult = await AuthRepo.instance.logout();
    changeProps(logoutApiResultStatus: apiResult);
  }

  StreamSubscription? profileSubscription;

  void _listenToUser() {
    final UserModel? user = state.userModel;
    final String? uid = user?.uid;
    if (uid != null && uid.isNotEmpty) {
      profileSubscription?.cancel();
      profileSubscription = AuthRepo.instance.userCollection
          .doc(uid)
          .snapshots()
          .listen(
            (event) {
              final Object? data = event.data();
              if (data is Map<String, dynamic>) {
                changeProps(userModel: UserModel.fromJson(data));
              }
            },
            onError: (_) {
              profileSubscription?.cancel();
              profileSubscription = null;
            },
            cancelOnError: true,
          );
    }
  }

  void dispose() {
    profileSubscription?.cancel();
  }

  @override
  Future<void> close() {
    profileSubscription?.cancel();
    return super.close();
  }

  void updateNotification() {
    // Optimistic update: flip the value in UI immediately
    final UserModel? user = state.userModel;
    if (user != null) {
      final bool newVal = !(user.isNotification ?? false);
      changeProps(userModel: user.copyWith(isNotification: newVal));
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
      changeProps(uploadFileApiResultStatus: const ApiResultStatus.loading());
      final ApiResultStatus uploadFileApiResultStatus = await UserRepo.instance
          .uploadFileToFirebaseStorage(
            file: File(imageLocalPath),
            referenceId: state.userModel?.uid,
          );
      changeProps(uploadFileApiResultStatus: uploadFileApiResultStatus);
      uploadFileApiResultStatus.whenOrNull(
        data: (dynamic data) async {
          if (data is TaskSnapshot) {
            final String imageNetworkUrl = await data.ref.getDownloadURL();
            UserRepo.instance.updateUserToFireStore(
              request: <String, dynamic>{"profile_image": imageNetworkUrl},
            );
          }
        },
        error: (Exception error) {},
      );
    }
  }
}
