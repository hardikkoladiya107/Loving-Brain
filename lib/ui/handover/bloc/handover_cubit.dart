import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/ui/handover/bloc/handover_state.dart';

class HandoverCubit extends Cubit<HandoverState> {
  HandoverCubit() : super(const HandoverState());

  void init() {
    emit(HandoverState(userModel: preferences.getUserModel()));
  }

  void changeProps({
    UserModel? userModel,
    ApiResultStatus? transferStatus,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        transferStatus: transferStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> transferToPartner() async {
    final String currentUid = state.userModel?.uid ?? '';
    final String partnerUid = state.userModel?.partnerUserId ?? '';
    if (currentUid.isEmpty || partnerUid.isEmpty) {
      changeProps(
        transferStatus: ApiResultStatus.error(
          error: Exception('No co-parent linked.'),
        ),
      );
      return;
    }
    if (!(state.userModel?.isActiveLogger ?? true)) {
      changeProps(
        transferStatus: ApiResultStatus.error(
          error: Exception('Only the active logger can hand over.'),
        ),
      );
      return;
    }
    changeProps(transferStatus: ApiResultStatus.loading());
    final ApiResultStatus result = await UserRepo.instance.transferActiveLogger(
      currentUid: currentUid,
      partnerUid: partnerUid,
    );
    result.whenOrNull(
      data: (_) async {
        final UserModel? refreshed = await _refreshUser(currentUid);
        changeProps(
          userModel: refreshed,
          transferStatus: ApiResultStatus.data(data: partnerUid),
        );
      },
      error: (Exception error) {
        changeProps(transferStatus: ApiResultStatus.error(error: error));
      },
    );
  }

  Future<UserModel?> _refreshUser(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> snap =
        await UserRepo.instance.userCollection.doc(uid).get();
    if (!snap.exists || snap.data() == null) {
      return state.userModel;
    }
    final Map<String, dynamic> data = snap.data()!;
    data['uid'] = uid;
    final UserModel user = UserModel.fromJson(data);
    await preferences.saveUserModel(user);
    return user;
  }
}
