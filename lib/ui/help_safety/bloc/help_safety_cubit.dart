import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

import 'help_safety_state.dart';

/// Cubit for Screen 63 (Help & Safety).
/// Conforms to AGENTS.md §4.2.
class HelpSafetyCubit extends Cubit<HelpSafetyState> {
  HelpSafetyCubit() : super(const HelpSafetyState());

  void reset() {
    emit(const HelpSafetyState());
  }

  void init() {
    final UserModel? user = preferences.getUserModel();
    final String location = (user?.location ?? '').toLowerCase();
    String emergency = '911';

    if (location.contains('dubai') ||
        location.contains('uae') ||
        location.contains('emirates')) {
      emergency = '999';
    } else if (location.contains('uk') ||
        location.contains('united kingdom') ||
        location.contains('london') ||
        location.contains('britain')) {
      emergency = '999';
    } else if (location.contains('india') || location == 'in') {
      emergency = '112';
    } else if (location.contains('australia') ||
        location.contains('sydney') ||
        location.contains('melbourne')) {
      emergency = '000';
    } else if (location.contains('europe') ||
        location.contains('france') ||
        location.contains('germany') ||
        location.contains('spain') ||
        location.contains('italy')) {
      emergency = '112';
    }

    emit(HelpSafetyState(emergencyPhone: emergency));
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
