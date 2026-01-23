import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/prompt_model.dart';
import 'package:loving_brain/other/preferances.dart';

class PromptsRepo {
  PromptsRepo._();

  static final PromptsRepo _instance = PromptsRepo._();

  factory PromptsRepo() {
    return _instance;
  }

  static PromptsRepo get instance => _instance;

  final CollectionReference _promptsCollection = FirebaseFirestore.instance
      .collection('learn_and_play_prompts');
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection('users');

  Future<ApiResultStatus<List<PromptModel>>> getAllPrompts() async {
    try {
      final snap = await _promptsCollection.get();
      final list = snap.docs
          .map(
            (d) => PromptModel.fromMap(d.data() as Map<String, dynamic>, d.id),
          )
          .toList();
      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception("Failed to fetch prompts: $e"),
      );
    }
  }

  Future<List<String>> getRecentPromptIds(int days) async {
    try {
      final tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isEmpty) return [];

      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      final snap = await _userCollection
          .doc(tUid)
          .collection('connect_prompt_history')
          .where('last_seen', isGreaterThan: Timestamp.fromDate(cutoffDate))
          .get();

      return snap.docs.map((d) => d.id).toList();
    } catch (e) {
      return [];
    }
  }

  Future<String?> getLastSeenPromptIdSinceToday() async {
    try {
      final tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isEmpty) return null;

      final now = DateTime.now();
      // Start of "today" at 00:00:00
      final todayStart = DateTime(now.year, now.month, now.day);

      final snap = await _userCollection
          .doc(tUid)
          .collection('connect_prompt_history')
          .where(
            'last_seen',
            isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart),
          )
          .orderBy('last_seen', descending: true)
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        return snap.docs.first.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> markPromptAsSeen(String promptId) async {
    try {
      final tUid = preferences.getUserModel()?.uid ?? "";
      if (tUid.isEmpty) return;

      await _userCollection
          .doc(tUid)
          .collection('connect_prompt_history')
          .doc(promptId)
          .set({'last_seen': FieldValue.serverTimestamp()});
    } catch (e) {
      // Ignore error for non-critical logging
    }
  }
}
