import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/content/help_guidance_content.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/child_repo.dart';

import 'help_flow_state.dart';

/// Drives Help Me Now using Part 4 guidance from [HelpGuidanceContent].
class HelpFlowCubit extends Cubit<HelpFlowState> {
  HelpFlowCubit() : super(const HelpFlowState());

  StreamSubscription<DocumentSnapshot<Object?>>? _childSubscription;
  List<HelpGuidanceSuggestion> _currentSuggestions = <HelpGuidanceSuggestion>[];

  void init() {
    final UserModel? userModel = preferences.getUserModel();
    emit(HelpFlowState(userModel: userModel));
    _listenToChild(userModel?.defaultChild);
  }

  void changeProps({
    UserModel? userModel,
    ChildModel? childModel,
    ChildState? childState,
    String? selectedProblemType,
    String? contextLine,
    String? primaryAction,
    List<String>? steps,
    String? fallbackText,
    int? solutionIndex,
    int? failedAttempts,
    bool? showEscalationHint,
    ApiResultStatus? saveApiResultStatus,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        childState: childState ?? state.childState,
        selectedProblemType: selectedProblemType ?? state.selectedProblemType,
        contextLine: contextLine ?? state.contextLine,
        primaryAction: primaryAction ?? state.primaryAction,
        steps: steps ?? state.steps,
        fallbackText: fallbackText ?? state.fallbackText,
        solutionIndex: solutionIndex ?? state.solutionIndex,
        failedAttempts: failedAttempts ?? state.failedAttempts,
        showEscalationHint: showEscalationHint ?? state.showEscalationHint,
        saveApiResultStatus: saveApiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void _listenToChild(DocumentReference<Object?>? defaultChildRef) {
    _childSubscription?.cancel();
    _childSubscription = defaultChildRef?.snapshots().listen((
      DocumentSnapshot<Object?> event,
    ) {
      if (event.data() != null) {
        final ChildModel childModel = ChildModel.fromJson(
          event.data() as Map<String, dynamic>,
          event.reference,
        );
        changeProps(childModel: childModel, childState: childModel.childState);
      }
    });
  }

  Future<void> selectProblem(String problemType) async {
    final String childName = state.childModel?.childName ?? 'your child';
    final int ageInMonths = AgeUtils.resolvedAgeInMonths(
      dob: state.childModel?.childDob,
      legacyAgeText: state.childModel?.childAge ?? '',
    );
    final List<HelpGuidanceSuggestion> suggestions =
        await HelpGuidanceContent.suggestionsFor(
          appProblemKey: problemType,
          ageInMonths: ageInMonths,
          childName: childName,
        );
    if (suggestions.isEmpty) {
      return;
    }
    _currentSuggestions = suggestions;
    _applySuggestion(
      suggestion: suggestions.first,
      problemType: problemType,
      solutionIndex: 0,
      failedAttempts: 0,
      showEscalationHint: false,
    );
  }

  void stillNotWorking() {
    if (_currentSuggestions.isEmpty) {
      return;
    }
    final int nextFailedAttempts = state.failedAttempts + 1;
    final int nextIndex =
        (state.solutionIndex + 1) % _currentSuggestions.length;
    final HelpGuidanceSuggestion next = _currentSuggestions[nextIndex];
    _applySuggestion(
      suggestion: next,
      problemType: state.selectedProblemType,
      solutionIndex: nextIndex,
      failedAttempts: nextFailedAttempts,
      showEscalationHint: nextFailedAttempts >= 3,
    );
  }

  void _applySuggestion({
    required HelpGuidanceSuggestion suggestion,
    required String problemType,
    required int solutionIndex,
    required int failedAttempts,
    required bool showEscalationHint,
  }) {
    changeProps(
      selectedProblemType: problemType,
      contextLine: suggestion.contextLine,
      primaryAction: suggestion.primaryAction,
      steps: suggestion.steps,
      fallbackText: suggestion.fallbackText,
      solutionIndex: solutionIndex,
      failedAttempts: failedAttempts,
      showEscalationHint: showEscalationHint,
    );
  }

  Future<void> markHelped() async {
    final String childId = state.childModel?.reference?.id ?? '';
    final String uid = state.userModel?.uid ?? '';
    if (childId.isEmpty || uid.isEmpty) {
      changeProps(
        saveApiResultStatus: ApiResultStatus.error(
          error: Exception('Please select child.'),
        ),
      );
      return;
    }
    final int ageInMonths = AgeUtils.resolvedAgeInMonths(
      dob: state.childModel?.childDob,
      legacyAgeText: state.childModel?.childAge ?? '',
    );
    final String solutionId = _currentSuggestions.isNotEmpty
        ? _currentSuggestions[state.solutionIndex].solutionId
        : '${state.selectedProblemType}_${state.solutionIndex + 1}';
    changeProps(saveApiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus response = await ChildRepo.instance.saveHelpFlowEvent(
      childId: childId,
      actorUid: uid,
      problemType: state.selectedProblemType,
      solutionId: solutionId,
      childState: state.childState?.key ?? '',
      ageInMonths: ageInMonths,
    );
    changeProps(saveApiResultStatus: response);
  }

  @override
  Future<void> close() {
    _childSubscription?.cancel();
    return super.close();
  }
}
