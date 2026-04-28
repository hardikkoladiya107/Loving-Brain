import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../model/api_result_status.dart';
import '../../../../../repo/auth_repo.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordState());

  void init() {
    emit(ForgotPasswordState());
  }

  void changeProps({
    String? emailAddress,
    String? emailAddressError,
    ApiResultStatus? apiResultStatus,
  }) {
    emit(
      state.copyWith(
        emailAddress: emailAddress ?? state.emailAddress,
        emailAddressError: emailAddressError ?? state.emailAddressError,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> performForgotPassword() async {
    if (_isValidate()) {
      changeProps(apiResultStatus: ApiResultStatus.loading());
      var apiResult = await AuthRepo.instance.sendPasswordResetEmail(
        email: state.emailAddress,
      );
      changeProps(apiResultStatus: apiResult);
    }
  }

  bool _isValidate() {
    if (state.emailAddress.trim().isEmpty ||
        !state.emailAddress.trim().isValidEmail) {
      if (state.emailAddress.trim().isEmpty) {
        changeProps(emailAddressError: LocaleKeys.pleaseEnterEmailAddress.tr());
      } else if (!state.emailAddress.trim().isValidEmail) {
        changeProps(emailAddressError: LocaleKeys.pleaseEnterValidEmail.tr());
      } else {
        changeProps(emailAddressError: "");
      }

      return false;
    }

    changeProps(emailAddressError: "");
    return true;
  }

  void clearFields() {
    changeProps(emailAddress: "", emailAddressError: "");
  }
}
