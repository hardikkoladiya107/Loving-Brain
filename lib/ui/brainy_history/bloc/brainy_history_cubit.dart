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

  void init() {
    _emitDefaultItems();

    final String uid = preferences.getUserModel()?.uid ?? '';
    if (uid.isEmpty) return;

    _conversationSubscription?.cancel();
    _conversationSubscription = AuthRepo.instance.userCollection
        .doc(uid)
        .collection('conversations')
        .snapshots()
        .listen((snapshot) {
          if (isClosed) return;
          if (snapshot.docs.isEmpty) {
            _emitDefaultItems();
            return;
          }

          final now = DateTime.now();
          final List<(DateTime, BrainyHistoryItem)> parsed = [];

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final String convId =
                data['conversation_id']?.toString() ?? doc.id;
            final String title =
                (data['first_message']?.toString() ?? '').trim().isNotEmpty
                ? data['first_message'].toString().trim()
                : 'Conversation with Brainy';
            final String? topic = data['topic']?.toString();

            DateTime createdAt = now;
            final rawCreatedAt = data['created_at'];
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

          parsed.sort((a, b) => b.$1.compareTo(a.$1));

          final List<BrainyHistoryItem> thisWeek = [];
          final List<BrainyHistoryItem> earlier = [];

          for (final entry in parsed) {
            final diffDays = now.difference(entry.$1).inDays;
            if (diffDays <= 7) {
              thisWeek.add(entry.$2);
            } else {
              earlier.add(entry.$2);
            }
          }

          emit(
            state.copyWith(
              thisWeekHistory: thisWeek,
              earlierHistory: earlier,
            ),
          );
        });
  }

  void _emitDefaultItems() {
    emit(
      state.copyWith(
        thisWeekHistory: [
          BrainyHistoryItem(
            title: 'Why is bedtime harder lately?',
            subtitle: 'Today',
            topic: 'Sleep',
          ),
          BrainyHistoryItem(
            title: 'Is this normal for her age?',
            subtitle: '2 days ago',
            topic: 'Behaviour',
          ),
        ],
        earlierHistory: [
          BrainyHistoryItem(
            title: 'What can I try for naps?',
            subtitle: 'Last week',
            topic: 'Sleep',
          ),
        ],
      ),
    );
  }

  String _formatRelativeDate(DateTime date, DateTime now) {
    final int days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;
    if (days <= 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days < 7) return '$days days ago';
    if (days < 14) return 'Last week';
    final int weeks = (days / 7).floor();
    return '$weeks weeks ago';
  }

  Future<void> deleteConversation(String conversationId) async {
    if (conversationId.isEmpty) return;
    await AuthRepo.instance.deleteConversation(conversationId: conversationId);
  }

  @override
  Future<void> close() async {
    await _conversationSubscription?.cancel();
    return super.close();
  }
}
