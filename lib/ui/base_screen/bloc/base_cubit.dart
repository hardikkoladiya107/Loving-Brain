import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/auth_repo.dart';
import 'base_state.dart';

class BaseCubit extends Cubit<BaseState> {
  BaseCubit() : super(BaseState());

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription? _profileSubscription;
  StreamSubscription? _childSubscription;

  void changeProps({int? bottomNavigationIndex}) {
    emit(
      state.copyWith(
        bottomNavigationIndex:
            bottomNavigationIndex ?? state.bottomNavigationIndex,
      ),
    );
  }

  void init() {
    emit(BaseState());
    updateFCMToken();
    _listenTokenRefresh();
    _listenToUser();
  }

  void _listenToUser() {
    final currentUser = preferences.getUserModel();
    if ((currentUser?.uid ?? "").isNotEmpty) {
      _profileSubscription?.cancel();
      _profileSubscription = AuthRepo.instance.userCollection
          .doc(currentUser!.uid)
          .snapshots()
          .listen((event) async {
            if (event.data() != null) {
              var userModel = UserModel.fromJson(event.data()!);
              await preferences.saveUserModel(userModel);
              _listenToChild(userModel.defaultChild);
            }
          });
    }
  }

  void _listenToChild(DocumentReference<Object?>? defaultChild) {
    _childSubscription?.cancel();
    _childSubscription = defaultChild?.snapshots().listen((event) async {
      if (event.data() != null) {
        final childModel = ChildModel.fromJson(
          event.data() as Map<String, dynamic>,
          event.reference,
        );
        await preferences.saveChildModel(childModel);
      }
    });
  }

  Future<void> updateFCMToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          await Future<void>.delayed(const Duration(seconds: 2));
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        }
      }

      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await AuthRepo.instance.updateUserToFireStore(
          request: <String, dynamic>{"fcm_token": token},
        );
      }
    } catch (e) {
      // Ignore token-sync failures; app can continue and retry later.
    }
  }

  void _listenTokenRefresh() {
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
        .listen((String token) async {
          await AuthRepo.instance.updateUserToFireStore(
            request: <String, dynamic>{"fcm_token": token},
          );
        });
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    _childSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    return super.close();
  }
}

