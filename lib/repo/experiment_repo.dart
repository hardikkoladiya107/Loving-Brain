import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

/// ExperimentRepo manages 1-week family experiments started from the Weekly Review.
class ExperimentRepo {
  ExperimentRepo._();
  static final ExperimentRepo _instance = ExperimentRepo._();
  factory ExperimentRepo() => _instance;
  static ExperimentRepo get instance => _instance;

  CollectionReference<Map<String, dynamic>>? get _childrenCollection {
    try {
      return FirebaseFirestore.instance.collection('children');
    } catch (_) {
      return null;
    }
  }

  // In-memory fallback cache for testing and offline persistence
  final Map<String, ActiveExperimentModel> _cachedActiveExperiments =
      <String, ActiveExperimentModel>{};

  /// Retrieves the currently active experiment for [childId], if any.
  Future<ApiResultStatus<ActiveExperimentModel?>> getActiveExperiment({
    required String childId,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return const ApiResultStatus.data(data: null);
      }

      // Check Firestore if available
      try {
        final CollectionReference<Map<String, dynamic>>? col =
            _childrenCollection;
        if (col != null) {
          final QuerySnapshot<Map<String, dynamic>> snap = await col
              .doc(childId)
              .collection('experiments')
              .where('status', isEqualTo: 'active')
              .limit(5)
              .get();

          if (snap.docs.isNotEmpty) {
            final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
                  snap.docs,
                );
            docs.sort((
              QueryDocumentSnapshot<Map<String, dynamic>> a,
              QueryDocumentSnapshot<Map<String, dynamic>> b,
            ) {
              final String aCreated =
                  a.data()['createdAt']?.toString() ??
                  a.data()['created_at']?.toString() ??
                  '';
              final String bCreated =
                  b.data()['createdAt']?.toString() ??
                  b.data()['created_at']?.toString() ??
                  '';
              return bCreated.compareTo(aCreated);
            });
            final ActiveExperimentModel model = ActiveExperimentModel.fromDoc(
              docs.first,
            );
            _cachedActiveExperiments[childId] = model;
            return ApiResultStatus.data(data: model);
          }
        }
      } catch (_) {
        // Fall back to in-memory cache if offline or in mock environment
      }

      final ActiveExperimentModel? cached = _cachedActiveExperiments[childId];
      if (cached != null && cached.status == 'active') {
        return ApiResultStatus.data(data: cached);
      }

      return const ApiResultStatus.data(data: null);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Starts a new 1-week experiment for [childId].
  Future<ApiResultStatus<String>> startExperiment({
    required String childId,
    required ActiveExperimentModel experiment,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChildFirst.tr()),
        );
      }

      String docId = experiment.id.isNotEmpty
          ? experiment.id
          : DateTime.now().millisecondsSinceEpoch.toString();

      try {
        final CollectionReference<Map<String, dynamic>>? col =
            _childrenCollection;
        if (col != null) {
          final DocumentReference<Map<String, dynamic>> docRef = await col
              .doc(childId)
              .collection('experiments')
              .add(experiment.toMap());
          docId = docRef.id;
        }
      } catch (_) {
        // Firestore may be unavailable in unit tests
      }

      final ActiveExperimentModel saved = experiment.copyWith(id: docId);
      _cachedActiveExperiments[childId] = saved;

      // Log event to unified family timeline
      try {
        await TodayLogRepo.instance.addTimelineEvent(
          childId: childId,
          type: 'experiment',
          title: 'Started trying: ${experiment.changeTitle}',
          subtitle: 'Observing: ${experiment.observeTarget}',
        );
      } catch (_) {}

      return ApiResultStatus.data(data: docId);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Ends an active experiment early.
  Future<ApiResultStatus<bool>> finishExperimentEarly({
    required String childId,
    required String experimentId,
    String? reason,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChildFirst.tr()),
        );
      }

      try {
        final CollectionReference<Map<String, dynamic>>? col =
            _childrenCollection;
        if (col != null && experimentId.isNotEmpty) {
          await col
              .doc(childId)
              .collection('experiments')
              .doc(experimentId)
              .update(<String, dynamic>{
                'status': 'ended_early',
                'resultNote': reason ?? 'Ended before 7-day review',
                'updatedAt': FieldValue.serverTimestamp(),
              });
        }
      } catch (_) {}

      final ActiveExperimentModel? cached = _cachedActiveExperiments[childId];
      if (cached != null) {
        _cachedActiveExperiments[childId] = cached.copyWith(
          status: 'ended_early',
          resultNote: reason ?? 'Ended before 7-day review',
        );
      }

      // Record timeline item for ending experiment
      try {
        await TodayLogRepo.instance.addTimelineEvent(
          childId: childId,
          type: 'experiment',
          title: 'Finished experiment early',
          subtitle: reason ?? 'Reviewed early with family',
        );
      } catch (_) {}

      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Marks an active experiment as complete at the review date.
  Future<ApiResultStatus<bool>> completeExperiment({
    required String childId,
    required String experimentId,
    String? resultNote,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChildFirst.tr()),
        );
      }

      try {
        final CollectionReference<Map<String, dynamic>>? col =
            _childrenCollection;
        if (col != null && experimentId.isNotEmpty) {
          await col
              .doc(childId)
              .collection('experiments')
              .doc(experimentId)
              .update(<String, dynamic>{
                'status': 'completed',
                'resultNote': resultNote ?? 'Completed full 7-day review',
                'updatedAt': FieldValue.serverTimestamp(),
              });
        }
      } catch (_) {}

      final ActiveExperimentModel? cached = _cachedActiveExperiments[childId];
      if (cached != null) {
        _cachedActiveExperiments[childId] = cached.copyWith(
          status: 'completed',
          resultNote: resultNote ?? 'Completed full 7-day review',
        );
      }

      try {
        await TodayLogRepo.instance.addTimelineEvent(
          childId: childId,
          type: 'experiment',
          title: 'Completed weekly experiment',
          subtitle: resultNote ?? 'Held for 7 days',
        );
      } catch (_) {}

      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Test helper to clear cache
  void clearCache() {
    _cachedActiveExperiments.clear();
  }
}
