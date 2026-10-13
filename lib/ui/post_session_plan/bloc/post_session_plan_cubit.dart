import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'post_session_plan_state.dart';

/// Cubit managing Post-Session Plan (Screen 50).
/// Conforms to AGENTS.md Rule 4.2.
class PostSessionPlanCubit extends Cubit<PostSessionPlanState> {
  PostSessionPlanCubit() : super(const PostSessionPlanState());

  String _resolvedChildId = 'default_child';

  Future<void> init({String? childId}) async {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    _resolvedChildId =
        childId ??
        preferences.getChildModel()?.reference?.id ??
        'default_child';

    final ApiResultStatus<PostSessionPlanModel> res = await MentorshipRepo
        .instance
        .getPostSessionPlan(_resolvedChildId);

    if (res is Data<PostSessionPlanModel>) {
      changeProps(isLoading: false, plan: res.data, fetchStatus: res);
    } else {
      changeProps(isLoading: false, fetchStatus: res);
    }
  }

  void changeProps({
    bool? isLoading,
    PostSessionPlanModel? plan,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        plan: plan ?? state.plan,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> toggleTask(String taskId) async {
    if (state.plan == null) return;

    final PlanTaskItem? target = state.plan!.tasks
        .where((PlanTaskItem t) => t.id == taskId)
        .firstOrNull;
    if (target == null) return;

    final bool newStatus = !target.isCompleted;
    final ApiResultStatus<PostSessionPlanModel> res = await MentorshipRepo
        .instance
        .togglePlanTask(
          childId: _resolvedChildId,
          taskId: taskId,
          isCompleted: newStatus,
        );

    if (res is Data<PostSessionPlanModel>) {
      changeProps(plan: res.data);
    }
  }
}
