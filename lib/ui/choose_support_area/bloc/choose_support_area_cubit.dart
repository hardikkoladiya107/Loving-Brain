import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'choose_support_area_state.dart';

/// Cubit managing Choose a Support Area (Screen 45).
/// Conforms to AGENTS.md Rule 4.2.
class ChooseSupportAreaCubit extends Cubit<ChooseSupportAreaState> {
  ChooseSupportAreaCubit() : super(const ChooseSupportAreaState());

  /// Same order as the cards on Choose Support.
  static const List<String> optionTitles = <String>[
    'Sleep guidance',
    'Tantrum & behaviour',
    'Eating & nutrition',
    'Parental confidence',
    'Co-parenting',
  ];

  /// Maps a landing label or card title onto the visible card index.
  static int indexForLabel(String? label) {
    final String tag = MentorshipRepo.mapSupportAreaLabel(label);
    switch (tag) {
      case 'Sleep':
        return 0;
      case 'Behaviour':
        return 1;
      case 'Eating':
        return 2;
      case 'Parent Wellbeing':
        return 3;
      case 'Co-parenting':
        return 4;
      default:
        return -1;
    }
  }

  bool _matching = false;

  void init({String? initialArea}) {
    emit(const ChooseSupportAreaState());
    if (initialArea != null && initialArea.isNotEmpty) {
      changeProps(selectedIndex: indexForLabel(initialArea));
    }
  }

  void reset() {
    emit(const ChooseSupportAreaState());
  }

  void changeProps({
    int? selectedIndex,
    List<String>? areas,
    List<GuideProfileModel>? matchedGuides,
    ApiResultStatus? matchStatus,
  }) {
    emit(
      state.copyWith(
        selectedIndex: selectedIndex ?? state.selectedIndex,
        areas: areas ?? state.areas,
        matchedGuides: matchedGuides ?? state.matchedGuides,
        matchStatus: matchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void selectArea(int index) {
    changeProps(selectedIndex: index);
  }

  Future<ApiResultStatus<GuideAreaMatch>> matchSupportArea(
    String supportAreaTitle,
  ) async {
    if (_matching) {
      return const ApiResultStatus.loading();
    }
    _matching = true;
    changeProps(matchStatus: const ApiResultStatus.loading());
    try {
      final ApiResultStatus<GuideAreaMatch> result = await MentorshipRepo
          .instance
          .matchSupportArea(supportAreaTitle);
      if (result is Data<GuideAreaMatch>) {
        changeProps(
          matchedGuides: result.data.guides,
          matchStatus: ApiResultStatus.data(data: result.data.guides),
        );
      } else if (result is Error<GuideAreaMatch>) {
        changeProps(
          matchedGuides: <GuideProfileModel>[],
          matchStatus: ApiResultStatus.error(error: result.error),
        );
      }
      return result;
    } finally {
      _matching = false;
    }
  }
}
