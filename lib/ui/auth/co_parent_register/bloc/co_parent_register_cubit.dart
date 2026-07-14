import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';

import '../../../../generated/locale_keys.g.dart';
import 'co_parent_register_state.dart';

/// Registers a new co-parent account (password only) and accepts the invitation.
class CoParentRegisterCubit extends Cubit<CoParentRegisterState> {
  CoParentRegisterCubit() : super(const CoParentRegisterState());

  void init() {
    emit(const CoParentRegisterState());
  }

  void changeProps({
    String? password,
    String? confirmPassword,
    String? passwordError,
    String? confirmPasswordError,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isTermsAccepted,
    ApiResultStatus? apiResultStatus,
    bool? isSubmitting,
  }) {
    emit(
      state.copyWith(
        password: password ?? state.password,
        confirmPassword: confirmPassword ?? state.confirmPassword,
        passwordError: passwordError ?? state.passwordError,
        confirmPasswordError:
            confirmPasswordError ?? state.confirmPasswordError,
        obscurePassword: obscurePassword ?? state.obscurePassword,
        obscureConfirmPassword:
            obscureConfirmPassword ?? state.obscureConfirmPassword,
        isTermsAccepted: isTermsAccepted ?? state.isTermsAccepted,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        isSubmitting: isSubmitting ?? state.isSubmitting,
      ),
    );
  }

  bool _validate() {
    bool valid = true;

    if (state.password.trim().isEmpty) {
      changeProps(passwordError: LocaleKeys.pleaseEnterPassword.tr());
      valid = false;
    } else if (state.password.length < 6) {
      changeProps(passwordError: LocaleKeys.passwordShouldBeMoreLetters.tr());
      valid = false;
    } else {
      changeProps(passwordError: '');
    }

    if (state.confirmPassword.trim().isEmpty) {
      changeProps(
        confirmPasswordError: LocaleKeys.pleaseEnterConfirmPassword.tr(),
      );
      valid = false;
    } else if (state.password.trim() != state.confirmPassword.trim()) {
      changeProps(
        confirmPasswordError: LocaleKeys.passwordAndConfirmPasswordShouldSame
            .tr(),
      );
      valid = false;
    } else {
      changeProps(confirmPasswordError: '');
    }

    if (!state.isTermsAccepted) {
      changeProps(
        apiResultStatus: ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseAcceptTermsAndConditions.tr()),
        ),
      );
      valid = false;
    }

    return valid;
  }

  /// Creates Firebase Auth + Firestore user, then accepts the co-parent invitation.
  Future<void> register({
    required String email,
    required String invitationId,
  }) async {
    if (!_validate()) {
      return;
    }

    changeProps(apiResultStatus: ApiResultStatus.loading(), isSubmitting: true);

    // Step 1 — create the Firebase account for the invited email.
    final ApiResultStatus createResult = await AuthRepo.instance
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: state.password.trim(),
        );

    bool accountCreated = false;
    createResult.whenOrNull(data: (_) => accountCreated = true);

    if (!accountCreated) {
      changeProps(apiResultStatus: createResult, isSubmitting: false);
      return;
    }

    await preferences.putBool(SharedPreference.isLogin, true);

    // Step 2 — link shared children via the invitation (see CoParentRepo.addUserAsCoParent).
    final ApiResultStatus acceptResult = await CoParentRepo.instance
        .addUserAsCoParent(invitationId);

    bool acceptSucceeded = false;
    acceptResult.whenOrNull(data: (_) => acceptSucceeded = true);

    // Keep pending invitation if accept failed so the user can retry after login.
    if (acceptSucceeded) {
      await PendingInvitationManager.clear();
    } else {
      await PendingInvitationManager.save(
        invitationId: invitationId,
        invitationEmail: email.trim(),
      );
    }

    changeProps(apiResultStatus: acceptResult, isSubmitting: false);
  }
}
