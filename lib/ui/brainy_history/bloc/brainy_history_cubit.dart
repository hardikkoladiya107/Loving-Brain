import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import 'brainy_history_state.dart';

class BrainyHistoryCubit extends Cubit<BrainyHistoryState> {
  BrainyHistoryCubit() : super(const BrainyHistoryState());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _conversationSubscription;

  static final Set<String> _deletedSampleIds = <String>{};

  void init() {
    emit(const BrainyHistoryState());
    _emitDefaultItems();

    final String uid = preferences.getUserModel()?.uid ?? '';
    if (uid.isEmpty) return;

    _conversationSubscription?.cancel();
    _conversationSubscription = AuthRepo.instance.userCollection
        .doc(uid)
        .collection('conversations')
        .snapshots()
        .listen(
          (QuerySnapshot<Map<String, dynamic>> snapshot) {
            if (isClosed) return;
            if (snapshot.docs.isEmpty) {
              changeProps(
                thisWeekHistory: const <BrainyHistoryItem>[],
                earlierHistory: const <BrainyHistoryItem>[],
              );
              return;
            }

            final DateTime now = DateTime.now();
            final List<(DateTime, BrainyHistoryItem)> parsed = [];

            for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.docs) {
              final Map<String, dynamic> data = doc.data();
              final String convId =
                  data['conversation_id']?.toString() ?? doc.id;
              final String title =
                  (data['first_message']?.toString() ?? '').trim().isNotEmpty
                  ? data['first_message'].toString().trim()
                  : 'Conversation with Brainy';
              final String? topic = data['topic']?.toString();

              DateTime createdAt = now;
              final Object? rawCreatedAt = data['created_at'];
              if (rawCreatedAt is Timestamp) {
                createdAt = rawCreatedAt.toDate();
              } else {
                final int? ms = int.tryParse(convId);
                if (ms != null && ms > 1000000000000) {
                  createdAt = DateTime.fromMillisecondsSinceEpoch(ms);
                }
              }

              parsed.add((
                createdAt,
                BrainyHistoryItem(
                  conversationId: convId,
                  title: title,
                  subtitle: _formatRelativeDate(createdAt, now),
                  topic: topic,
                ),
              ));
            }

            parsed.sort(
              (
                (DateTime, BrainyHistoryItem) a,
                (DateTime, BrainyHistoryItem) b,
              ) => b.$1.compareTo(a.$1),
            );

            final List<BrainyHistoryItem> thisWeek = [];
            final List<BrainyHistoryItem> earlier = [];

            for (final (DateTime, BrainyHistoryItem) entry in parsed) {
              final int diffDays = now.difference(entry.$1).inDays;
              if (diffDays <= 7) {
                thisWeek.add(entry.$2);
              } else {
                earlier.add(entry.$2);
              }
            }

            changeProps(thisWeekHistory: thisWeek, earlierHistory: earlier);
          },
          onError: (_) {
            _conversationSubscription?.cancel();
            _conversationSubscription = null;
          },
          cancelOnError: true,
        );
  }

  void changeProps({
    List<BrainyHistoryItem>? thisWeekHistory,
    List<BrainyHistoryItem>? earlierHistory,
  }) {
    emit(
      state.copyWith(
        thisWeekHistory: thisWeekHistory ?? state.thisWeekHistory,
        earlierHistory: earlierHistory ?? state.earlierHistory,
      ),
    );
  }

  void _emitDefaultItems() {
    final List<BrainyHistoryItem> thisWeek = <BrainyHistoryItem>[
      if (!_deletedSampleIds.contains('sample_bedtime'))
        BrainyHistoryItem(
          conversationId: 'sample_bedtime',
          title: 'Why is bedtime harder lately?',
          subtitle: 'Today',
          topic: 'Sleep',
        ),
      if (!_deletedSampleIds.contains('sample_age'))
        BrainyHistoryItem(
          conversationId: 'sample_age',
          title: 'Is this normal for her age?',
          subtitle: '2 days ago',
          topic: 'Behaviour',
        ),
    ];

    final List<BrainyHistoryItem> earlier = <BrainyHistoryItem>[
      if (!_deletedSampleIds.contains('sample_naps'))
        BrainyHistoryItem(
          conversationId: 'sample_naps',
          title: 'What can I try for naps?',
          subtitle: 'Last week',
          topic: 'Sleep',
        ),
    ];

    changeProps(thisWeekHistory: thisWeek, earlierHistory: earlier);
  }

  String _formatRelativeDate(DateTime date, DateTime now) {
    final int days = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(date.year, date.month, date.day)).inDays;
    if (days <= 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days < 7) return '$days days ago';
    if (days < 14) return 'Last week';
    final int weeks = (days / 7).floor();
    return '$weeks weeks ago';
  }

  Future<void> deleteConversation(String conversationId) async {
    if (conversationId.isEmpty) return;
    if (conversationId.startsWith('sample_')) {
      _deletedSampleIds.add(conversationId);
    } else {
      await AuthRepo.instance.deleteConversation(
        conversationId: conversationId,
      );
    }

    final List<BrainyHistoryItem> updatedThisWeek = state.thisWeekHistory
        .where(
          (BrainyHistoryItem item) =>
              item.conversationId != conversationId &&
              item.title != conversationId,
        )
        .toList();
    final List<BrainyHistoryItem> updatedEarlier = state.earlierHistory
        .where(
          (BrainyHistoryItem item) =>
              item.conversationId != conversationId &&
              item.title != conversationId,
        )
        .toList();

    changeProps(
      thisWeekHistory: updatedThisWeek,
      earlierHistory: updatedEarlier,
    );
  }

  @override
  Future<void> close() async {
    await _conversationSubscription?.cancel();
    return super.close();
  }
}
