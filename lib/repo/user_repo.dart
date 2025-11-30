import 'dart:io';
import 'dart:io' as io;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

import '../model/api_result_status.dart';

class UserRepo {
  UserRepo._();

  static final UserRepo _instance = UserRepo._();
  var userCollection = FirebaseFirestore.instance.collection('users');
  var dailyParentingTipsCollection = FirebaseFirestore.instance.collection(
    'dailyParentingTips',
  );

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
      await userCollection.doc(localUser.uid).update({
        'streak': newStreak,
        'last_streak_update': today,
      });
      print("☁️ Synced streak with Firestore successfully");
    } catch (e) {
      print("⚠️ Failed to sync streak to Firestore: $e");
    }
  }

  Future<void> updateGentleReminder() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get user from local preferences
    final localUser = preferences.getUserModel();
    if (localUser == null) {
      print("⚠️ No local user found");
      return;
    }

    // ✅ Update locally first
    final updatedUser = localUser.copyWith(
      getReminderNotification: !(localUser.getReminderNotification ?? false),
    );
    await preferences.saveUserModel(updatedUser);

    // ✅ Then update Firestore in background
    try {
      await userCollection.doc(localUser.uid).update({
        'get_reminder_notification': updatedUser.getReminderNotification,
      });
    } catch (e) {
      print("⚠️ Failed to update to Firestore: $e");
    }
  }

  Future<void> updateScheduleReminder() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get user from local preferences
    final localUser = preferences.getUserModel();
    if (localUser == null) {
      print("⚠️ No local user found");
      return;
    }

    // ✅ Update locally first
    final updatedUser = localUser.copyWith(
      scheduleReminder: !(localUser.scheduleReminder ?? false),
    );
    await preferences.saveUserModel(updatedUser);

    // ✅ Then update Firestore in background
    try {
      await userCollection.doc(localUser.uid).update({
        'schedule_reminder': updatedUser.scheduleReminder,
      });
    } catch (e) {
      print("⚠️ Failed to update to Firestore: $e");
    }
  }

  Future<void> updateDailyEmotion() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get user from local preferences
    final localUser = preferences.getUserModel();
    if (localUser == null) {
      print("⚠️ No local user found");
      return;
    }

    // ✅ Update locally first
    final updatedUser = localUser.copyWith(
      dailyEmotionCheck: !(localUser.dailyEmotionCheck ?? false),
    );
    await preferences.saveUserModel(updatedUser);

    // ✅ Then update Firestore in background
    try {
      await userCollection.doc(localUser.uid).update({
        'daily_emotion_check': updatedUser.dailyEmotionCheck,
      });
    } catch (e) {
      print("⚠️ Failed to update to Firestore: $e");
    }
  }

  Future<void> updateTodaysPlayIdea() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get user from local preferences
    final localUser = preferences.getUserModel();
    if (localUser == null) {
      print("⚠️ No local user found");
      return;
    }

    // ✅ Update locally first
    final updatedUser = localUser.copyWith(
      todaysPlayIdea: !(localUser.todaysPlayIdea ?? false),
    );
    await preferences.saveUserModel(updatedUser);

    // ✅ Then update Firestore in background
    try {
      await userCollection.doc(localUser.uid).update({
        'todays_play_idea': updatedUser.todaysPlayIdea,
      });
    } catch (e) {
      print("⚠️ Failed to update to Firestore: $e");
    }
  }

  Future<String> getTipOfTheDay() async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // Step 1: check if today's tip already exists
    final todayQuery = await dailyParentingTipsCollection
        .where('is_tip_of_the_day', isEqualTo: true)
        .get();

    if (todayQuery.docs.isNotEmpty) {
      final doc = todayQuery.docs.first;
      final tipDate = (doc['tip_date'] as Timestamp).toDate();

      final isSameDay =
          tipDate.year == today.year &&
          tipDate.month == today.month &&
          tipDate.day == today.day;

      if (isSameDay) {
        return doc['tip'];
      }
    }

    // Step 2: expired → clear old flag
    final allDocs = await dailyParentingTipsCollection.get();

    for (final doc in allDocs.docs) {
      if ((doc.data()['is_tip_of_the_day'] ?? false) == true) {
        await doc.reference.update({'is_tip_of_the_day': false});
      }
    }

    // Step 3: choose a new random tip
    final randomDoc = allDocs.docs[Random().nextInt(allDocs.docs.length)];

    await randomDoc.reference.update({
      'is_tip_of_the_day': true,
      'tip_date': Timestamp.fromDate(today),
    });

    return randomDoc['tip'];
  }


  Future<ApiResultStatus> uploadFileToFirebaseStorage({
    required File file,
    required String? referenceId,
  }) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile-images')
          .child(referenceId ?? "TEST")
          .child('/${file.path.split("/").last}');
      final metadata = SettableMetadata(
        contentType: 'image/${file.path.split(".").last}',
        customMetadata: {'picked-file-path': file.path},
      );
      var uploadTask = ref.putFile(io.File(file.path), metadata);
      return ApiResultStatus.data(data: await Future.value(uploadTask));
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }
}
