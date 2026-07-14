import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/content/smart_moment_content.dart';
import 'package:loving_brain/core/age_utils.dart';
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
    ) async {
      if (event.data() != null) {
        final ChildModel childModel = ChildModel.fromJson(
          event.data() as Map<String, dynamic>,
          event.reference,
        );
        await _applyContent(childModel: childModel);
      }
    });
  }

  Future<void> _applyContent({required ChildModel childModel}) async {
    final ChildState? childState = childModel.childState;
    final int ageInMonths = AgeUtils.resolvedAgeInMonths(
      dob: childModel.childDob,
      legacyAgeText: childModel.childAge ?? '',
    );
    final SmartMomentContentBundle content = await SmartMomentContent.resolve(
      childState: childState,
      ageInMonths: ageInMonths,
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
    final int ageInMonths = AgeUtils.resolvedAgeInMonths(
      dob: state.childModel?.childDob,
      legacyAgeText: state.childModel?.childAge ?? '',
    );
    changeProps(saveApiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus response = await ChildRepo.instance
        .saveSmartMomentEvent(
          childId: childId,
          actorUid: uid,
          stateAtTime: state.stateAtTime?.key ?? '',
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
