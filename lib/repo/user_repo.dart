import 'dart:io';
import 'dart:io' as io;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';
import '../other/extra_methods.dart';

class UserRepo {
  UserRepo._();

  static final UserRepo _instance = UserRepo._();
  CollectionReference<Map<String, dynamic>> get userCollection =>
      FirebaseFirestore.instance.collection('users');
  CollectionReference<Map<String, dynamic>> get dailyParentingTipsCollection =>
      FirebaseFirestore.instance.collection('dailyParentingTips');

  factory UserRepo() {
    return _instance;
  }

  static UserRepo get instance => _instance;

  Future<UserModel?> getUserFromEmail({required String email}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await userCollection.where('email', isEqualTo: email).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final Map<String, dynamic> userData = querySnapshot.docs.first.data();
        return UserModel.fromJson(userData);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Error getting user by email: $e');
      return null;
    }
  }

  Future<UserModel?> getUserById({required String uid}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await userCollection
          .doc(uid)
          .get();
      final Map<String, dynamic>? data = doc.data();
      if (doc.exists && data != null) {
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user by id: $e');
      return null;
    }
  }

  Future<void> updateUserStreak() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    // Get user from local preferences
    final UserModel? localUser = preferences.getUserModel();
    if (localUser == null) {
      debugPrint("⚠️ No local user found");
      return;
    }

    DateTime? lastUpdate = localUser.lastStreakUpdate;
    int currentStreak = localUser.streak ?? 0;
    int newStreak = 1;

    if (lastUpdate != null) {
      final DateTime last = DateTime(
        lastUpdate.year,
        lastUpdate.month,
        lastUpdate.day,
      );
      final int diff = today.difference(last).inDays;

      if (diff == 0) {
        debugPrint("Streak already updated today (local)");
        return;
      } else if (diff == 1) {
        newStreak = currentStreak + 1;
      } else {
        newStreak = 1; // missed a day
      }
    }

    // ✅ Update locally first
    final UserModel updatedUser = localUser.copyWith(
      streak: newStreak,
      lastStreakUpdate: today,
    );
    await preferences.saveUserModel(updatedUser);

    debugPrint("🟢 Streak updated locally: $newStreak days");

    // ✅ Then upsert to Firestore (safe for new documents too)
    try {
      await userCollection.doc(localUser.uid).set({
        'streak': newStreak,
        'last_streak_update': today,
      }, SetOptions(merge: true));
      debugPrint("☁️ Synced streak with Firestore successfully");
    } catch (e) {
      debugPrint("⚠️ Failed to sync streak to Firestore: $e");
    }
  }

  Future<void> updateNotification() async {
    // Get user from local preferences
    final UserModel? localUser = preferences.getUserModel();
    if (localUser == null) {
      debugPrint("⚠️ No local user found");
      return;
    }

    // ✅ Toggle & save locally first
    final UserModel updatedUser = localUser.copyWith(
      isNotification: !(localUser.isNotification ?? false),
    );
    await preferences.saveUserModel(updatedUser);

    // ✅ Upsert to Firestore (set with merge = create if not exists, update if exists)
    try {
      await userCollection.doc(localUser.uid).set({
        'is_notification': updatedUser.isNotification,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("⚠️ Failed to update to Firestore: $e");
    }
  }

  Future<String> getTipOfTheDay() async {
    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // Step 1: check if today's tip already exists
    final QuerySnapshot<Map<String, dynamic>> todayQuery =
        await dailyParentingTipsCollection
            .where('is_tip_of_the_day', isEqualTo: true)
            .get();

    if (todayQuery.docs.isNotEmpty) {
      final QueryDocumentSnapshot<Map<String, dynamic>> doc =
          todayQuery.docs.first;
      final DateTime tipDate = (doc['tip_date'] as Timestamp).toDate();

      final bool isSameDay =
          tipDate.year == today.year &&
          tipDate.month == today.month &&
          tipDate.day == today.day;

      if (isSameDay) {
        return doc['tip'] as String? ?? '';
      }
    }

    // Step 2: expired → clear old flag
    final QuerySnapshot<Map<String, dynamic>> allDocs =
        await dailyParentingTipsCollection.get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in allDocs.docs) {
      if ((doc.data()['is_tip_of_the_day'] ?? false) == true) {
        await doc.reference.update({'is_tip_of_the_day': false});
      }
    }

    if (allDocs.docs.isEmpty) return '';

    // Step 3: choose a new random tip
    final QueryDocumentSnapshot<Map<String, dynamic>> randomDoc =
        allDocs.docs[Random().nextInt(allDocs.docs.length)];

    await randomDoc.reference.update({
      'is_tip_of_the_day': true,
      'tip_date': Timestamp.fromDate(today),
    });

    return randomDoc['tip'] as String? ?? '';
  }

  Future<ApiResultStatus> uploadFileToFirebaseStorage({
    required File file,
    required String? referenceId,
  }) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile-images')
          .child(referenceId ?? "TEST")
          .child('/${file.path.split("/").last}');
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/${file.path.split(".").last}',
        customMetadata: {'picked-file-path': file.path},
      );
      final UploadTask uploadTask = ref.putFile(io.File(file.path), metadata);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return ApiResultStatus.data(data: downloadUrl);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Raw `notification_preferences` map from the user document, if present.
  Future<Map<String, dynamic>?> getNotificationPreferencesMap({
    required String uid,
  }) async {
    try {
      if (uid.isEmpty) {
        return null;
      }
      final DocumentSnapshot<Map<String, dynamic>> doc = await userCollection
          .doc(uid)
          .get();
      final Map<String, dynamic>? data = doc.data();
      if (!doc.exists || data == null) {
        return null;
      }
      final Object? raw = data['notification_preferences'];
      if (raw is Map<String, dynamic>) {
        return raw;
      }
      if (raw is Map) {
        return Map<String, dynamic>.from(raw);
      }
      return null;
    } catch (e) {
      debugPrint('Error reading notification_preferences: $e');
      return null;
    }
  }

  /// Publishes the phone's UTC offset so server quiet hours match this device.
  Future<void> syncDeviceNotificationClock() async {
    try {
      final String uid = preferences.getUserModel()?.uid ?? '';
      final bool loggedIn =
          preferences.getBool(SharedPreference.isLogin) ?? false;
      if (!loggedIn || uid.isEmpty) {
        return;
      }
      final int offsetMinutes = DateTime.now().timeZoneOffset.inMinutes;
      await userCollection.doc(uid).set(<String, dynamic>{
        'notification_utc_offset_minutes': offsetMinutes,
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  /// Shares one daily send count with Cloud Functions.
  /// Returns false only when the shared cap is already full.
  /// A network failure returns true so a local reminder can still be set.
  Future<bool> recordNotificationSent(DateTime when) async {
    try {
      final String uid = preferences.getUserModel()?.uid ?? '';
      if (uid.isEmpty) {
        return true;
      }
      final String dayKey =
          '${when.year.toString().padLeft(4, '0')}-'
          '${when.month.toString().padLeft(2, '0')}-'
          '${when.day.toString().padLeft(2, '0')}';
      final DocumentReference<Map<String, dynamic>> ref = userCollection.doc(
        uid,
      );
      return await FirebaseFirestore.instance.runTransaction<bool>((
        Transaction transaction,
      ) async {
        final DocumentSnapshot<Map<String, dynamic>> snap = await transaction
            .get(ref);
        final Map<String, dynamic> data = snap.data() ?? <String, dynamic>{};
        final String storedDay =
            data['notification_sent_day']?.toString() ?? '';
        final int storedCount = storedDay == dayKey
            ? (data['notification_sent_count'] as num?)?.toInt() ?? 0
            : 0;
        final Object? rawPrefs = data['notification_preferences'];
        final Map<String, dynamic> prefs = rawPrefs is Map
            ? Map<String, dynamic>.from(rawPrefs)
            : <String, dynamic>{};
        final int capRaw = (prefs['maxDailyCap'] as num?)?.toInt() ?? 3;
        final int cap = capRaw > 0 ? capRaw : 3;
        if (storedCount >= cap) {
          return false;
        }
        transaction.set(ref, <String, dynamic>{
          'notification_sent_day': dayKey,
          'notification_sent_count': storedCount + 1,
          'notification_utc_offset_minutes':
              DateTime.now().timeZoneOffset.inMinutes,
        }, SetOptions(merge: true));
        return true;
      });
    } catch (_) {
      return true;
    }
  }

  Future<ApiResultStatus> updateUserToFireStore({
    String? uId,
    required Map<String, dynamic> request,
  }) async {
    try {
      final String tUid = uId ?? preferences.getUserModel()?.uid ?? "";
      if (tUid.isNotEmpty) {
        // Use set with merge:true so it works even if the document doesn't exist yet
        await userCollection.doc(tUid).set(request, SetOptions(merge: true));
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
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Swaps active logger between co-parents without resetting Energy Bridge.
  Future<ApiResultStatus> transferActiveLogger({
    required String currentUid,
    required String partnerUid,
  }) async {
    try {
      if (currentUid.isEmpty || partnerUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.update(userCollection.doc(currentUid), <String, dynamic>{
        'is_active_logger': false,
        'partner_user_id': partnerUid,
      });
      batch.update(userCollection.doc(partnerUid), <String, dynamic>{
        'is_active_logger': true,
        'partner_user_id': currentUid,
      });
      await batch.commit();
      return ApiResultStatus.data(data: partnerUid);
    } on FirebaseException catch (e) {
      return onFirebaseException(e);
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }
}
