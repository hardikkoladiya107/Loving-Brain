import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import 'brainy_saved_guidance_state.dart';

class BrainySavedGuidanceCubit extends Cubit<BrainySavedGuidanceState> {
  BrainySavedGuidanceCubit() : super(const BrainySavedGuidanceState());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _savedSubscription;

  void changeProps({
    List<BrainySavedItem>? sleepItems,
    List<BrainySavedItem>? behaviourItems,
    List<BrainySavedItem>? parentWellbeingItems,
    bool? hasLoadError,
  }) {
    emit(
      state.copyWith(
        sleepItems: sleepItems ?? state.sleepItems,
        behaviourItems: behaviourItems ?? state.behaviourItems,
        parentWellbeingItems:
            parentWellbeingItems ?? state.parentWellbeingItems,
        hasLoadError: hasLoadError ?? state.hasLoadError,
      ),
    );
  }

  void reset() {
    _savedSubscription?.cancel();
    _savedSubscription = null;
    emit(const BrainySavedGuidanceState());
  }

  void init() {
    emit(const BrainySavedGuidanceState());
    _listen();
  }

  void retry() {
    changeProps(
      sleepItems: const <BrainySavedItem>[],
      behaviourItems: const <BrainySavedItem>[],
      parentWellbeingItems: const <BrainySavedItem>[],
      hasLoadError: false,
    );
    _listen();
  }

  void _listen() {
    final String uid = preferences.getUserModel()?.uid ?? '';
    if (uid.isEmpty) return;

    _savedSubscription?.cancel();
    _savedSubscription = AuthRepo.instance.userCollection
        .doc(uid)
        .collection('saved_guidance')
        .snapshots()
        .listen(
          (QuerySnapshot<Map<String, dynamic>> snapshot) {
            if (isClosed) return;
            if (snapshot.docs.isEmpty) {
              changeProps(
                sleepItems: const <BrainySavedItem>[],
                behaviourItems: const <BrainySavedItem>[],
                parentWellbeingItems: const <BrainySavedItem>[],
                hasLoadError: false,
              );
              return;
            }

            final DateTime now = DateTime.now();
            final List<BrainySavedItem> sleep = <BrainySavedItem>[];
            final List<BrainySavedItem> behaviour = <BrainySavedItem>[];
            final List<BrainySavedItem> wellbeing = <BrainySavedItem>[];

            for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.docs) {
              final Map<String, dynamic> data = doc.data();
              final String topic = data['topic']?.toString().trim() ?? 'Sleep';
              final String title =
                  data['title']?.toString().trim() ?? 'Saved guidance';
              final String? convId = data['conversation_id']?.toString();

              DateTime savedAt = now;
              final Object? rawSavedAt = data['saved_at'];
              if (rawSavedAt is Timestamp) {
                savedAt = rawSavedAt.toDate();
              }

              final BrainySavedItem item = BrainySavedItem(
                id: doc.id,
                conversationId: convId,
                title: title,
                subtitle: formatSavedSubtitleForTesting(savedAt, now),
                imagePath: Assets.v2.images.imgSleep.path,
                imageBgColorValue: 0xFFF1EEFF,
                topic: topic,
                whatMayBeHappeningHeadline:
                    data['what_may_be_happening_headline']?.toString(),
                whatMayBeHappeningSubtext: data['what_may_be_happening_subtext']
                    ?.toString(),
                whatToTryNowHeadline: data['what_to_try_now_headline']
                    ?.toString(),
                whatToTryNowSubtext: data['what_to_try_now_subtext']
                    ?.toString(),
                whenToGetHelpHeadline: data['when_to_get_help_headline']
                    ?.toString(),
                whenToGetHelpSubtext: data['when_to_get_help_subtext']
                    ?.toString(),
              );

              final String lowerTopic = topic.toLowerCase();
              if (lowerTopic == 'sleep') {
                sleep.add(
                  BrainySavedItem(
                    id: item.id,
                    conversationId: item.conversationId,
                    title: item.title,
                    subtitle: item.subtitle,
                    imagePath: Assets.v2.images.imgSleep.path,
                    imageBgColorValue: 0xFFF1EEFF,
                    topic: topic,
                    whatMayBeHappeningHeadline: item.whatMayBeHappeningHeadline,
                    whatMayBeHappeningSubtext: item.whatMayBeHappeningSubtext,
                    whatToTryNowHeadline: item.whatToTryNowHeadline,
                    whatToTryNowSubtext: item.whatToTryNowSubtext,
                    whenToGetHelpHeadline: item.whenToGetHelpHeadline,
                    whenToGetHelpSubtext: item.whenToGetHelpSubtext,
                  ),
                );
              } else if (lowerTopic == 'behaviour' || lowerTopic == 'mood') {
                behaviour.add(
                  BrainySavedItem(
                    id: item.id,
                    conversationId: item.conversationId,
                    title: item.title,
                    subtitle: item.subtitle,
                    imagePath: Assets.v2.images.imgTantrums.path,
                    imageBgColorValue: 0xFFFEF0E8,
                    topic: topic,
                    whatMayBeHappeningHeadline: item.whatMayBeHappeningHeadline,
                    whatMayBeHappeningSubtext: item.whatMayBeHappeningSubtext,
                    whatToTryNowHeadline: item.whatToTryNowHeadline,
                    whatToTryNowSubtext: item.whatToTryNowSubtext,
                    whenToGetHelpHeadline: item.whenToGetHelpHeadline,
                    whenToGetHelpSubtext: item.whenToGetHelpSubtext,
                  ),
                );
              } else {
                wellbeing.add(
                  BrainySavedItem(
                    id: item.id,
                    conversationId: item.conversationId,
                    title: item.title,
                    subtitle: item.subtitle,
                    imagePath: Assets.v2.images.imgHealth.path,
                    imageBgColorValue: 0xFFE2F0FF,
                    topic: topic,
                    whatMayBeHappeningHeadline: item.whatMayBeHappeningHeadline,
                    whatMayBeHappeningSubtext: item.whatMayBeHappeningSubtext,
                    whatToTryNowHeadline: item.whatToTryNowHeadline,
                    whatToTryNowSubtext: item.whatToTryNowSubtext,
                    whenToGetHelpHeadline: item.whenToGetHelpHeadline,
                    whenToGetHelpSubtext: item.whenToGetHelpSubtext,
                  ),
                );
              }
            }

            changeProps(
              sleepItems: sleep,
              behaviourItems: behaviour,
              parentWellbeingItems: wellbeing,
              hasLoadError: false,
            );
          },
          onError: (_) {
            if (isClosed) return;
            changeProps(hasLoadError: true);
          },
          cancelOnError: false,
        );
  }

  static String formatSavedSubtitleForTesting(DateTime savedAt, DateTime now) {
    final int days = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(savedAt.year, savedAt.month, savedAt.day)).inDays;
    if (days <= 0) return 'Saved today';
    if (days == 1) return 'Saved yesterday';
    if (days < 7) return 'Saved $days days ago';
    if (days < 14) return 'Saved 1 week ago';
    final int weeks = (days / 7).floor();
    if (weeks < 8) return 'Saved $weeks weeks ago';
    return 'Saved on ${savedAt.year}-${savedAt.month.toString().padLeft(2, '0')}-${savedAt.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<void> close() async {
    await _savedSubscription?.cancel();
    return super.close();
  }
}
