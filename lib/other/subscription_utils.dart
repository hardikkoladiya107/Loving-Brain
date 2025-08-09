import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

const monthlyPlan = "com.app.mind_momentsx.monthly";
const yearly = "com.app.mind_momentsx.yearly";
List<String> kProductIds = [monthlyPlan, yearly];

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
