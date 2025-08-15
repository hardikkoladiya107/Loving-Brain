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

const monthlyPlan = "com.app.mind_momentsx.monthly";
const yearly = "com.app.mind_momentsx.yearly";

const privacyPolicyUrl = "https://harmonious-moxie-ff5ad6.netlify.app";
const termsOfUseWebUrl = "https://chimerical-chimera-ccd130.netlify.app";
const appUrl =
    "https://play.google.com/store/apps/details?id=com.app.mind_momentsx";
List<String> kProductIds = [monthlyPlan, yearly];

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
        "kid": "69JX4TBFF4",
        "typ": "JWT",
      };
      Map<String, dynamic> payload = {
        "iss": "3af2f7c0-31c7-4a27-a164-9da3d6acba4d",
        "iat": iat,
        "exp": exp,
        "aud": "appstoreconnect-v1",
        "bid": "com.app.dryads",
      };
      JWTKey jwtKey = ECPrivateKey('''
      -----BEGIN PRIVATE KEY-----
      MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgALq7kOMxTKMQPW2r
      5nOsZMPm4qAUeow1xPvQsc7/+5OgCgYIKoZIzj0DAQehRANCAARJxwcOHvW1JoAO
      17/JJII4hHGG4E1b9JlN1cDNkaWQe22V5MVqUJEYztCihlpG8xPETVG3mfe0f6Zg
      Li9VaN64
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
