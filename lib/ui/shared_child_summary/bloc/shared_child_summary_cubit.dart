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

    List<HandoverLogItem> updates = state.recentUpdates;
    if (childId.isNotEmpty) {
      final ApiResultStatus<List<SleepLogModel>> sleepResult =
          await TodayLogRepo.instance.getRecentSleepLogs(childId, limit: 3);
      if (sleepResult is Data<List<SleepLogModel>> &&
          sleepResult.data.isNotEmpty) {
        final List<HandoverLogItem> dynamicItems = <HandoverLogItem>[];
        for (int i = 0; i < sleepResult.data.length && i < 2; i++) {
          final SleepLogModel log = sleepResult.data[i];
          final bool isPartner = i % 2 == 0;
          dynamicItems.add(
            HandoverLogItem(
              authorName: isPartner ? pName : 'You',
              isPartner: isPartner,
              actionDescription: (log.durationMinutes ?? 0) > 0
                  ? 'logged sleep (${log.durationMinutes}m)'
                  : 'logged bedtime',
              timeAgo: i == 0 ? 'today' : 'yesterday',
            ),
          );
        }
        if (dynamicItems.isNotEmpty) {
          updates = dynamicItems;
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
}
