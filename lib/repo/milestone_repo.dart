import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/milestone_model.dart';
import 'package:loving_brain/repo/child_repo.dart';

class MilestoneRepo {
  MilestoneRepo._();
  static final MilestoneRepo _instance = MilestoneRepo._();
  factory MilestoneRepo() => _instance;
  static MilestoneRepo get instance => _instance;

  final CollectionReference<Map<String, dynamic>> _milestonesCollection =
      FirebaseFirestore.instance.collection('milestones');

  Future<ApiResultStatus<String>> saveMilestone({
    required String childId,
    required String actorUid,
    required String milestoneKey,
    required String title,
    required String whatThisMeans,
    required String storyText,
    required int chapter,
    required int ageInMonths,
  }) async {
    try {
      if (childId.isEmpty || actorUid.isEmpty || storyText.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final DateTime now = DateTime.now();
      final DocumentReference<Map<String, dynamic>> docRef =
          await _milestonesCollection.add(<String, dynamic>{
            'child_id': childId,
            'milestone_key': milestoneKey,
            'title': title,
            'what_this_means': whatThisMeans,
            'story_text': storyText,
            'chapter': chapter,
            'age_in_months': ageInMonths,
            'logged_by': actorUid,
            'timestamp': Timestamp.fromDate(now),
          });
      await ChildRepo.instance.childrenCollection
          .doc(childId)
          .collection('events')
          .add(<String, dynamic>{
            'type': 'milestone',
            'milestone_key': milestoneKey,
            'title': title,
            'chapter': chapter,
            'timestamp': Timestamp.fromDate(now),
            'updated_by': actorUid,
          });
      return ApiResultStatus.data(data: docRef.id);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus<List<MilestoneModel>>> fetchMilestonesForChild({
    required String childId,
  }) async {
    try {
      if (childId.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final QuerySnapshot<Map<String, dynamic>> snap = await _milestonesCollection
          .where('child_id', isEqualTo: childId)
          .orderBy('timestamp', descending: true)
          .get();
      final List<MilestoneModel> milestones = snap.docs
          .map(MilestoneModel.fromFirestore)
          .toList();
      return ApiResultStatus.data(data: milestones);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  /// Chapters 1–5 unlocked when at least one milestone exists in that chapter.
  static Set<int> unlockedChaptersFrom(List<MilestoneModel> milestones) {
    final Set<int> chapters = <int>{};
    for (final MilestoneModel milestone in milestones) {
      if (milestone.chapter >= 1 && milestone.chapter <= 5) {
        chapters.add(milestone.chapter);
      }
    }
    return chapters;
  }

  static bool isExportUnlocked(Set<int> unlockedChapters) {
    for (int chapter = 1; chapter <= 5; chapter++) {
      if (!unlockedChapters.contains(chapter)) {
        return false;
      }
    }
    return true;
  }
}
