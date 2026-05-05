import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/preferances.dart';

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

  CollectionReference<Map<String, dynamic>> userCollection = FirebaseFirestore
      .instance
      .collection('users');
  CollectionReference<Map<String, dynamic>> childrenCollection =
      FirebaseFirestore.instance.collection('children');
  final _sharedEventCollection = FirebaseFirestore.instance.collection(
    'shared_event',
  );
  final _coParentInvitationCollection = FirebaseFirestore.instance.collection(
    'co-parent-invitation',
  );

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
      var user = await userCollection.doc(uId).get();
      if (user.data() != null) {
        var data = user.data()!;
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
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
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
          },
        );
        var userModel = await getUserFromUid(uId: credential.user!.uid);
        if (userModel != null) {
          await preferences.saveUserModel(userModel);
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
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (credential.user != null) {
        var userModel = await getUserFromUid(uId: credential.user!.uid);
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
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return ApiResultStatus.data(data: "");
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  /// Deletes all Firestore data for the user, then deletes the Auth account.
  /// Call while user is still signed in so Firestore rules allow deletion.
  Future<ApiResultStatus> deleteAccount() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final String uid = currentUser.uid;
      final UserModel? userModel = preferences.getUserModel();
      final String? email = userModel?.email ?? currentUser.email;

      await _deleteAllUserData(uid: uid, email: email, userModel: userModel);

      await currentUser.delete();
      await preferences.clearUser();
      return ApiResultStatus.data(data: "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSignInAgainToDeleteAccount.tr()),
        );
      }
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<void> _deleteAllUserData({
    required String uid,
    required String? email,
    UserModel? userModel,
  }) async {
    final DocumentReference<Map<String, dynamic>> userRef = userCollection.doc(
      uid,
    );

    await _deleteUserSubcollections(userRef);
    await userRef.delete();

    final List<DocumentReference<Object?>>? childRefs = userModel?.children;
    if (childRefs != null && childRefs.isNotEmpty) {
      for (final DocumentReference<Object?> ref in childRefs) {
        await _deleteOrUnlinkChild(ref.id, uid);
      }
    }

    if (email != null && email.isNotEmpty) {
      await _deleteCoParentInvitations(email);
    }
    await _deleteSharedEventsByCreator(uid);
  }

  Future<void> _deleteUserSubcollections(
    DocumentReference<Map<String, dynamic>> userRef,
  ) async {
    final List<String> subcollections = [
      'conversations',
      'journals',
      'mood',
      'connect_prompt_history',
    ];
    for (final String name in subcollections) {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await userRef
          .collection(name)
          .get();
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        if (name == 'conversations') {
          final CollectionReference<Map<String, dynamic>> chats = doc.reference
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
    }
  }

  Future<void> _deleteOrUnlinkChild(String childId, String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> childSnap =
        await childrenCollection.doc(childId).get();
    if (!childSnap.exists || childSnap.data() == null) return;

    final List<dynamic>? parentIds = childSnap.data()?['parent_reference_ids'];
    final List<String> ids =
        parentIds
            ?.map((e) => e?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];

    if (ids.isEmpty || ids.length == 1 && ids.first == uid) {
      final DocumentReference<Map<String, dynamic>> childRef =
          childrenCollection.doc(childId);
      final CollectionReference<Map<String, dynamic>> sleepLogs = childRef
          .collection('sleep_logs');
      final QuerySnapshot<Map<String, dynamic>> sleepSnap = await sleepLogs
          .get();
      for (final DocumentSnapshot<Map<String, dynamic>> d in sleepSnap.docs) {
        await d.reference.delete();
      }
      final CollectionReference<Map<String, dynamic>> behaviours = childRef
          .collection('behaviours');
      final QuerySnapshot<Map<String, dynamic>> behSnap = await behaviours
          .get();
      for (final DocumentSnapshot<Map<String, dynamic>> d in behSnap.docs) {
        await d.reference.delete();
      }
      await childRef.delete();
    } else {
      await childrenCollection.doc(childId).update({
        'parent_reference_ids': FieldValue.arrayRemove([uid]),
      });
    }
  }

  Future<void> _deleteCoParentInvitations(String email) async {
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

  Future<void> _deleteSharedEventsByCreator(String uid) async {
    final QuerySnapshot<Map<String, dynamic>> snap =
        await _sharedEventCollection.where('created_by', isEqualTo: uid).get();
    for (final DocumentSnapshot<Map<String, dynamic>> d in snap.docs) {
      await d.reference.delete();
    }
  }

  Future<ApiResultStatus> logout() async {
    try {
      // await FirebaseAuth.instance.signInAnonymously();
      await FirebaseAuth.instance.signOut();
      return ApiResultStatus.data(data: "");
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> updateUserToFireStore({
    String? uId,
    required Map<String, dynamic> request,
  }) async {
    try {
      var tUid = uId ?? preferences.getUserModel()?.uid ?? "";
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
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> signInWithGoogle() async {
    try {
      final googleSignInAccount = await GoogleSignInManager.instance
          .authenticate();
      if (googleSignInAccount == null) {
        return ApiResultStatus.error(
          error: Exception('Google Sign-In returned empty account.'),
        );
      }

      final googleAuthentication = googleSignInAccount.authentication;
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

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      final signInUser = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      if (signInUser.user != null) {
        var userModel = await getUserFromUid(uId: signInUser.user!.uid);
        if (userModel != null) {
          return ApiResultStatus.data(data: userModel.toJson());
        } else {
          if (signInUser.user != null) {
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
              },
            );
            var userModel = await getUserFromUid(uId: signInUser.user!.uid);
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
    } on Exception catch (e) {
      debugPrint('Google Sign-In exception in AuthRepo: $e');
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> signInWithApple() async {
    try {
      var appleSignInAccount = await AppleSignInManager.instance.authenticate();
      if (appleSignInAccount == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleSignInAccount.identityToken,
        accessToken: appleSignInAccount.authorizationCode,
      );

      final signInUser = await FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );
      if (signInUser.user != null) {
        var userModel = await getUserFromUid(uId: signInUser.user!.uid);
        if (userModel != null) {
          return ApiResultStatus.data(data: userModel.toJson());
        } else {
          if (signInUser.user != null) {
            await addUserToFireStore(
              uId: signInUser.user!.uid,
              request: {
                "uid": signInUser.user!.uid,
                "display_name": signInUser.user!.displayName,
                "email": signInUser.user!.email,
                "is_google_sign_in": false,
                "is_apple_in": true,
                "streak": 0,
                "last_opened": DateTime.now(),
              },
            );
            var userModel = await getUserFromUid(uId: signInUser.user!.uid);
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
        }
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.userNotFound.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> addConversationToUser({
    required String conversationId,
    required Map<String, dynamic> request,
  }) async {
    try {
      var tUid = preferences.getUserModel()?.uid ?? "";
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
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> addChatToConversation({
    required String conversationId,
    required Map<String, dynamic> request,
  }) async {
    try {
      var tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        var charReferenceId = await userCollection
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
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> updateChatToConversation({
    required String conversationId,
    required String chatReferenceId,
    required Map<String, dynamic> request,
  }) async {
    try {
      var tUid = preferences.getUserModel()?.uid ?? "";
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
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> deleteConversation({
    required String conversationId,
  }) async {
    try {
      var tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        await AuthRepo.instance.userCollection
            .doc(tUid)
            .collection("conversations")
            .doc(conversationId)
            .delete();
        return ApiResultStatus.data(data: tUid);
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  /// Adds a child to the current user: creates child doc, appends to [children]
  /// and sets [default_child] to the new child. Returns updated [UserModel].
  Future<ApiResultStatus<UserModel>> addChild({
    required Map<String, String> request,
  }) async {
    try {
      final String tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }

      final DocumentReference<Map<String, dynamic>> documentReference =
          await childrenCollection.add(request);

      await documentReference.update({
        'parent_reference_ids': FieldValue.arrayUnion([tUid]),
      });

      final Map<String, dynamic> userUpdate = {
        "default_child": documentReference,
        ...request,
      };
      final UserModel? currentUser = preferences.getUserModel();
      if (currentUser?.children != null && currentUser!.children!.isNotEmpty) {
        userUpdate["children"] = FieldValue.arrayUnion([documentReference]);
      } else {
        userUpdate["children"] = [documentReference];
      }
      await userCollection.doc(tUid).update(userUpdate);

      final UserModel? updatedUser = await getUserFromUid(uId: tUid);
      if (updatedUser == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      return ApiResultStatus.data(data: updatedUser);
    } on FirebaseException catch (e) {
      return onFirebaseException(e) as ApiResultStatus<UserModel>;
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
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
      final UserModel? updatedUser = await getUserFromUid(uId: tUid);
      if (updatedUser == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      await preferences.saveUserModel(updatedUser);
      return ApiResultStatus.data(data: updatedUser);
    } on FirebaseException catch (e) {
      return onFirebaseException(e) as ApiResultStatus<UserModel>;
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
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
      final UserModel? updatedUser = await getUserFromUid(uId: tUid);
      if (updatedUser == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      await preferences.saveUserModel(updatedUser);
      return ApiResultStatus.data(data: updatedUser);
    } on FirebaseException catch (e) {
      return onFirebaseException(e) as ApiResultStatus<UserModel>;
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> getUsersFromList(List<String> users) async {
    try {
      var response = await userCollection.where("uid", whereIn: users).get();
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
      final response = await childrenCollection
          .where(FieldPath.documentId, whereIn: users)
          .get();
      return ApiResultStatus.data(
        data: response.docs
            .map((e) => ChildModel.fromJson(e.data(), e.reference))
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
}
