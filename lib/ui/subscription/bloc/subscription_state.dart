import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../model/user_model.dart';
import '../other/subscription_utils.dart';

part 'subscription_state.freezed.dart';

@freezed
abstract class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    @Default(false) bool isLoading,
    @Default(0) int selectedPlan,
    @Default("") String message,
    @Default([]) List<ProductDetails> products,
    @Default([]) List<SubsProductDetails> subsProductDetails,
    ProductDetails? selectedProduct,
    UserModel? userModel,
  }) = _SubscriptionState;
}
