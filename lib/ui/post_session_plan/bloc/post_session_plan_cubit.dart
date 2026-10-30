import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'post_session_plan_state.dart';

/// Cubit managing Post-Session Plan (Screen 50).
class PostSessionPlanCubit extends Cubit<PostSessionPlanState> {
  PostSessionPlanCubit() : super(const PostSessionPlanState());

  String _resolvedChildId = '';

  void reset() {
    _resolvedChildId = '';
    emit(const PostSessionPlanState());
  }

  Future<void> init({String? childId}) async {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    _resolvedChildId =
        childId ?? preferences.getChildModel()?.reference?.id ?? '';

    if (_resolvedChildId.isEmpty) {
      changeProps(
        isLoading: false,
        clearPlan: true,
        fetchStatus: ApiResultStatus.error(
          error: Exception('Please select a child profile first.'),
        ),
      );
      return;
    }

    final ApiResultStatus<PostSessionPlanModel?> res = await MentorshipRepo
        .instance
        .getPostSessionPlan(_resolvedChildId);

    if (res is Data<PostSessionPlanModel?>) {
      changeProps(
        isLoading: false,
        plan: res.data,
        clearPlan: res.data == null,
        fetchStatus: res,
      );
    } else {
      changeProps(isLoading: false, clearPlan: true, fetchStatus: res);
    }
  }

  void changeProps({
    bool? isLoading,
    PostSessionPlanModel? plan,
    bool clearPlan = false,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        plan: clearPlan ? null : (plan ?? state.plan),
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> toggleTask(String taskId) async {
    if (state.plan == null || _resolvedChildId.isEmpty) return;

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
    } else if (res is Error<PostSessionPlanModel>) {
      changeProps(fetchStatus: res);
    }
  }
}
