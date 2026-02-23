import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/child_repo.dart';

import 'manage_children_state.dart';

class ManageChildrenCubit extends Cubit<ManageChildrenState> {
  ManageChildrenCubit() : super(const ManageChildrenState());

  void init() {
    changeProps(
      userModel: preferences.getUserModel(),
      loadStatus: ApiResultStatus.loading(),
    );
    _loadChildren();
  }

  void changeProps({
    UserModel? userModel,
    List<ChildModel>? children,
    ApiResultStatus? loadStatus,
    ApiResultStatus? setDefaultStatus,
    ApiResultStatus? deleteChildStatus,
  }) {
    emit(state.copyWith(
      userModel: userModel ?? state.userModel,
      children: children ?? state.children,
      loadStatus: loadStatus ?? ApiResultStatus.initial(),
      setDefaultStatus: setDefaultStatus ??   ApiResultStatus.initial(),
      deleteChildStatus: deleteChildStatus ?? ApiResultStatus.initial(),
    ));
  }

  Future<void> _loadChildren() async {
    final List<String>? ids = state.userModel?.children
        ?.map((e) => e.id)
        .whereType<String>()
        .toList();
    if (ids == null || ids.isEmpty) {
      changeProps(
        children: <ChildModel>[],
        loadStatus: ApiResultStatus.data(data: <ChildModel>[]),
      );
      return;
    }
    final ApiResultStatus<List<ChildModel>> result =
        await ChildRepo.instance.getChildren(childrenIds: ids);
    result.whenOrNull(
      data: (List<ChildModel> list) {
        changeProps(
          children: list,
          loadStatus: ApiResultStatus.data(data: list),
        );
      },
      error: (Exception e) {
        changeProps(loadStatus: ApiResultStatus.error(error: e));
      },
    );
  }

  Future<void> setDefaultChild(ChildModel child) async {
    final DocumentReference<Object?>? ref = child.reference;
    if (ref == null) return;
    changeProps(setDefaultStatus: ApiResultStatus.loading());
    final ApiResultStatus<UserModel> result =
        await AuthRepo.instance.setDefaultChild(ref);
    result.whenOrNull(
      data: (UserModel user) {
        changeProps(
          userModel: user,
          setDefaultStatus: ApiResultStatus.data(data: user),
        );
      },
      error: (Exception e) {
        changeProps(setDefaultStatus: ApiResultStatus.error(error: e));
      },
    );
  }

  bool isDefaultChild(ChildModel child) {
    final String? defaultId = state.userModel?.defaultChild?.id;
    return defaultId != null &&
        defaultId.isNotEmpty &&
        child.reference?.id == defaultId;
  }

  Future<void> deleteChild(ChildModel child) async {
    final DocumentReference<Object?>? ref = child.reference;
    if (ref == null) return;
    changeProps(deleteChildStatus: ApiResultStatus.loading());
    final ApiResultStatus<UserModel> result =
        await AuthRepo.instance.removeChildFromUser(
      childId: ref.id,
      childRef: ref,
    );
    result.whenOrNull(
      data: (UserModel user) {
        changeProps(
          userModel: user,
          children: state.children.where((c) => c.reference?.id != ref.id).toList(),
          deleteChildStatus: ApiResultStatus.data(data: user),
        );
      },
      error: (Exception e) {
        changeProps(deleteChildStatus: ApiResultStatus.error(error: e));
      },
    );
  }
}
