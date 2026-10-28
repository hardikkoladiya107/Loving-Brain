import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'package:loving_brain/repo/user_repo.dart';

import 'shared_child_summary_state.dart';

/// Cubit managing Shared Child Summary / Handover View (Screen 52).
/// Conforms to AGENTS.md Rule 4.2.
class SharedChildSummaryCubit extends Cubit<SharedChildSummaryState> {
  SharedChildSummaryCubit() : super(const SharedChildSummaryState());

  Future<void> init() async {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    final ChildModel? child = preferences.getChildModel();
    final String? childName = child?.childName?.trim();
    final String cName = (childName != null && childName.isNotEmpty)
        ? childName
        : 'your child';

    final UserModel? user = preferences.getUserModel();
    String pName = 'Co-Parent';
    final String? partnerId = user?.partnerUserId?.trim();
    if (partnerId != null && partnerId.isNotEmpty) {
      try {
        final UserModel? partnerUser = await UserRepo.instance.getUserById(
          uid: partnerId,
        );
        final String? partnerParentName = partnerUser?.parentName?.trim();
        if (partnerParentName != null && partnerParentName.isNotEmpty) {
          pName = partnerParentName;
        } else if (partnerUser?.email?.isNotEmpty == true) {
          pName = partnerUser!.email!.split('@').first;
        }
      } catch (_) {}
    }

    final String childId =
        child?.reference?.id ??
        TodayLogRepo.instance.resolveActiveChildId() ??
        '';

    List<HandoverLogItem> updates = <HandoverLogItem>[];
    if (childId.isNotEmpty) {
      final ApiResultStatus<List<SleepLogModel>> sleepResult =
          await TodayLogRepo.instance.getRecentSleepLogs(childId, limit: 3);
      if (sleepResult is Data<List<SleepLogModel>> &&
          sleepResult.data.isNotEmpty) {
        for (int i = 0; i < sleepResult.data.length && i < 3; i++) {
          final SleepLogModel log = sleepResult.data[i];
          final bool isPartner =
              (log.userId != null &&
              user?.uid != null &&
              log.userId != user!.uid);
          final String authorName = isPartner ? pName : 'You';
          final DateTime logTimestamp = log.createdAt ?? log.bedTime;
          final String timeAgo = _formatRelativeTime(logTimestamp);
          final String action = (log.durationMinutes ?? 0) > 0
              ? 'logged sleep (${log.durationMinutes}m)'
              : 'logged bedtime';

          updates.add(
            HandoverLogItem(
              authorName: authorName,
              isPartner: isPartner,
              actionDescription: action,
              timeAgo: timeAgo,
            ),
          );
        }
      }
    }

    changeProps(
      isLoading: false,
      childName: cName,
      partnerName: pName,
      recentUpdates: updates,
      fetchStatus: const ApiResultStatus.data(data: null),
    );
  }

  void changeProps({
    bool? isLoading,
    String? childName,
    String? partnerName,
    String? todaysPlanTitle,
    String? todaysPlanSubtitle,
    List<HandoverLogItem>? recentUpdates,
    String? activeWeeklyFocus,
    String? handoverNote,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        childName: childName ?? state.childName,
        partnerName: partnerName ?? state.partnerName,
        todaysPlanTitle: todaysPlanTitle ?? state.todaysPlanTitle,
        todaysPlanSubtitle: todaysPlanSubtitle ?? state.todaysPlanSubtitle,
        recentUpdates: recentUpdates ?? state.recentUpdates,
        activeWeeklyFocus: activeWeeklyFocus ?? state.activeWeeklyFocus,
        handoverNote: handoverNote ?? state.handoverNote,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  String _formatRelativeTime(DateTime? time) {
    if (time == null) return 'recently';
    final Duration diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      final int m = diff.inMinutes;
      return m <= 1 ? 'just now' : '$m min ago';
    } else if (diff.inHours < 24) {
      final int h = diff.inHours;
      return '$h hour${h == 1 ? '' : 's'} ago';
    } else if (diff.inDays == 1) {
      return 'yesterday';
    } else {
      return '${diff.inDays} days ago';
    }
  }
}
