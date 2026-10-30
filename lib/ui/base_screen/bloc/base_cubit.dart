import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _profileSubscription;
  StreamSubscription<DocumentSnapshot<Object?>>? _childSubscription;
  StreamSubscription<User?>? _authSubscription;

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
    _listenAuth();
    updateFCMToken();
    _listenTokenRefresh();
    _listenToUser();
  }

  void _listenAuth() {
    _authSubscription?.cancel();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          cancelSubscriptions();
        }
      },
      onError: (_) {
        cancelSubscriptions();
      },
    );
  }

  void reset() {
    cancelSubscriptions();
    _authSubscription?.cancel();
    _authSubscription = null;
    emit(BaseState());
  }

  void cancelSubscriptions() {
    _profileSubscription?.cancel();
    _profileSubscription = null;
    _childSubscription?.cancel();
    _childSubscription = null;
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }

  void _listenToUser() {
    final UserModel? currentUser = preferences.getUserModel();
    final String? uid = currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      _profileSubscription?.cancel();
      _profileSubscription = AuthRepo.instance.userCollection
          .doc(uid)
          .snapshots()
          .listen(
            (DocumentSnapshot<Map<String, dynamic>> event) async {
              final Map<String, dynamic>? data = event.data();
              if (data != null) {
                final UserModel userModel = UserModel.fromJson(data);
                await preferences.saveUserModel(userModel);
                _listenToChild(userModel.defaultChild);
              }
            },
            onError: (Object error) {
              _profileSubscription?.cancel();
              _profileSubscription = null;
            },
            cancelOnError: true,
          );
    }
  }

  void _listenToChild(DocumentReference<Object?>? defaultChild) {
    _childSubscription?.cancel();
    _childSubscription = defaultChild?.snapshots().listen(
      (DocumentSnapshot<Object?> event) async {
        final Object? childData = event.data();
        if (childData is Map<String, dynamic>) {
          final ChildModel childModel = ChildModel.fromJson(
            childData,
            event.reference,
          );
          await preferences.saveChildModel(childModel);
        }
      },
      onError: (Object error) {
        _childSubscription?.cancel();
        _childSubscription = null;
      },
      cancelOnError: true,
    );
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
        .listen(
          (String token) async {
            await AuthRepo.instance.updateUserToFireStore(
              request: <String, dynamic>{"fcm_token": token},
            );
          },
          onError: (_) {
            _tokenRefreshSubscription?.cancel();
            _tokenRefreshSubscription = null;
          },
          cancelOnError: true,
        );
  }

  @override
  Future<void> close() {
    cancelSubscriptions();
    _authSubscription?.cancel();
    return super.close();
  }
}
