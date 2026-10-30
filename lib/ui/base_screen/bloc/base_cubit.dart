import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/router/route_paths.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';
import '../../../other/fcm_token_service.dart';
import '../../../other/preferances.dart';
import '../../../repo/auth_repo.dart';
import '../../../repo/user_repo.dart';
import 'base_state.dart';

class BaseCubit extends Cubit<BaseState> {
  BaseCubit() : super(BaseState());

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _profileSubscription;
  StreamSubscription<DocumentSnapshot<Object?>>? _childSubscription;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _inviteSubscription;
  String? _routedIncomingInvitationId;

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
    _listenIncomingInvites();
  }

  void _listenIncomingInvites() {
    final String? uid = preferences.getUserModel()?.uid;
    if (uid == null || uid.isEmpty) return;
    _inviteSubscription?.cancel();
    try {
      _inviteSubscription = FirebaseFirestore.instance
          .collection('co-parent-invitation')
          .where('to_uid', isEqualTo: uid)
          .where('status', isEqualTo: 'REQUESTED')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snap) {
            _routeFirstUnexpiredInvite(snap);
          }, onError: (_) {});
    } catch (_) {}
  }

  void _routeFirstUnexpiredInvite(QuerySnapshot<Map<String, dynamic>> snap) {
    final DateTime now = DateTime.now();
    String? invitationId;
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snap.docs) {
      final Map<String, dynamic> data = doc.data();
      final String? expiresAtRaw = data['expires_at']?.toString();
      if (expiresAtRaw != null && expiresAtRaw.isNotEmpty) {
        final DateTime? expires = DateTime.tryParse(expiresAtRaw);
        if (expires != null && expires.isBefore(now)) {
          continue;
        }
      }
      invitationId = doc.id;
      break;
    }
    if (invitationId == null || invitationId.isEmpty) {
      return;
    }
    if (_routedIncomingInvitationId == invitationId) {
      return;
    }
    _routedIncomingInvitationId = invitationId;
    final BuildContext? context = navigatorKey.currentContext;
    if (context == null || !context.mounted) {
      return;
    }
    final UserModel? user = preferences.getUserModel();
    if (user?.isOnboardingCompleted != true) {
      return;
    }
    GoRouter.of(context).push(
      RoutePaths.inviteRespond,
      extra: <String, dynamic>{'invitationId': invitationId},
    );
  }

  void _listenAuth() {
    _authSubscription?.cancel();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          _routedIncomingInvitationId = null;
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
    _routedIncomingInvitationId = null;
    emit(BaseState());
  }

  void cancelSubscriptions() {
    _profileSubscription?.cancel();
    _profileSubscription = null;
    _childSubscription?.cancel();
    _childSubscription = null;
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _inviteSubscription?.cancel();
    _inviteSubscription = null;
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
                _syncSharedNotificationCount(data);
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

  void _syncSharedNotificationCount(Map<String, dynamic> data) {
    final String day = data['notification_sent_day']?.toString() ?? '';
    if (day.isEmpty) {
      return;
    }
    final int remote = (data['notification_sent_count'] as num?)?.toInt() ?? 0;
    final int local = preferences.getInt('v2_notif_count_$day') ?? 0;
    if (remote > local) {
      preferences.putInt('v2_notif_count_$day', remote);
    }
  }

  Future<void> updateFCMToken() async {
    try {
      if (!FcmTokenService.sessionIsLoggedIn()) {
        return;
      }
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          await Future<void>.delayed(const Duration(seconds: 2));
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        }
      }

      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null && FcmTokenService.sessionIsLoggedIn()) {
        await AuthRepo.instance.updateUserToFireStore(
          request: <String, dynamic>{"fcm_token": token},
        );
        await UserRepo.instance.syncDeviceNotificationClock();
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
            if (!FcmTokenService.sessionIsLoggedIn()) {
              return;
            }
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
