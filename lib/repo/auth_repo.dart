import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loving_brain/model/api_result_status.dart';
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

  var userCollection = FirebaseFirestore.instance.collection('users');
  var childrenCollection = FirebaseFirestore.instance.collection('children');

  Future<bool> currentUserExist({required String uId}) async {
    try {
      var allUsers = await userCollection.get();
      if (allUsers.docs.any((element) => element.id == uId)) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getUserFromUid({required String uId}) async {
    try {
      var user = await userCollection.doc(uId).get();
      if (user.data() != null) {
        return UserModel.fromJson(user.data()!);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isAccountExistWithEmail({required String email}) async {
    try {
      var allUsers = await userCollection.get();
      if (allUsers.docs.any((element) {
        var userModel = UserModel.fromJson(element.data());
        return email == userModel.email;
      })) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
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
      userCollection.doc(uId).set(request);
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
      final credential = await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );
      return ApiResultStatus.data(data: "");
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> deleteAccount() async {
    try {
      //await FirebaseAuth.instance.signInAnonymously();
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser?.delete();
        return ApiResultStatus.data(data: "");
      } else {
        return ApiResultStatus.error(error: Exception("Exception"));
      }
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future logout() async {
    try {
      // await FirebaseAuth.instance.signInAnonymously();
      final credential = await FirebaseAuth.instance.signOut();
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
      var googleSignInAccount = await GoogleSignInManager.instance
          .authenticate();
      if (googleSignInAccount == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleSignInAccount.authentication.idToken,
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
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
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
        await userCollection
            .doc(tUid)
            .collection("conversations")
            .doc(conversationId)
            .collection("chats")
            .add(request);
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

  Future<ApiResultStatus> addChild({
    required Map<String, String> request,
  }) async {
    try {
      var documentReference = await childrenCollection.add(request);
      var tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        await userCollection.doc(tUid).update({
          "default_child": documentReference,
          "children": [documentReference],
          ...request,
        });
        return ApiResultStatus.data(data: await getUserFromUid(uId: tUid));
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
}
