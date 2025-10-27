import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/user_model.dart';

class UserRepo {
  UserRepo._();

  static final UserRepo _instance = UserRepo._();
  var userCollection = FirebaseFirestore.instance.collection('users');

  factory UserRepo() {
    return _instance;
  }

  static UserRepo get instance => _instance;
  Future<UserModel?> getUserFromEmail({required String email}) async {
    try {
      final querySnapshot = await userCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        return UserModel.fromJson(userData);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      return null;
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }
}
