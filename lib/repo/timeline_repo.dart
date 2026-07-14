import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/repo/child_repo.dart';

class TimelineRepo {
  TimelineRepo._();
  static final TimelineRepo _instance = TimelineRepo._();
  factory TimelineRepo() => _instance;
  static TimelineRepo get instance => _instance;

  Future<ApiResultStatus<List<TimelineEventModel>>> fetchTodayEvents({
    required String childId,
  }) async {
    try {
      if (childId.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
      final DateTime now = DateTime.now();
      final DateTime startOfDay = DateTime(now.year, now.month, now.day);
      final QuerySnapshot<Map<String, dynamic>> eventsSnap = await ChildRepo
          .instance
          .childrenCollection
          .doc(childId)
          .collection('events')
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .orderBy('timestamp', descending: true)
          .get();

      final List<TimelineEventModel> events = eventsSnap.docs
          .map(TimelineEventModel.fromFirestore)
          .toList();

      return ApiResultStatus.data(data: events);
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
}
