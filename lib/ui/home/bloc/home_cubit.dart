import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/other/extra_methods.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/other/energy_bridge_notification_helper.dart';
import 'package:loving_brain/repo/energy_bridge_repo.dart';
import 'package:loving_brain/repo/user_repo.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/auth_repo.dart';
import 'home_state.dart';

/// Home dashboard: child state stream, Family Meter updates, parenting tip.
///
/// [updateFamilyMeterState] writes child state and starts/resets Energy Bridge
/// timer; local notifications are scheduled via [EnergyBridgeNotificationHelper].
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void init() {
    emit(HomeState(userModel: preferences.getUserModel()));
    _listenToUser();
    _updateStreak();
    _loadTodayParentingTip();
  }

  void changeProps({
    UserModel? userModel,
    ApiResultStatus? apiResultStatus,
    bool? moodLoggedForToday,
    ChildModel? childModel,
    String? todayParentingTip,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        moodLoggedForToday: moodLoggedForToday ?? state.moodLoggedForToday,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        todayParentingTip: todayParentingTip ?? state.todayParentingTip,
      ),
    );
  }

  StreamSubscription? profileSubscription;
  StreamSubscription? moodSubscription;
  StreamSubscription? childSubscription;

  void _listenToUser() {
    if ((state.userModel?.uid ?? "").isNotEmpty) {
      profileSubscription?.cancel();
      profileSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .snapshots()
          .listen((event) async {
            if (event.data() != null) {
              var userModel = UserModel.fromJson(event.data()!);
              await preferences.saveUserModel(userModel);
              _listenToChild(userModel.defaultChild);
              changeProps(userModel: userModel);
            }
          });

      moodSubscription?.cancel();
      moodSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .collection("mood")
          .snapshots()
          .listen((event) {
            if (event.docs.any(
              (element) => element.id == getStringDate(DateTime.now()),
            )) {
              changeProps(moodLoggedForToday: true);
            }
          });
    }
  }

  void _listenToChild(DocumentReference<Object?>? defaultChild) {
    childSubscription?.cancel();
    childSubscription = defaultChild?.snapshots().listen((event) {
      if (event.data() != null) {
        changeProps(
          childModel: ChildModel.fromJson(
            event.data() as Map<String, dynamic>,
            event.reference,
          ),
        );
      }
    });
  }

  void dispose() {
    profileSubscription?.cancel();
    moodSubscription?.cancel();
    childSubscription?.cancel();
  }

  Future<void> _updateStreak() async {
    if (state.userModel?.lastOpened != null) {
      if (!isSameDate(state.userModel!.lastOpened!, DateTime.now())) {
        Map<String, dynamic> request = {};
        if (isBeforeYesterday(state.userModel!.lastOpened!)) {
          request = {"streak": 1, "last_opened": DateTime.now()};
        } else {
          request = {
            "streak": (state.userModel?.streak ?? 0) + 1,
            "last_opened": DateTime.now(),
          };
        }
        final credential = await AuthRepo.instance.updateUserToFireStore(
          request: request,
        );
        changeProps(apiResultStatus: credential);
      }
    }
  }

  Future<void> _loadTodayParentingTip() async {
    changeProps(todayParentingTip: await UserRepo.instance.getTipOfTheDay());
  }

  /// Call from pull-to-refresh to reload tip and keep UI in sync.
  Future<void> refresh() async {
    await _loadTodayParentingTip();
  }

  Future<ApiResultStatus> updateFamilyMeterState({
    required ChildState childState,
  }) async {
    final String childId =
        state.childModel?.reference?.id ??
        state.userModel?.defaultChild?.id ??
        '';
    final String uid = state.userModel?.uid ?? '';
    if (childId.isEmpty || uid.isEmpty) {
      return ApiResultStatus.error(error: Exception('Please select child.'));
    }
    if (!(state.userModel?.isActiveLogger ?? true)) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.viewerCannotUpdateState.tr()),
      );
    }

    final ApiResultStatus stateResult = await ChildRepo.instance
        .updateChildState(
          childId: childId,
          childState: childState,
          actorUid: uid,
        );
    bool stateSaved = false;
    stateResult.whenOrNull(data: (dynamic data) => stateSaved = true);
    if (!stateSaved) {
      return stateResult;
    }

    if (childState == ChildState.highEnergy) {
      const int durationMinutes = 105;
      final ApiResultStatus timerResult = await EnergyBridgeRepo.instance
          .startTimer(
            childId: childId,
            actorUid: uid,
            durationMinutes: durationMinutes,
          );
      timerResult.whenOrNull(
        data: (_) async {
          await EnergyBridgeNotificationHelper.scheduleFireNotification(
            childId: childId,
            durationMinutes: durationMinutes,
            childName: state.childModel?.childName,
          );
        },
      );
      return timerResult;
    }
    final ApiResultStatus resetResult = await EnergyBridgeRepo.instance
        .resetTimer(childId: childId, actorUid: uid, reason: childState.key);
    resetResult.whenOrNull(
      data: (_) async {
        await EnergyBridgeNotificationHelper.cancelForChild(childId);
      },
    );
    return resetResult;
  }
}
