import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/app_session_manager.dart';
import 'package:loving_brain/other/family_membership_helpers.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../generated/locale_keys.g.dart';
import '../manager/apple_sign_in/apple_signin_manager.dart';
import '../manager/google_sign_in/google_signin_manager.dart';
import '../model/user_model.dart';
import '../other/extra_methods.dart';

class AuthRepo {
  AuthRepo._();

  static final AuthRepo _instance = AuthRepo._();

  factory AuthRepo() {
    return _instance;
  }

  static AuthRepo get instance => _instance;

  CollectionReference<Map<String, dynamic>> get userCollection =>
      FirebaseFirestore.instance.collection('users');
  CollectionReference<Map<String, dynamic>> get childrenCollection =>
      FirebaseFirestore.instance.collection('children');
  CollectionReference<Map<String, dynamic>> get _sharedEventCollection =>
      FirebaseFirestore.instance.collection('shared_event');
  CollectionReference<Map<String, dynamic>> get _coParentInvitationCollection =>
      FirebaseFirestore.instance.collection('co-parent-invitation');

  /// Removes [removeRef] from the user children list and promotes the next
  /// remaining child as default_child when available.
  Future<UserModel> _promoteNextDefaultChild({
    required String uId,
    required UserModel userModel,
    required DocumentReference removeRef,
  }) async {
    final List<DocumentReference> remaining =
        (userModel.children ?? <DocumentReference>[])
            .where((DocumentReference ref) => ref.id != removeRef.id)
            .toList();

    final Map<String, dynamic> updates = <String, dynamic>{
      'children': FieldValue.arrayRemove(<dynamic>[removeRef]),
    };
    if (remaining.isNotEmpty) {
      updates['default_child'] = remaining.first;
    } else {
      updates['default_child'] = FieldValue.delete();
    }
    await userCollection.doc(uId).update(updates).catchError((_) => null);

    if (remaining.isNotEmpty) {
      try {
        final DocumentSnapshot<Object?> nextSnap = await remaining.first.get();
        final Object? nextData = nextSnap.data();
        if (nextSnap.exists && nextData is Map<String, dynamic>) {
          final List<dynamic>? pIds =
              nextData['parent_reference_ids'] as List<dynamic>?;
          if (pIds != null && pIds.contains(uId)) {
            final ChildModel childModel = ChildModel.fromJson(
              nextData,
              remaining.first,
            );
            await preferences.saveDefaultChildModel(childModel);
            await preferences.saveChildModel(childModel);
            final UserModel? refreshed = await getUserFromUid(uId: uId);
            if (refreshed != null) {
              await preferences.saveUserModel(refreshed);
              return refreshed;
            }
          }
        }
      } catch (_) {}
    }

    await preferences.clearChild();
    await preferences.putString(SharedPreference.child, '');
    final UserModel updatedUser = userModel.copyWith(
      clearDefaultChild: true,
      children: remaining,
    );
    await preferences.saveUserModel(updatedUser);
    return updatedUser;
  }

  Future<bool> currentUserExist({required String uId}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await userCollection.doc(uId).get();
      return userSnapshot.exists;
    } on FirebaseException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getUserFromUid({required String uId}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> user = await userCollection
          .doc(uId)
          .get();
      if (user.data() != null) {
        final Map<String, dynamic> data = user.data()!;
        data['uid'] = uId;
        return UserModel.fromJson(data);
      } else {
        return null;
      }
    } on FirebaseException {
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Syncs the user document and their default child document from Firestore
  /// into local SharedPreferences and marks [SharedPreference.isLogin] true.
  Future<UserModel?> syncUserAndDefaultChild({required String uId}) async {
    final UserModel? userModel = await getUserFromUid(uId: uId);
    if (userModel == null) return null;

    await preferences.saveUserModel(userModel);
    await preferences.putBool(SharedPreference.isLogin, true);

    try {
      final List<DocumentReference<Object?>?>? userChildren =
          userModel.children;
      final DocumentReference? childRef =
          userModel.defaultChild ??
          ((userChildren != null && userChildren.isNotEmpty)
              ? userChildren.first
              : null);
      if (childRef != null) {
        final DocumentSnapshot<Object?> childSnap = await childRef.get();
        final Object? childData = childSnap.data();
        if (childSnap.exists && childData is Map<String, dynamic>) {
          final List<dynamic>? pIds =
              childData['parent_reference_ids'] as List<dynamic>?;
          final bool isLinked = pIds != null && pIds.contains(uId);
          if (isLinked) {
            final ChildModel childModel = ChildModel.fromJson(
              childData,
              childRef,
            );
            await preferences.saveDefaultChildModel(childModel);
            await preferences.saveChildModel(childModel);
          } else {
            return await _promoteNextDefaultChild(
              uId: uId,
              userModel: userModel,
              removeRef: childRef,
            );
          }
        } else {
          return await _promoteNextDefaultChild(
            uId: uId,
            userModel: userModel,
            removeRef: childRef,
          );
        }
      } else {
        await preferences.clearChild();
        await preferences.putString(SharedPreference.child, '');
      }
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException during syncDefaultChild: ${e.code} / $e');
      if (e.code == 'permission-denied') {
        final DocumentReference? badRef =
            userModel.defaultChild ??
            ((userModel.children != null && userModel.children!.isNotEmpty)
                ? userModel.children!.first
                : null);
        if (badRef != null) {
          return await _promoteNextDefaultChild(
            uId: uId,
            userModel: userModel,
            removeRef: badRef,
          );
        }
      }
      // On network errors / offline / server glitch, retain cached child and don't wipe data
      return userModel;
    } catch (e) {
      debugPrint('Failed to sync default child on login: $e');
      return userModel;
    }

    return userModel;
  }

  Future<bool> isAccountExistWithEmail({required String email}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await userCollection
              .where('email', isEqualTo: email.trim())
              .limit(1)
              .get();
      return usersSnapshot.docs.isNotEmpty;
    } on FirebaseException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResultStatus> addUserToFireStore({
    required String uId,
    required Map<String, dynamic> request,
  }) async {
    try {
      await userCollection.doc(uId).set(request);
      return ApiResultStatus.data(data: uId);
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<ApiResultStatus> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      if (credential.user != null) {
        await addUserToFireStore(
          uId: credential.user!.uid,
          request: {
            "uid": credential.user!.uid,
            "display_name": credential.user!.displayName,
            "email": credential.user!.email,
            "streak": 0,
            "last_opened": DateTime.now(),
            "is_onboarding_completed": false,
          },
        );
        final UserModel? userModel = await syncUserAndDefaultChild(
          uId: credential.user!.uid,
        );
        if (userModel != null) {
          return ApiResultStatus.data(data: userModel.toJson());
        } else {
          return ApiResultStatus.error(
            error: Exception(LocaleKeys.somethingWentWrong.tr()),
          );
        }
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<ApiResultStatus> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      if (credential.user != null) {
        final UserModel? userModel = await syncUserAndDefaultChild(
          uId: credential.user!.uid,
        );
        if (userModel != null) {
          return ApiResultStatus.data(data: userModel.toJson());
        } else {
          return ApiResultStatus.error(
            error: Exception(LocaleKeys.userNotFound.tr()),
          );
        }
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.userNotFound.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Deletes account via Cloud Function, then clears local session.
  /// Requires recent authentication (< 4.5 minutes).
  Future<ApiResultStatus> deleteAccount() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final UserModel? userModel = preferences.getUserModel();
      final String uid = currentUser?.uid ?? userModel?.uid ?? '';

      if (currentUser == null && uid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception('No active user found to delete.'),
        );
      }

      if (currentUser != null) {
        final DateTime? lastSignIn = currentUser.metadata.lastSignInTime;
        final DateTime now = DateTime.now().toUtc();
        if (lastSignIn == null ||
            now.difference(lastSignIn.toUtc()) >
                const Duration(minutes: 4, seconds: 30)) {
          return ApiResultStatus.error(
            error: Exception(
              'For security, please sign out and sign in again before deleting your account.',
            ),
          );
        }
      }

      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'deleteMyAccount',
      );
      await callable.call<dynamic>(<String, dynamic>{});

      try {
        await GoogleSignInManager.instance.signOut();
      } catch (_) {}
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}

      try {
        await OfflineSyncRepo.instance.clearQueue();
      } catch (_) {}
      await preferences.clearAll();
      await preferences.putBool(SharedPreference.isLogin, false);
      await AppSessionManager.instance.clearAllSessionStates();
      return const ApiResultStatus.data(data: '');
    } on FirebaseFunctionsException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? 'Failed to delete account.'),
      );
    } catch (e) {
      if (FirebaseAuth.instance.currentUser == null) {
        try {
          await GoogleSignInManager.instance.signOut();
        } catch (_) {}
        try {
          await OfflineSyncRepo.instance.clearQueue();
        } catch (_) {}
        await preferences.clearAll();
        await preferences.putBool(SharedPreference.isLogin, false);
        await AppSessionManager.instance.clearAllSessionStates();
        return const ApiResultStatus.data(data: '');
      }
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  // Kept for emergency client-side cleanup / tests; deleteAccount uses Cloud Function.
  // ignore: unused_element
  Future<void> _deleteAllUserData({
    required String uid,
    required String? email,
    UserModel? userModel,
  }) async {
    final DocumentReference<Map<String, dynamic>> userRef = userCollection.doc(
      uid,
    );

    // 1. Delete user subcollections
    try {
      await _deleteUserSubcollections(userRef);
    } catch (e) {
      debugPrint('Error deleting user subcollections: $e');
    }

    // 2. Discover ALL child IDs associated with this user (local + firestore + query)
    final Set<String> childIds = <String>{};
    if (userModel?.children != null) {
      for (final DocumentReference<Object?> ref in userModel!.children!) {
        if (ref.id.isNotEmpty) childIds.add(ref.id);
      }
    }
    DocumentSnapshot<Map<String, dynamic>>? userDoc;
    try {
      userDoc = await userRef.get();
      final List<dynamic>? rawChildren =
          userDoc.data()?['children'] as List<dynamic>?;
      if (rawChildren != null) {
        for (final dynamic item in rawChildren) {
          if (item is DocumentReference) {
            childIds.add(item.id);
          } else if (item is String && item.isNotEmpty) {
            childIds.add(item.split('/').last);
          }
        }
      }
    } catch (_) {}

    try {
      final QuerySnapshot<Map<String, dynamic>> parentChildren =
          await childrenCollection
              .where('parent_reference_ids', arrayContains: uid)
              .get();
      for (final DocumentSnapshot<Map<String, dynamic>> doc
          in parentChildren.docs) {
        childIds.add(doc.id);
      }
    } catch (_) {}

    // 3. Delete or unlink each child and track completely deleted ones
    final Set<String> deletedChildIds = <String>{};
    for (final String childId in childIds) {
      try {
        final bool wasDeleted = await _deleteOrUnlinkChild(childId, uid);
        if (wasDeleted) {
          deletedChildIds.add(childId);
        }
      } catch (e) {
        debugPrint('Error deleting/unlinking child $childId: $e');
      }
    }

    // 4. Unlink co-parent partner if linked
    try {
      final String? partnerUid =
          userModel?.partnerUserId ??
          userDoc?.data()?['partner_user_id'] as String?;
      if (partnerUid != null && partnerUid.isNotEmpty) {
        await userCollection.doc(partnerUid).update(<String, dynamic>{
          'partner_user_id': FieldValue.delete(),
          'is_active_logger': true,
        });
      }
    } catch (e) {
      debugPrint('Error unlinking partner: $e');
    }

    // 5. Delete co-parent invitations
    try {
      await _deleteCoParentInvitations(email: email, childIds: deletedChildIds);
    } catch (e) {
      debugPrint('Error deleting co-parent invitations: $e');
    }

    // 6. Delete shared events
    try {
      await _deleteSharedEvents(uid: uid, childIds: deletedChildIds);
    } catch (e) {
      debugPrint('Error deleting shared events: $e');
    }

    // 7. Delete mentorship requests
    try {
      final QuerySnapshot<Map<String, dynamic>> requestsSnap =
          await FirebaseFirestore.instance
              .collection('mentorship_requests')
              .where('userId', isEqualTo: uid)
              .get();
      for (final DocumentSnapshot<Map<String, dynamic>> d
          in requestsSnap.docs) {
        await d.reference.delete();
      }
    } catch (e) {
      debugPrint('Error deleting mentorship requests: $e');
    }

    // 8. Delete user document
    try {
      await userRef.delete();
    } catch (e) {
      debugPrint('Error deleting user document: $e');
    }
  }

  Future<void> _deleteUserSubcollections(
    DocumentReference<Map<String, dynamic>> userRef,
  ) async {
    final List<String> subcollections = <String>[
      'conversations',
      'saved_guidance',
      'journals',
      'mood',
      'connect_prompt_history',
    ];
    for (final String name in subcollections) {
      try {
        final QuerySnapshot<Map<String, dynamic>> snapshot = await userRef
            .collection(name)
            .get();
        for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
            in snapshot.docs) {
          if (name == 'conversations') {
            final CollectionReference<Map<String, dynamic>> chats = doc
                .reference
                .collection('chats');
            final QuerySnapshot<Map<String, dynamic>> chatSnap = await chats
                .get();
            for (final DocumentSnapshot<Map<String, dynamic>> chat
                in chatSnap.docs) {
              await chat.reference.delete();
            }
          }
          await doc.reference.delete();
        }
      } catch (_) {}
    }
  }

  Future<bool> _deleteOrUnlinkChild(String childId, String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> childSnap =
        await childrenCollection.doc(childId).get();
    if (!childSnap.exists || childSnap.data() == null) return false;

    final List<dynamic>? parentIds = childSnap.data()?['parent_reference_ids'];
    final List<String> ids =
        parentIds
            ?.map((dynamic e) => e?.toString() ?? '')
            .where((String s) => s.isNotEmpty)
            .toList() ??
        <String>[];

    final bool isCreator = ids.isEmpty || ids.first == uid;
    if (isCreator) {
      final DocumentReference<Map<String, dynamic>> childRef =
          childrenCollection.doc(childId);
      final List<String> childSubcollections = <String>[
        'sleep_logs',
        'behaviours',
        'events',
        'states',
        'tantrum_logs',
        'mood_logs',
        'health_logs',
        'quick_notes',
        'experiments',
        'caregiver_permissions',
      ];
      for (final String subName in childSubcollections) {
        try {
          final QuerySnapshot<Map<String, dynamic>> subSnap = await childRef
              .collection(subName)
              .get();
          for (final DocumentSnapshot<Map<String, dynamic>> d in subSnap.docs) {
            await d.reference.delete();
          }
        } catch (_) {}
      }

      // Also clean up Energy Bridge timer document for this child if it exists
      try {
        await FirebaseFirestore.instance
            .collection('energy_bridge')
            .doc(childId)
            .delete();
      } catch (_) {}

      await childRef.delete();
      return true;
    } else {
      await childrenCollection.doc(childId).update(<String, dynamic>{
        'parent_reference_ids': FieldValue.arrayRemove(<dynamic>[uid]),
      });
      return false;
    }
  }

  Future<void> _deleteCoParentInvitations({
    required String? email,
    required Set<String> childIds,
  }) async {
    if (email != null && email.isNotEmpty) {
      final QuerySnapshot<Map<String, dynamic>> fromSnap =
          await _coParentInvitationCollection
              .where('from_parent', isEqualTo: email)
              .get();
      for (final DocumentSnapshot<Map<String, dynamic>> d in fromSnap.docs) {
        await d.reference.delete();
      }
      final QuerySnapshot<Map<String, dynamic>> toSnap =
          await _coParentInvitationCollection
              .where('to_parent', isEqualTo: email)
              .get();
      for (final DocumentSnapshot<Map<String, dynamic>> d in toSnap.docs) {
        await d.reference.delete();
      }
    }
    for (final String cId in childIds) {
      try {
        final QuerySnapshot<Map<String, dynamic>> childInvites =
            await _coParentInvitationCollection
                .where('children', isEqualTo: cId)
                .get();
        for (final DocumentSnapshot<Map<String, dynamic>> d
            in childInvites.docs) {
          await d.reference.delete();
        }
      } catch (_) {}
    }
  }

  Future<void> _deleteSharedEvents({
    required String uid,
    required Set<String> childIds,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap =
          await _sharedEventCollection
              .where('created_by', isEqualTo: uid)
              .get();
      for (final DocumentSnapshot<Map<String, dynamic>> d in snap.docs) {
        try {
          await d.reference.delete();
        } catch (_) {}
      }
    } catch (_) {}

    try {
      final QuerySnapshot<Map<String, dynamic>> userSnap =
          await _sharedEventCollection.where('userId', isEqualTo: uid).get();
      for (final DocumentSnapshot<Map<String, dynamic>> d in userSnap.docs) {
        try {
          await d.reference.delete();
        } catch (_) {}
      }
    } catch (_) {}

    for (final String cId in childIds) {
      try {
        final QuerySnapshot<Map<String, dynamic>> childEvents =
            await _sharedEventCollection
                .where('child_id', isEqualTo: cId)
                .get();
        for (final DocumentSnapshot<Map<String, dynamic>> d
            in childEvents.docs) {
          try {
            await d.reference.delete();
          } catch (_) {}
        }
      } catch (_) {}
    }
  }

  Future<ApiResultStatus> logout() async {
    try {
      try {
        await GoogleSignInManager.instance.signOut();
      } catch (_) {}
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
      try {
        await OfflineSyncRepo.instance.clearQueue();
      } catch (_) {}
      await AppSessionManager.instance.clearAllSessionStates();
      return const ApiResultStatus.data(data: "");
    } on FirebaseException catch (e) {
      try {
        await OfflineSyncRepo.instance.clearQueue();
      } catch (_) {}
      await AppSessionManager.instance.clearAllSessionStates();
      return onFirebaseException(e);
    } catch (e) {
      try {
        await OfflineSyncRepo.instance.clearQueue();
      } catch (_) {}
      await AppSessionManager.instance.clearAllSessionStates();
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<ApiResultStatus> updateUserToFireStore({
    String? uId,
    required Map<String, dynamic> request,
  }) async {
    try {
      final String tUid = uId ?? preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        await userCollection.doc(tUid).update(request);
        return ApiResultStatus.data(data: tUid);
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<ApiResultStatus> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignInManager
          .instance
          .authenticate();
      if (googleSignInAccount == null) {
        return ApiResultStatus.error(
          error: Exception('Google Sign-In returned empty account.'),
        );
      }

      final GoogleSignInAuthentication googleAuthentication =
          googleSignInAccount.authentication;
      final String? idToken = googleAuthentication.idToken;
      if (idToken == null) {
        debugPrint(
          'Google Sign-In token error: idToken is null for email=${googleSignInAccount.email}',
        );
        return ApiResultStatus.error(
          error: Exception(
            'Google Sign-In failed: idToken is null. Check Firebase OAuth and SHA configuration.',
          ),
        );
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      final UserCredential signInUser = await FirebaseAuth.instance
          .signInWithCredential(credential);
      if (signInUser.user != null) {
        UserModel? userModel = await getUserFromUid(uId: signInUser.user!.uid);
        if (userModel == null) {
          await addUserToFireStore(
            uId: signInUser.user!.uid,
            request: {
              "uid": signInUser.user!.uid,
              "display_name": signInUser.user!.displayName,
              "email": signInUser.user!.email,
              "is_google_sign_in": true,
              "is_apple_in": false,
              "streak": 0,
              "last_opened": DateTime.now(),
              "is_onboarding_completed": false,
            },
          );
        }
        await _resolveAuthIdentity(email: signInUser.user!.email);
        userModel = await syncUserAndDefaultChild(uId: signInUser.user!.uid);
        if (userModel != null) {
          return ApiResultStatus.data(data: userModel.toJson());
        } else {
          return ApiResultStatus.error(
            error: Exception(LocaleKeys.somethingWentWrong.tr()),
          );
        }
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.userNotFound.tr()),
        );
      }
    } on FirebaseAuthException catch (e) {
      final String message =
          'FirebaseAuth Google Sign-In failed. code=${e.code}, message=${e.message ?? "no_message"}';
      debugPrint(message);
      return ApiResultStatus.error(error: Exception(message));
    } on FirebaseException catch (e) {
      final String message =
          'Firebase Google Sign-In failed. code=${e.code}, message=${e.message ?? "no_message"}';
      debugPrint(message);
      return ApiResultStatus.error(error: Exception(message));
    } catch (e) {
      debugPrint('Google Sign-In exception in AuthRepo: $e');
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<void> _resolveAuthIdentity({String? email, String? phone}) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'resolveAuthIdentity',
      );
      await callable.call<dynamic>(<String, dynamic>{
        if (email != null && email.trim().isNotEmpty)
          'email': email.trim().toLowerCase(),
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      });
    } catch (e) {
      debugPrint('resolveAuthIdentity skipped: $e');
    }
  }

  Future<ApiResultStatus> signInWithApple() async {
    try {
      UserCredential signInUser;
      String appleFullName = '';
      String appleEmail = '';

      if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
        final AppleSignInResult? result = await AppleSignInManager.instance
            .authenticateWithNonce();
        if (result == null) {
          return ApiResultStatus.error(
            error: Exception(
              'Apple Sign-In cancelled by the user (code=canceled)',
            ),
          );
        }

        final AuthorizationCredentialAppleID appleSignInAccount =
            result.credential;
        final List<String> nameParts = <String>[
          appleSignInAccount.givenName?.trim() ?? '',
          appleSignInAccount.familyName?.trim() ?? '',
        ];
        appleFullName = nameParts
            .where((String part) => part.isNotEmpty)
            .join(' ');
        appleEmail = appleSignInAccount.email ?? '';

        final OAuthCredential oauthCredential = OAuthProvider("apple.com")
            .credential(
              idToken: appleSignInAccount.identityToken,
              accessToken: appleSignInAccount.authorizationCode,
              rawNonce: result.rawNonce,
            );

        signInUser = await FirebaseAuth.instance.signInWithCredential(
          oauthCredential,
        );
      } else {
        // On Android (or Web), Firebase Auth automatically opens the Apple OAuth
        // web flow (Chrome Custom Tab / WebView) and redirects back via Firebase Auth handler.
        final AppleAuthProvider appleProvider = AppleAuthProvider()
          ..addScope('email')
          ..addScope('name');
        signInUser = await FirebaseAuth.instance.signInWithProvider(
          appleProvider,
        );
      }

      if (signInUser.user != null) {
        if (appleFullName.isNotEmpty &&
            (signInUser.user!.displayName ?? '').trim().isEmpty) {
          try {
            await signInUser.user!.updateDisplayName(appleFullName);
          } catch (_) {}
        }

        final String resolvedName = appleFullName.isNotEmpty
            ? appleFullName
            : (signInUser.user!.displayName ?? '');
        final String resolvedEmail = signInUser.user!.email ?? appleEmail;

        UserModel? userModel = await getUserFromUid(uId: signInUser.user!.uid);
        if (userModel == null) {
          await addUserToFireStore(
            uId: signInUser.user!.uid,
            request: {
              "uid": signInUser.user!.uid,
              "display_name": resolvedName,
              if (resolvedName.isNotEmpty) "parent_name": resolvedName,
              "email": resolvedEmail,
              "is_google_sign_in": false,
              "is_apple_in": true,
              "streak": 0,
              "last_opened": DateTime.now(),
              "is_onboarding_completed": false,
            },
          );
        } else {
          final Map<String, dynamic> updates = {
            "is_apple_in": true,
            "last_opened": DateTime.now(),
          };
          if ((userModel.displayName ?? '').trim().isEmpty &&
              resolvedName.isNotEmpty) {
            updates["display_name"] = resolvedName;
          }
          if ((userModel.email ?? '').trim().isEmpty &&
              resolvedEmail.isNotEmpty) {
            updates["email"] = resolvedEmail;
          }
          try {
            await userCollection.doc(signInUser.user!.uid).update(updates);
          } catch (_) {}
        }

        await _resolveAuthIdentity(
          email: resolvedEmail.isNotEmpty
              ? resolvedEmail
              : signInUser.user!.email,
        );
        userModel = await syncUserAndDefaultChild(uId: signInUser.user!.uid);
        if (userModel != null) {
          return ApiResultStatus.data(data: userModel.toJson());
        } else {
          return ApiResultStatus.error(
            error: Exception(LocaleKeys.somethingWentWrong.tr()),
          );
        }
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.userNotFound.tr()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'canceled' ||
          e.code == 'web-context-canceled' ||
          e.code == 'user-cancelled') {
        return ApiResultStatus.error(
          error: Exception(
            'Apple Sign-In cancelled by the user (code=canceled)',
          ),
        );
      }
      final String message =
          'FirebaseAuth Apple Sign-In failed. code=${e.code}, message=${e.message ?? "no_message"}';
      debugPrint(message);
      return ApiResultStatus.error(error: Exception(message));
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      debugPrint('Apple Sign-In exception in AuthRepo: $e');
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<ApiResultStatus> addConversationToUser({
    required String conversationId,
    required Map<String, dynamic> request,
  }) async {
    try {
      final String tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        await userCollection
            .doc(tUid)
            .collection("conversations")
            .doc(conversationId)
            .set(request);
        return ApiResultStatus.data(data: tUid);
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<ApiResultStatus> addChatToConversation({
    required String conversationId,
    required Map<String, dynamic> request,
  }) async {
    try {
      final String tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        final DocumentReference<Map<String, dynamic>> charReferenceId =
            await userCollection
                .doc(tUid)
                .collection("conversations")
                .doc(conversationId)
                .collection("chats")
                .add(request);
        return ApiResultStatus.data(data: charReferenceId);
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<ApiResultStatus> updateChatToConversation({
    required String conversationId,
    required String chatReferenceId,
    required Map<String, dynamic> request,
  }) async {
    try {
      final String tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        await userCollection
            .doc(tUid)
            .collection("conversations")
            .doc(conversationId)
            .collection("chats")
            .doc(chatReferenceId)
            .update(request);
        return ApiResultStatus.data(data: tUid);
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<ApiResultStatus> deleteConversation({
    required String conversationId,
  }) async {
    try {
      final String tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }

      final DocumentReference<Map<String, dynamic>> convRef = AuthRepo
          .instance
          .userCollection
          .doc(tUid)
          .collection("conversations")
          .doc(conversationId);

      final QuerySnapshot<Map<String, dynamic>> chatsSnap = await convRef
          .collection("chats")
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> chatDoc
          in chatsSnap.docs) {
        final Map<String, dynamic> data = chatDoc.data();
        final List<String> urls = <String>[];
        final String? imagePath = data['image_network_path']?.toString();
        if (imagePath != null && imagePath.isNotEmpty) {
          urls.add(imagePath);
        }
        final List<dynamic>? imagePaths =
            data['image_network_paths'] as List<dynamic>?;
        if (imagePaths != null) {
          for (final dynamic u in imagePaths) {
            final String url = u.toString();
            if (url.isNotEmpty) urls.add(url);
          }
        }
        final String? audioPath = data['audio_network_path']?.toString();
        if (audioPath != null && audioPath.isNotEmpty) {
          urls.add(audioPath);
        }
        for (final String url in urls) {
          try {
            await FirebaseStorage.instance.refFromURL(url).delete();
          } catch (_) {}
        }
        await chatDoc.reference.delete();
      }

      await convRef.delete();
      return ApiResultStatus.data(data: tUid);
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Adds a child to the current user: creates child doc, appends to [children]
  /// and sets [default_child] only when the user has none.
  Future<ApiResultStatus<UserModel>> addChild({
    required Map<String, dynamic> request,
  }) async {
    try {
      final String tUid = preferences.getUserModel()?.uid ?? '';
      if (tUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }

      final UserModel? currentUser = preferences.getUserModel();
      final Map<String, dynamic> childPayload = Map<String, dynamic>.from(
        request,
      );
      childPayload['primary_parent_uid'] = tUid;
      childPayload['parent_reference_ids'] = <String>[tUid];

      final DocumentReference<Map<String, dynamic>> documentReference =
          await childrenCollection.add(childPayload);

      final bool hasDefaultChild = currentUser?.defaultChild != null;
      final Map<String, dynamic> userUpdate = <String, dynamic>{
        'children': FieldValue.arrayUnion(<DocumentReference>[
          documentReference,
        ]),
      };
      if (!hasDefaultChild) {
        userUpdate['default_child'] = documentReference;
      }
      assert(
        FamilyMembershipHelpers.isValidAddChildUserPayload(userUpdate),
        'addChild must only write children/default_child on the user',
      );
      await userCollection.doc(tUid).update(userUpdate);

      final UserModel? updatedUser = await syncUserAndDefaultChild(uId: tUid);
      if (updatedUser == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      return ApiResultStatus.data(data: updatedUser);
    } on FirebaseException catch (e) {
      return onFirebaseException(e) as ApiResultStatus<UserModel>;
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Sets the user's default child and saves updated user to preferences.
  Future<ApiResultStatus<UserModel>> setDefaultChild(
    DocumentReference<Object?> childRef,
  ) async {
    try {
      final String tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      await userCollection.doc(tUid).update({"default_child": childRef});
      final UserModel? updatedUser = await syncUserAndDefaultChild(uId: tUid);
      if (updatedUser == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      return ApiResultStatus.data(data: updatedUser);
    } on FirebaseException catch (e) {
      return onFirebaseException(e) as ApiResultStatus<UserModel>;
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Removes a child from the current user (children array and default_child if set),
  /// then unlinks or deletes the child document. Returns updated [UserModel].
  Future<ApiResultStatus<UserModel>> removeChildFromUser({
    required String childId,
    required DocumentReference<Object?> childRef,
  }) async {
    try {
      final String tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final UserModel? currentUser = preferences.getUserModel();
      if (currentUser == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final List<DocumentReference<Object?>>? currentChildren =
          currentUser.children;
      final bool wasDefault = currentUser.defaultChild?.id == childRef.id;
      final List<DocumentReference<Object?>> newChildren =
          (currentChildren ?? []).where((ref) => ref.id != childId).toList();

      final Map<String, dynamic> userUpdate = <String, dynamic>{
        'children': FieldValue.arrayRemove([childRef]),
      };
      if (wasDefault) {
        userUpdate['default_child'] = newChildren.isNotEmpty
            ? newChildren.first
            : FieldValue.delete();
      }
      await userCollection.doc(tUid).update(userUpdate);
      await _deleteOrUnlinkChild(childId, tUid);
      final UserModel? updatedUser = await syncUserAndDefaultChild(uId: tUid);
      if (updatedUser == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      return ApiResultStatus.data(data: updatedUser);
    } on FirebaseException catch (e) {
      return onFirebaseException(e) as ApiResultStatus<UserModel>;
    } catch (e) {
      return ApiResultStatus.error(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<ApiResultStatus> getUsersFromList(List<String> users) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> response = await userCollection
          .where("uid", whereIn: users)
          .get();
      return ApiResultStatus.data(
        data: response.docs.map((e) => UserModel.fromJson(e.data())).toList(),
      );
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> getChildrenFromList(List<String> users) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> response =
          await childrenCollection
              .where(FieldPath.documentId, whereIn: users)
              .get();
      return ApiResultStatus.data(
        data: response.docs
            .map(
              (QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                  ChildModel.fromJson(e.data(), e.reference),
            )
            .toList(),
      );
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }
  // ---------------------------------------------------------------------------
  // OTP Passwordless Authentication
  // ---------------------------------------------------------------------------

  Future<ApiResultStatus> sendEmailOtp({required String email}) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'sendEmailOtp',
      );
      final HttpsCallableResult response = await callable.call(
        <String, dynamic>{'email': email.trim()},
      );
      final dynamic responseData = response.data;
      if (responseData is Map && responseData['success'] == false) {
        String msg =
            responseData['message']?.toString() ?? 'Failed to send OTP';
        if (msg.toLowerCase().contains('brevo')) {
          msg =
              'Unable to send verification code to this email. Please check the address and try again.';
        }
        return ApiResultStatus.error(error: Exception(msg));
      }
      return const ApiResultStatus.data(data: true);
    } on FirebaseFunctionsException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? 'Failed to send OTP'),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception('Something went wrong'));
    }
  }

  /// Searches for an existing user document by phone number or email.
  Future<DocumentSnapshot<Map<String, dynamic>>?> findUserByPhoneOrEmail({
    String? phoneNumber,
    String? email,
  }) async {
    try {
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        final QuerySnapshot<Map<String, dynamic>> phoneSnap =
            await userCollection
                .where('phone_number', isEqualTo: phoneNumber.trim())
                .limit(1)
                .get();
        if (phoneSnap.docs.isNotEmpty) {
          return phoneSnap.docs.first;
        }
      }
      if (email != null && email.trim().isNotEmpty) {
        final String clean = email.trim().toLowerCase();
        final QuerySnapshot<Map<String, dynamic>> emailSnap =
            await userCollection
                .where('email', isEqualTo: clean)
                .limit(1)
                .get();
        if (emailSnap.docs.isNotEmpty) {
          return emailSnap.docs.first;
        }
        final QuerySnapshot<Map<String, dynamic>> rawEmailSnap =
            await userCollection
                .where('email', isEqualTo: email.trim())
                .limit(1)
                .get();
        if (rawEmailSnap.docs.isNotEmpty) {
          return rawEmailSnap.docs.first;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error searching user by phone or email: $e');
      return null;
    }
  }

  Future<ApiResultStatus> verifyEmailOtp({
    required String email,
    required String otpCode,
    String? linkedPhone,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'verifyEmailOtp',
      );
      final HttpsCallableResult response = await callable.call(
        <String, dynamic>{'email': email.trim(), 'otp': otpCode.trim()},
      );

      final String? token = response.data['token'];
      if (token == null) {
        return ApiResultStatus.error(
          error: Exception('Failed to retrieve authentication token.'),
        );
      }

      final UserCredential credential = await FirebaseAuth.instance
          .signInWithCustomToken(token);

      if (credential.user != null) {
        final String cleanEmail = email.trim().toLowerCase();
        final String cleanPhone = linkedPhone?.trim() ?? '';

        UserModel? userModel = await getUserFromUid(uId: credential.user!.uid);

        if (userModel == null) {
          await addUserToFireStore(
            uId: credential.user!.uid,
            request: <String, dynamic>{
              'uid': credential.user!.uid,
              'display_name': credential.user!.displayName ?? 'Parent',
              'email': cleanEmail,
              'phone_number': cleanPhone,
              'is_google_sign_in': false,
              'is_apple_in': false,
              'streak': 0,
              'last_opened': DateTime.now(),
              'is_onboarding_completed': false,
            },
          );
        } else {
          final Map<String, dynamic> updates = <String, dynamic>{
            'email': cleanEmail,
          };
          if (cleanPhone.isNotEmpty &&
              (userModel.phoneNumber == null ||
                  userModel.phoneNumber!.isEmpty)) {
            updates['phone_number'] = cleanPhone;
          }
          await userCollection
              .doc(credential.user!.uid)
              .set(updates, SetOptions(merge: true));
        }

        await _resolveAuthIdentity(
          email: cleanEmail,
          phone: cleanPhone.isNotEmpty ? cleanPhone : null,
        );
        userModel = await syncUserAndDefaultChild(uId: credential.user!.uid);
        if (userModel == null) {
          return ApiResultStatus.error(
            error: Exception('Failed to create user account.'),
          );
        }

        return ApiResultStatus.data(data: userModel.toJson());
      } else {
        return ApiResultStatus.error(error: Exception('User not found'));
      }
    } on FirebaseFunctionsException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? 'Invalid OTP'),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception('Something went wrong'));
    }
  }

  // ---------------------------------------------------------------------------
  // Phone Number SMS OTP Authentication
  // ---------------------------------------------------------------------------

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(Exception error) onError,
    required void Function(UserModel userModel) onAutoVerified,
    int? forceResendingToken,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber.trim(),
        timeout: const Duration(seconds: 60),
        forceResendingToken: forceResendingToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final UserCredential userCred = await FirebaseAuth.instance
                .signInWithCredential(credential);
            if (userCred.user != null) {
              final UserModel? userModel = await _syncPhoneAuthUser(
                user: userCred.user!,
                phoneNumber: phoneNumber,
              );
              if (userModel != null) {
                onAutoVerified(userModel);
              }
            }
          } catch (e) {
            onError(Exception(e.toString()));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          String message = e.message ?? 'Phone verification failed';
          if (e.code == 'invalid-phone-number') {
            message =
                'Invalid phone number format. Please include country code (e.g. +1...)';
          } else if (e.code == 'too-many-requests') {
            message = 'Too many requests. Please try again later.';
          } else if (e.code == 'quota-exceeded') {
            message = 'SMS quota exceeded. Please try again later.';
          }
          onError(Exception(message));
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseException catch (e) {
      if (e.code == 'no-app' ||
          e.toString().contains('no-app') ||
          e.toString().contains('No Firebase App')) {
        onCodeSent('mock_phone_verification_id', 123456);
        return;
      }
      onError(Exception(e.message ?? 'Failed to send verification SMS'));
    } catch (e) {
      if (e.toString().contains('no-app') ||
          e.toString().contains('No Firebase App')) {
        onCodeSent('mock_phone_verification_id', 123456);
        return;
      }
      onError(Exception(e.toString()));
    }
  }

  Future<ApiResultStatus> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
    required String phoneNumber,
    String? linkedEmail,
  }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.trim(),
        smsCode: smsCode.trim(),
      );

      final UserCredential userCred = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCred.user != null) {
        final UserModel? userModel = await _syncPhoneAuthUser(
          user: userCred.user!,
          phoneNumber: phoneNumber,
          linkedEmail: linkedEmail,
        );
        if (userModel == null) {
          return ApiResultStatus.error(
            error: Exception('Failed to sync user account.'),
          );
        }
        return ApiResultStatus.data(data: userModel.toJson());
      } else {
        return ApiResultStatus.error(error: Exception('User not found'));
      }
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'Invalid verification code';
      if (e.code == 'invalid-verification-code') {
        message = 'The SMS verification code is incorrect.';
      } else if (e.code == 'session-expired') {
        message =
            'The verification code has expired. Please request a new code.';
      }
      return ApiResultStatus.error(error: Exception(message));
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<UserModel?> _syncPhoneAuthUser({
    required User user,
    required String phoneNumber,
    String? linkedEmail,
  }) async {
    final String cleanPhone = phoneNumber.trim();
    final String cleanEmail = linkedEmail?.trim().toLowerCase() ?? '';

    UserModel? userModel = await getUserFromUid(uId: user.uid);
    if (userModel == null) {
      await addUserToFireStore(
        uId: user.uid,
        request: <String, dynamic>{
          'uid': user.uid,
          'display_name': user.displayName ?? 'Parent',
          'email': cleanEmail,
          'phone_number': cleanPhone,
          'is_google_sign_in': false,
          'is_apple_in': false,
          'streak': 0,
          'last_opened': DateTime.now(),
          'is_onboarding_completed': false,
        },
      );
    } else {
      final Map<String, dynamic> updates = <String, dynamic>{
        'phone_number': cleanPhone,
      };
      if (cleanEmail.isNotEmpty &&
          (userModel.email == null || userModel.email!.isEmpty)) {
        updates['email'] = cleanEmail;
      }
      await userCollection.doc(user.uid).set(updates, SetOptions(merge: true));
    }
    await _resolveAuthIdentity(
      email: cleanEmail.isNotEmpty ? cleanEmail : null,
      phone: cleanPhone,
    );
    userModel = await syncUserAndDefaultChild(uId: user.uid);
    if (userModel != null) {
      await preferences.saveUserModel(userModel);
      await preferences.putBool(SharedPreference.isLogin, true);
    }
    return userModel;
  }
}
