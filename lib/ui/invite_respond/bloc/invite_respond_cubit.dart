import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';

import 'invite_respond_state.dart';

class InviteRespondCubit extends Cubit<InviteRespondState> {
  InviteRespondCubit() : super(const InviteRespondState());

  void reset() {
    emit(const InviteRespondState());
  }

  void init({required String invitationId}) {
    emit(InviteRespondState(invitationId: invitationId.trim()));
    loadPreview();
  }

  void changeProps({
    String? invitationId,
    String? fromParentName,
    String? childNames,
    String? invitedEmailMasked,
    String? role,
    String? status,
    bool? isLoadingPreview,
    ApiResultStatus? previewStatus,
    ApiResultStatus? actionStatus,
  }) {
    emit(
      state.copyWith(
        invitationId: invitationId ?? state.invitationId,
        fromParentName: fromParentName ?? state.fromParentName,
        childNames: childNames ?? state.childNames,
        invitedEmailMasked: invitedEmailMasked ?? state.invitedEmailMasked,
        role: role ?? state.role,
        status: status ?? state.status,
        isLoadingPreview: isLoadingPreview ?? state.isLoadingPreview,
        previewStatus: previewStatus ?? ApiResultStatus.initial(),
        actionStatus: actionStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> loadPreview() async {
    final String id = state.invitationId.trim();
    if (id.isEmpty) {
      changeProps(
        previewStatus: ApiResultStatus.error(
          error: Exception('Missing invitation id'),
        ),
      );
      return;
    }
    changeProps(
      isLoadingPreview: true,
      previewStatus: const ApiResultStatus.loading(),
    );
    final ApiResultStatus result = await CoParentRepo.instance
        .getInvitationPreview(invitationId: id);
    result.whenOrNull(
      data: (dynamic data) {
        if (data is Map) {
          final String status = data['status']?.toString() ?? '';
          final String expiresAt = data['expiresAt']?.toString() ?? '';
          if (CoParentInvitationHelpers.isInvitationClosed(
            status: status,
            expiresAt: expiresAt,
          )) {
            changeProps(
              isLoadingPreview: false,
              status: status,
              previewStatus: ApiResultStatus.error(
                error: Exception(LocaleKeys.deepLinkInvitationInvalid.tr()),
              ),
            );
            return;
          }
          final List<dynamic> names = data['childNames'] is List
              ? data['childNames'] as List<dynamic>
              : <dynamic>[];
          changeProps(
            isLoadingPreview: false,
            fromParentName: data['fromParentName']?.toString() ?? '',
            childNames: names.map((dynamic e) => e.toString()).join(' & '),
            invitedEmailMasked: data['invitedEmailMasked']?.toString() ?? '',
            role: data['role']?.toString() ?? 'Co-Parent',
            status: data['status']?.toString() ?? '',
            previewStatus: result,
          );
        } else {
          changeProps(
            isLoadingPreview: false,
            previewStatus: ApiResultStatus.error(
              error: Exception('Invalid invitation preview'),
            ),
          );
        }
      },
      error: (Exception err) {
        changeProps(
          isLoadingPreview: false,
          previewStatus: ApiResultStatus.error(error: err),
        );
      },
    );
  }

  Future<void> accept() async {
    changeProps(actionStatus: const ApiResultStatus.loading());
    final ApiResultStatus result = await CoParentRepo.instance
        .addUserAsCoParent(state.invitationId);
    changeProps(actionStatus: result);
  }

  Future<void> reject() async {
    changeProps(actionStatus: const ApiResultStatus.loading());
    final ApiResultStatus result = await CoParentRepo.instance.rejectInvitation(
      invitationId: state.invitationId,
    );
    changeProps(actionStatus: result);
  }
}
