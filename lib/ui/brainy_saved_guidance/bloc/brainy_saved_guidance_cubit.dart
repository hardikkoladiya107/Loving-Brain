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

  void init() {
    final defaultSleep = [
      BrainySavedItem(
        title: 'Why bedtime got harder',
        subtitle: 'Saved 2 days ago',
        imagePath: Assets.v2.images.imgSleep.path,
        imageBgColorValue: 0xFFF1EEFF,
        topic: 'Sleep',
      ),
    ];
    final defaultBehaviour = [
      BrainySavedItem(
        title: 'Tantrum triggers explained',
        subtitle: 'Saved 5 days ago',
        imagePath: Assets.v2.images.imgTantrums.path,
        imageBgColorValue: 0xFFFEF0E8,
        topic: 'Behaviour',
      ),
    ];
    final defaultWellbeing = [
      BrainySavedItem(
        title: '5 min breathing reset',
        subtitle: 'Saved 1 week ago',
        imagePath: Assets.v2.images.imgHealth.path,
        imageBgColorValue: 0xFFE2F0FF,
        topic: 'Health',
      ),
    ];

    emit(
      state.copyWith(
        sleepItems: defaultSleep,
        behaviourItems: defaultBehaviour,
        parentWellbeingItems: defaultWellbeing,
      ),
    );

    final String uid = preferences.getUserModel()?.uid ?? '';
    if (uid.isEmpty) return;

    _savedSubscription?.cancel();
    _savedSubscription = AuthRepo.instance.userCollection
        .doc(uid)
        .collection('saved_guidance')
        .snapshots()
        .listen((snapshot) {
          if (isClosed) return;
          if (snapshot.docs.isEmpty) {
            emit(
              state.copyWith(
                sleepItems: defaultSleep,
                behaviourItems: defaultBehaviour,
                parentWellbeingItems: defaultWellbeing,
              ),
            );
            return;
          }

          final now = DateTime.now();
          final List<BrainySavedItem> sleep = [];
          final List<BrainySavedItem> behaviour = [];
          final List<BrainySavedItem> wellbeing = [];

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final String topic =
                data['topic']?.toString().trim() ?? 'Sleep';
            final String title =
                data['title']?.toString().trim() ?? 'Saved guidance';
            final String? convId = data['conversation_id']?.toString();

            DateTime savedAt = now;
            final rawSavedAt = data['saved_at'];
            if (rawSavedAt is Timestamp) {
              savedAt = rawSavedAt.toDate();
            }

            final String lowerTopic = topic.toLowerCase();
            if (lowerTopic == 'sleep') {
              sleep.add(
                BrainySavedItem(
                  id: doc.id,
                  conversationId: convId,
                  title: title,
                  subtitle: _formatSavedSubtitle(savedAt, now),
                  imagePath: Assets.v2.images.imgSleep.path,
                  imageBgColorValue: 0xFFF1EEFF,
                  topic: topic,
                ),
              );
            } else if (lowerTopic == 'behaviour' || lowerTopic == 'mood') {
              behaviour.add(
                BrainySavedItem(
                  id: doc.id,
                  conversationId: convId,
                  title: title,
                  subtitle: _formatSavedSubtitle(savedAt, now),
                  imagePath: Assets.v2.images.imgTantrums.path,
                  imageBgColorValue: 0xFFFEF0E8,
                  topic: topic,
                ),
              );
            } else {
              wellbeing.add(
                BrainySavedItem(
                  id: doc.id,
                  conversationId: convId,
                  title: title,
                  subtitle: _formatSavedSubtitle(savedAt, now),
                  imagePath: Assets.v2.images.imgHealth.path,
                  imageBgColorValue: 0xFFE2F0FF,
                  topic: topic,
                ),
              );
            }
          }

          emit(
            state.copyWith(
              sleepItems: sleep.isNotEmpty ? sleep : defaultSleep,
              behaviourItems:
                  behaviour.isNotEmpty ? behaviour : defaultBehaviour,
              parentWellbeingItems:
                  wellbeing.isNotEmpty ? wellbeing : defaultWellbeing,
            ),
          );
        });
  }

  String _formatSavedSubtitle(DateTime savedAt, DateTime now) {
    final int days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(savedAt.year, savedAt.month, savedAt.day))
        .inDays;
    if (days <= 0) return 'Saved today';
    if (days == 1) return 'Saved yesterday';
    if (days < 7) return 'Saved $days days ago';
    return 'Saved 1 week ago';
  }

  @override
  Future<void> close() async {
    await _savedSubscription?.cancel();
    return super.close();
  }
}
