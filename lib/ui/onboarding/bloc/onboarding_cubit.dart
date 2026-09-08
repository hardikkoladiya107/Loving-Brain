import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../model/api_result_status.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void init() {
    emit(const OnboardingState());
  }

  void changeProps({
    int? currentPage,
    int? totalPages,
    String? parentName,
    String? parentRole,
    String? preferredLanguage,
    String? location,
    ApiResultStatus? completeStatus,
  }) {
    emit(
      state.copyWith(
        currentPage: currentPage ?? state.currentPage,
        totalPages: totalPages ?? state.totalPages,
        parentName: parentName ?? state.parentName,
        parentRole: parentRole ?? state.parentRole,
        preferredLanguage: preferredLanguage ?? state.preferredLanguage,
        location: location ?? state.location,
        completeStatus: completeStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void onPageChanged(int index) {
    changeProps(currentPage: index);
  }

  void updateParentName(String name) {
    changeProps(parentName: name);
  }

  void selectParentRole(String role) {
    changeProps(parentRole: role);
  }

  void selectPreferredLanguage(String language) {
    changeProps(preferredLanguage: language);
  }

  void updateLocation(String location) {
    changeProps(location: location);
  }

  Future<void> completeOnboarding() async {
    changeProps(completeStatus: ApiResultStatus.loading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      changeProps(completeStatus: ApiResultStatus.data(data: true));
    } catch (e) {
      changeProps(
        completeStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }
}
