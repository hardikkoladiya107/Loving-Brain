import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/ui/smart_moment/bloc/smart_moment_state.dart';

class SmartMomentCubit extends Cubit<SmartMomentState> {
  SmartMomentCubit() : super(const SmartMomentState());

  StreamSubscription<DocumentSnapshot<Object?>>? _childSubscription;

  void init() {
    final UserModel? userModel = preferences.getUserModel();
    emit(SmartMomentState(userModel: userModel));
    _listenToChild(userModel?.defaultChild);
  }

  void changeProps({
    UserModel? userModel,
    ChildModel? childModel,
    ChildState? stateAtTime,
    String? activityTitle,
    String? subtitle,
    String? message,
    List<String>? steps,
    ApiResultStatus? saveApiResultStatus,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        stateAtTime: stateAtTime ?? state.stateAtTime,
        activityTitle: activityTitle ?? state.activityTitle,
        subtitle: subtitle ?? state.subtitle,
        message: message ?? state.message,
        steps: steps ?? state.steps,
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
        final ChildState? childState = childModel.childState;
        final _SmartMomentContent content = _contentFor(
          childState: childState,
          childAge: childModel.childAge ?? '',
          childName: childModel.childName ?? 'your child',
        );
        changeProps(
          childModel: childModel,
          stateAtTime: childState,
          activityTitle: content.activityTitle,
          subtitle: content.subtitle,
          message: content.message,
          steps: content.steps,
        );
      }
    });
  }

  Future<void> markTriedThis() async {
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
    changeProps(saveApiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus response = await ChildRepo.instance.saveSmartMomentEvent(
      childId: childId,
      actorUid: uid,
      stateAtTime: state.stateAtTime?.key ?? '',
    );
    changeProps(saveApiResultStatus: response);
  }

  _SmartMomentContent _contentFor({
    required ChildState? childState,
    required String childAge,
    required String childName,
  }) {
    final _AgeBand ageBand = _ageBandFromText(childAge);
    if (childState == ChildState.calm) {
      if (ageBand == _AgeBand.zeroToThree) {
        return _SmartMomentContent(
          activityTitle: 'Connection Moment',
          subtitle: 'Best in the next 10-15 minutes',
          message:
              'This is a calm window for bonding. Small, simple interactions help your child feel safe and connected.',
          steps: <String>[
            'Sit on the floor with $childName.',
            'Hold one soft toy and let $childName touch it.',
            'Say one calm word slowly and smile.',
          ],
        );
      }
      if (ageBand == _AgeBand.threeToSix) {
        return _SmartMomentContent(
          activityTitle: 'Story & Talk Moment',
          subtitle: 'Best in the next 10-15 minutes',
          message:
              'Calm moments are ideal for meaningful talk. A short story activity can strengthen communication.',
          steps: <String>[
            'Pick one short picture story.',
            'Ask $childName what they see on each page.',
            'End with one warm sentence: "I loved this time with you."',
          ],
        );
      }
      return _SmartMomentContent(
        activityTitle: 'Mini Reflection Moment',
        subtitle: 'Best in the next 10-15 minutes',
        message:
            'Calm periods support emotional learning. A short reflection builds confidence and trust.',
        steps: <String>[
          'Sit together in a quiet spot.',
          'Ask one question: "What felt good today?"',
          'Share one proud moment from your side too.',
        ],
      );
    }

    if (childState == ChildState.highEnergy) {
      return _SmartMomentContent(
        activityTitle: 'Energy Channel Moment',
        subtitle: 'Best in the next 10-15 minutes',
        message:
            'High energy is easier to guide than to suppress. Channeling it now helps transition smoother later.',
        steps: <String>[
          'Start one active game (jumping, claps, or quick run).',
          'Set a short timer and do the activity together.',
          'Slow down with deep breaths for 30 seconds.',
        ],
      );
    }

    if (childState == ChildState.fussy) {
      return _SmartMomentContent(
        activityTitle: 'Comfort First Moment',
        subtitle: 'Best in the next 10-15 minutes',
        message:
            'When your child is fussy, regulation comes before instruction. First comfort, then reconnect.',
        steps: <String>[
          'Move to a low-noise corner.',
          'Offer a hug or sit close quietly.',
          'Use a soft phrase: "I am here with you."',
        ],
      );
    }

    if (childState == ChildState.tired) {
      return _SmartMomentContent(
        activityTitle: 'Wind-Down Moment',
        subtitle: 'Best in the next 10-15 minutes',
        message:
            'This is a good time to reduce stimulation. Gentle rhythm now supports better rest soon.',
        steps: <String>[
          'Dim lights and lower screen/sound input.',
          'Use a quiet activity like cuddling or soft music.',
          'Start the first bedtime cue you already use.',
        ],
      );
    }

    return _SmartMomentContent(
      activityTitle: 'Start With State Check',
      subtitle: 'Best in the next 2 minutes',
      message:
          'To guide the right activity, first update your child state in Family Meter.',
      steps: <String>[
        'Open Family Meter.',
        'Select your child current state.',
        'Tap Guide me now again.',
      ],
    );
  }

  _AgeBand _ageBandFromText(String childAge) {
    final String normalized = childAge.trim().toLowerCase();
    if (normalized.contains('0-3') || normalized.contains('0 - 3')) {
      return _AgeBand.zeroToThree;
    }
    if (normalized.contains('3-6') || normalized.contains('3 - 6')) {
      return _AgeBand.threeToSix;
    }
    return _AgeBand.sixToNine;
  }

  @override
  Future<void> close() {
    _childSubscription?.cancel();
    return super.close();
  }
}

enum _AgeBand { zeroToThree, threeToSix, sixToNine }

class _SmartMomentContent {
  _SmartMomentContent({
    required this.activityTitle,
    required this.subtitle,
    required this.message,
    required this.steps,
  });

  final String activityTitle;
  final String subtitle;
  final String message;
  final List<String> steps;
}
