import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../manager/subscription_manager/subscription_utils.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionState());

  void changeProps({
    int? selectedPlan,
    bool? isLoading,
    String? message,
    List<SubsProductDetails>? subsProductDetails,
    UserModel? userModel,
  }) {
    emit(
      state.copyWith(
        selectedPlan: selectedPlan ?? state.selectedPlan,
        isLoading: isLoading ?? state.isLoading,
        message: message ?? state.message,
        subsProductDetails: subsProductDetails ?? state.subsProductDetails,
        userModel: userModel ?? state.userModel,
      ),
    );
  }

  void init() {
    final UserModel? userModel = preferences.getUserModel();
    final List<SubsProductDetails> staticPlans = <SubsProductDetails>[
      SubsProductDetails(
        id: monthlyPlan,
        name: "Premium Monthly",
        description: "Stay flexible with monthly access.",
        price: "\$9.99",
        currencySymbol: "\$",
      ),
      SubsProductDetails(
        id: yearly,
        name: "Premium Annual",
        description: "Unlimited access to mood-based exercises.",
        price: "\$89.99",
        currencySymbol: "\$",
      ),
    ];
    changeProps(
      userModel: userModel,
      subsProductDetails: staticPlans,
      selectedPlan: 1,
    );
  }

  void selectPlan(int index) {
    if (index < 0 || index >= state.subsProductDetails.length) return;
    changeProps(selectedPlan: index);
  }
}
