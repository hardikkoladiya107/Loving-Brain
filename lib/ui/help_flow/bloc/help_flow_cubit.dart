import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/child_repo.dart';

import 'help_flow_state.dart';

class HelpFlowCubit extends Cubit<HelpFlowState> {
  HelpFlowCubit() : super(const HelpFlowState());

  StreamSubscription<DocumentSnapshot<Object?>>? _childSubscription;

  static final Map<String, List<_GuidanceSolution>>
  _solutionsByProblem = <String, List<_GuidanceSolution>>{
    'crying': <_GuidanceSolution>[
      _GuidanceSolution(
        contextLine: 'Your child may be overstimulated or tired right now.',
        primaryAction:
            'Lower the lights and hold your child gently for 2-3 minutes.',
        steps: <String>[
          'Move to a quieter space.',
          'Hold your child chest-to-chest with slow breathing.',
          'Use one repeated calm phrase in a soft voice.',
        ],
        fallbackText:
            'If this does not work after 5 minutes, try gentle rocking with slow humming.',
      ),
      _GuidanceSolution(
        contextLine: 'Crying can continue when the body still feels unsafe.',
        primaryAction:
            'Swaddle or wrap softly and reduce movement for one minute.',
        steps: <String>[
          'Keep your voice low and steady.',
          'Limit extra touch/stimulation around the face.',
          'Offer steady pressure and pause for response.',
        ],
        fallbackText:
            'If this still does not work, check for hunger/discomfort and restart calmly.',
      ),
    ],
    'wont_sleep': <_GuidanceSolution>[
      _GuidanceSolution(
        contextLine:
            'Sleep resistance often means the nervous system is still active.',
        primaryAction:
            'Start a very short wind-down routine now with one quiet cue.',
        steps: <String>[
          'Dim lights and reduce sound.',
          'Use one cue (song or phrase) you repeat daily.',
          'Keep body movement minimal for 2-3 minutes.',
        ],
        fallbackText:
            'If sleep does not come in 5 minutes, try a brief cuddle reset then repeat the cue.',
      ),
      _GuidanceSolution(
        contextLine: 'Your child may need a transition before lying down.',
        primaryAction:
            'Do one calm transition activity before bedtime position.',
        steps: <String>[
          'Offer water or quick diaper check if needed.',
          'Hold close while breathing slowly together.',
          'Return to bed with minimal talking.',
        ],
        fallbackText:
            'If still not working, pause for 3 minutes in calm hold and retry.',
      ),
    ],
    'feeding_issue': <_GuidanceSolution>[
      _GuidanceSolution(
        contextLine:
            'Feeding issues can happen when your child feels rushed or tense.',
        primaryAction:
            'Pause 1 minute, then restart feeding in a slower rhythm.',
        steps: <String>[
          'Adjust position so head and neck feel supported.',
          'Offer smaller paced attempts.',
          'Watch cues and pause if stress increases.',
        ],
        fallbackText:
            'If this does not work after 5 minutes, try brief soothing then re-offer.',
      ),
      _GuidanceSolution(
        contextLine:
            'Your child may accept feeding better after calming first.',
        primaryAction:
            'Soothe first, then retry feeding with lower stimulation.',
        steps: <String>[
          'Move to quieter environment.',
          'Use gentle touch and eye contact.',
          'Retry feeding without pressure.',
        ],
        fallbackText:
            'If still difficult, log this and consider checking with your nurse/doctor.',
      ),
    ],
    'too_fussy': <_GuidanceSolution>[
      _GuidanceSolution(
        contextLine:
            'Fussiness often means your child needs regulation before guidance.',
        primaryAction:
            'Offer comfort first: close hold and reduce stimulation.',
        steps: <String>[
          'Move away from noise/screen.',
          'Hold close with slow side-to-side motion.',
          'Use one soothing line repeatedly.',
        ],
        fallbackText:
            'If this does not work after 5 minutes, switch to quiet floor time with one toy.',
      ),
      _GuidanceSolution(
        contextLine: 'Your child may need a reset of sensory load.',
        primaryAction:
            'Try a sensory reset with less light, less sound, and less talking.',
        steps: <String>[
          'Dim lights further and remove extra toys.',
          'Sit together on floor or bed with soft contact.',
          'Wait calmly for 60-90 seconds before next cue.',
        ],
        fallbackText:
            'If still not working, take a short break and consider calling your health nurse/doctor.',
      ),
    ],
  };

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

  void selectProblem(String problemType) {
    final List<_GuidanceSolution> options =
        _solutionsByProblem[problemType] ?? const <_GuidanceSolution>[];
    if (options.isEmpty) {
      return;
    }
    final _GuidanceSolution first = options.first;
    changeProps(
      selectedProblemType: problemType,
      contextLine: first.contextLine,
      primaryAction: first.primaryAction,
      steps: first.steps,
      fallbackText: first.fallbackText,
      solutionIndex: 0,
      failedAttempts: 0,
      showEscalationHint: false,
    );
  }

  void stillNotWorking() {
    final String problemType = state.selectedProblemType;
    final List<_GuidanceSolution> options =
        _solutionsByProblem[problemType] ?? const <_GuidanceSolution>[];
    if (options.isEmpty) {
      return;
    }
    final int nextFailedAttempts = state.failedAttempts + 1;
    final int nextIndex = (state.solutionIndex + 1).clamp(
      0,
      options.length - 1,
    );
    final _GuidanceSolution next = options[nextIndex];
    changeProps(
      solutionIndex: nextIndex,
      failedAttempts: nextFailedAttempts,
      contextLine: next.contextLine,
      primaryAction: next.primaryAction,
      steps: next.steps,
      fallbackText: next.fallbackText,
      showEscalationHint: nextFailedAttempts >= 3,
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
    final int ageInMonths = _ageInMonthsFromChildAge(
      state.childModel?.childAge ?? '',
    );
    changeProps(saveApiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus response = await ChildRepo.instance.saveHelpFlowEvent(
      childId: childId,
      actorUid: uid,
      problemType: state.selectedProblemType,
      solutionId: '${state.selectedProblemType}_${state.solutionIndex + 1}',
      childState: state.childState?.key ?? '',
      ageInMonths: ageInMonths,
    );
    changeProps(saveApiResultStatus: response);
  }

  int _ageInMonthsFromChildAge(String childAge) {
    final String normalized = childAge.trim().toLowerCase();
    if (normalized.contains('0-3') || normalized.contains('0 - 3')) {
      return 18;
    }
    if (normalized.contains('3-6') || normalized.contains('3 - 6')) {
      return 54;
    }
    if (normalized.contains('6-9') || normalized.contains('6 - 9')) {
      return 90;
    }
    return 0;
  }

  @override
  Future<void> close() {
    _childSubscription?.cancel();
    return super.close();
  }
}

class _GuidanceSolution {
  const _GuidanceSolution({
    required this.contextLine,
    required this.primaryAction,
    required this.steps,
    required this.fallbackText,
  });

  final String contextLine;
  final String primaryAction;
  final List<String> steps;
  final String fallbackText;
}
