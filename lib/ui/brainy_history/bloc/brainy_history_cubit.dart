import 'package:flutter_bloc/flutter_bloc.dart';
import 'brainy_history_state.dart';

class BrainyHistoryCubit extends Cubit<BrainyHistoryState> {
  BrainyHistoryCubit() : super(const BrainyHistoryState());

  void init() {
    emit(
      state.copyWith(
        thisWeekHistory: [
          BrainyHistoryItem(
            title: "Why is bedtime harder lately?",
            subtitle: "Today",
          ),
          BrainyHistoryItem(
            title: "Is this normal for her age?",
            subtitle: "2 days ago",
          ),
        ],
        earlierHistory: [
          BrainyHistoryItem(
            title: "What can I try for naps?",
            subtitle: "Last week",
          ),
        ],
      ),
    );
  }
}
