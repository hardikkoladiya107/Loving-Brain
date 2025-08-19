import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../generated/locale_keys.g.dart';
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

  Future<bool> isAccountExistWithEmail({required String email}) async {
    try {
      var allUsers = await userCollection.get();
      if (allUsers.docs.any((element) {
        var userModel = UserModel.fromJson(element.data(), element.id);
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
      return ApiResultStatus.data(data: true);
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }

  Future<ApiResultStatus> updateUserToFireStore({
    required String uId,
    required Map<String, dynamic> request,
  }) async {
    try {
      userCollection.doc(uId).update(request);
      return ApiResultStatus.data(data: true);
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
        return addUserToFireStore(
          uId: credential.user!.uid,
          request: {
            "display_name": credential.user!.displayName,
            "email": credential.user!.email,
          },
        );
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
      return ApiResultStatus.data(data: "");
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }
}
