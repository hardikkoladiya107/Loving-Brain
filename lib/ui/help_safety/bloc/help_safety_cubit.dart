import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';

import 'help_safety_state.dart';

/// Cubit for Screen 63 (Help & Safety).
/// Conforms to AGENTS.md §4.2.
class HelpSafetyCubit extends Cubit<HelpSafetyState> {
  HelpSafetyCubit() : super(const HelpSafetyState());

  void init() {
    emit(const HelpSafetyState());
  }

  void changeProps({
    bool? isLoading,
    String? supportEmail,
    String? faqUrl,
    String? emergencyPhone,
    ApiResultStatus? actionStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        supportEmail: supportEmail ?? state.supportEmail,
        faqUrl: faqUrl ?? state.faqUrl,
        emergencyPhone: emergencyPhone ?? state.emergencyPhone,
        actionStatus: actionStatus ?? ApiResultStatus.initial(),
      ),
    );
  }
}
