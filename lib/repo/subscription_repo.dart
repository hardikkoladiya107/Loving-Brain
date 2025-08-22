import 'package:dio/dio.dart';

import '../model/subscription/access_token_model.dart';
import '../model/subscription/subscription_status_model.dart';

class SubscriptionRepo {
  SubscriptionRepo._();

  static final SubscriptionRepo _instance = SubscriptionRepo._();

  factory SubscriptionRepo() {
    return _instance;
  }

  static SubscriptionRepo get instance => _instance;

  static String grantType = "refresh_token";
  static String clientId = "";
  static String clientSecret = "";
  static String refreshToken = "";
  static String packageName = "";
  static String subscriptionId = " ";

  static String accessToken = "https://accounts.google.com/o/oauth2/token";

  Future<AccessTokenModel?> getAccessToken() async {
    try {
      var response = await Dio().post(
        options: Options(),
        SubscriptionRepo.accessToken,
        queryParameters: {
          "grant_type": grantType,
          "client_id": clientId,
          "client_secret": clientSecret,
          "refresh_token": refreshToken,
        },
      );
      if (response.statusCode == 200) {
        var accessTokenModel = AccessTokenModel.fromJson(response.data);
        return accessTokenModel;
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<SubscriptionStatusModel?> checkSubscriptionStatus({
    required String token,
    required String subscriptionId,
    required String purchaseToken,
  }) async {
    try {
      var response = await Dio().get(
        options: Options(),
        "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/$packageName/purchases/subscriptions/$subscriptionId/tokens/$purchaseToken",
        queryParameters: {"access_token": token},
      );
      return SubscriptionStatusModel.fromJson(response.data);
    } on DioException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
