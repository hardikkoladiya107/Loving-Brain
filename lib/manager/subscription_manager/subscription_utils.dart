import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

const String productIdKey = "product_id";
const String originalTransactionIdKey = "original_transaction_id";
const String subscriptionStatusKey = "subscription_status";
const String subscriptionExpiry = "subscription_expiry";
const String transactionIdKey = "transactionId";
const String purchaseTokenKey = "purchase_token";
const String packageNameKey = "package_name";

const monthlyPlan = "com.app.lovingbrain.monthly";
const yearly = "com.app.lovingbrain.yearly";

bool isForTest = true;

List<String> kProductIds = [monthlyPlan, yearly];

String iosSubscriptionStatusUrl(String transactionID) {
  return isForTest
      ? "https://api.storekit-sandbox.itunes.apple.com/inApps/v1/subscriptions/$transactionID?status=1"
      : "https://api.storekit.itunes.apple.com/inApps/v1/transactions/$transactionID?status=1";
}

const privacyPolicyUrl = "https://harmonious-moxie-ff5ad6.netlify.app";
const termsOfUseWebUrl = "https://chimerical-chimera-ccd130.netlify.app";

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
    try {
      DateTime currentUtc = DateTime.now().toUtc();
      double iat = currentUtc.millisecondsSinceEpoch / 1000;
      double exp =
          currentUtc.add(const Duration(minutes: 30)).millisecondsSinceEpoch /
          1000;
      Map<String, dynamic> header = {
        "alg": "ES256",
        "kid": "Z78L47CS46",
        "typ": "JWT",
      };
      Map<String, dynamic> payload = {
        "iss": "34d972c6-8242-4403-a237-6464de9f7243",
        "iat": iat,
        "exp": exp,
        "aud": "appstoreconnect-v1",
        "bid": "com.app.lovingbrain",
      };
      JWTKey jwtKey = ECPrivateKey('''
      -----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgVoNL4OiCJYXplkIX
dpfSij/wHGeZnqNPUN5Ok3yYwROgCgYIKoZIzj0DAQehRANCAAQ0XMfZXhYK89kf
ac4dIQo9yKSw5nYXtQ7/Ej8ktDN5Ih5TkjnS9stqeSYYNn1y2HjG0xLASdKLsaN+
Uw5v+T5U
-----END PRIVATE KEY-----''');
      JWT jwt = JWT(payload, header: header);
      String token = jwt.sign(jwtKey, algorithm: JWTAlgorithm.ES256);
      log("JWT TOKEN : $token");
      return token;
    } catch (e) {
      print("JWT TOKEN ERROR : $e");
      return "";
    }
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
