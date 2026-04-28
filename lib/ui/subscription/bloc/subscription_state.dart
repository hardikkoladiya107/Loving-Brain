import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../manager/subscription_manager/subscription_utils.dart';
import '../../../model/user_model.dart';

part 'subscription_state.freezed.dart';

@freezed
abstract class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    @Default(false) bool isLoading,
    @Default(0) int selectedPlan,
    @Default("") String message,
    @Default([]) List<SubsProductDetails> subsProductDetails,
    UserModel? userModel,
  }) = _SubscriptionState;
}
