import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repo/auth_repo.dart';
import 'base_state.dart';

class BaseCubit extends Cubit<BaseState> {
  BaseCubit() : super(BaseState());

  StreamSubscription<String>? _tokenRefreshSubscription;

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
    _tokenRefreshSubscription?.cancel();
    return super.close();
  }
}
