import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'guide_list_state.dart';

/// Cubit managing the multi-guide list after support-area matching.
class GuideListCubit extends Cubit<GuideListState> {
  GuideListCubit() : super(const GuideListState());

  Future<void> init({
    required String supportArea,
    List<GuideProfileModel>? guides,
  }) async {
    changeProps(
      isLoading: true,
      supportArea: supportArea,
      fetchStatus: const ApiResultStatus.loading(),
    );

    if (guides != null && guides.isNotEmpty) {
      changeProps(
        isLoading: false,
        guides: guides,
        fetchStatus: ApiResultStatus.data(data: guides),
      );
      return;
    }

    final ApiResultStatus<List<GuideProfileModel>> result = await MentorshipRepo
        .instance
        .getGuideProfiles(supportArea: supportArea);
    if (result is Data<List<GuideProfileModel>>) {
      changeProps(isLoading: false, guides: result.data, fetchStatus: result);
    } else {
      changeProps(
        isLoading: false,
        guides: <GuideProfileModel>[],
        fetchStatus: result,
      );
    }
  }

  void changeProps({
    bool? isLoading,
    String? supportArea,
    List<GuideProfileModel>? guides,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        supportArea: supportArea ?? state.supportArea,
        guides: guides ?? state.guides,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }
}
