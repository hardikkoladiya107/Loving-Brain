import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

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

  Future<void> updateUserStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get user from local preferences
    final localUser = preferences.getUserModel();
    if (localUser == null) {
      print("⚠️ No local user found");
      return;
    }

    DateTime? lastUpdate = localUser.lastStreakUpdate;
    int currentStreak = localUser.streak ?? 0;
    int newStreak = 1;

    if (lastUpdate != null) {
      final last = DateTime(lastUpdate.year, lastUpdate.month, lastUpdate.day);
      final diff = today.difference(last).inDays;

      if (diff == 0) {
        print("Streak already updated today (local)");
        return;
      } else if (diff == 1) {
        newStreak = currentStreak + 1;
      } else {
        newStreak = 1; // missed a day
      }
    }

    // ✅ Update locally first
    final updatedUser = localUser.copyWith(
      streak: newStreak,
      lastStreakUpdate: today,
    );
    await preferences.saveUserModel(updatedUser);

    print("🟢 Streak updated locally: $newStreak days");

    // ✅ Then update Firestore in background
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(localUser.uid)
          .update({'streak': newStreak, 'last_streak_update': today});
      print("☁️ Synced streak with Firestore successfully");
    } catch (e) {
      print("⚠️ Failed to sync streak to Firestore: $e");
    }
  }
}
