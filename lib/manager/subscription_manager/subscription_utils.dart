import 'package:flutter/foundation.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

const String productIdKey = "product_id";
const String originalTransactionIdKey = "original_transaction_id";
const String subscriptionStatusKey = "subscription_status";
const String subscriptionExpiry = "subscription_expiry";
const String transactionIdKey = "transactionId";
const String purchaseTokenKey = "purchase_token";
const String packageNameKey = "package_name";

const String monthlyPlan = "com.app.lovingbrain.monthly";
const String yearly = "com.app.lovingbrain.yearly";

final List<String> kProductIds = <String>[monthlyPlan, yearly];

/// Debug builds use the StoreKit sandbox host. Release builds use production.
/// Pass [sandbox] when the caller already knows the transaction environment.
String iosSubscriptionStatusUrl(String transactionID, {bool? sandbox}) {
  final bool useSandbox = sandbox ?? kDebugMode;
  final String host = useSandbox
      ? "https://api.storekit-sandbox.itunes.apple.com"
      : "https://api.storekit.itunes.apple.com";
  return "$host/inApps/v1/subscriptions/$transactionID";
}

const String privacyPolicyUrl =
    "https://loving-brain-legal.netlify.app/privacy_policy.html";
const String termsOfUseWebUrl =
    "https://loving-brain-legal.netlify.app/terms_and_conditions.html";

class SubsProductDetails {
  final String id;
  final String name;
  final String description;
  String price;
  String currencySymbol;

  SubsProductDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currencySymbol,
  });
}

class TokenGenerator {
  static String generateJwtToken() {
    // App Store Connect API JWT tokens require private keys that must only be held server-side.
    // Client-side receipt validation should query your secure backend.
    return "";
  }
}

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
