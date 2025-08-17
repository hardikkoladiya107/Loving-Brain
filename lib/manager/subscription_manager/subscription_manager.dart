import 'dart:async';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:loving_brain/manager/subscription_manager/subscription_utils.dart';

import '../../model/subscription/apple_subscription_model.dart';

class SubscriptionManager {
  SubscriptionManager._internal();

  static final SubscriptionManager _instance = SubscriptionManager._internal();

  static SubscriptionManager get instance => _instance;

  final InAppPurchase inAppPurchase = InAppPurchase.instance;

  StreamSubscription? _subscription;

  List<String> kIOSProductIds = [];

  void listenToSubscription(Function(dynamic purchaseDetailsList) onEvent) {
    _subscription?.cancel();
    _subscription = inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) {
        onEvent(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        error;
      },
    );
  }

  Future<void> initSubscription({
    required Function(Exception e) onError,
    required Function(IAPError e) onSubscriptionError,
    required Function(List<ProductDetails> products) onProductResponse,
  }) async {
    try {
      final bool available = await inAppPurchase.isAvailable();
      if (!available) {
        onProductResponse([]);
        return;
      }
      if (Platform.isIOS) {
        try {
          final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
              inAppPurchase
                  .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
          await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
        } on Exception catch (e) {
          onError(e);
          if (kDebugMode) {
            print("IOS Error is -----> $e");
          }
        }
      }
      final ProductDetailsResponse productDetailResponse = await inAppPurchase
          .queryProductDetails(kProductIds.toSet());
      if (productDetailResponse.error != null) {
        onSubscriptionError(productDetailResponse.error!);
        return;
      }
      onProductResponse(productDetailResponse.productDetails);
      return;
    } on Exception catch (e) {
      onError(e);
    }
  }

  Future<void> buyProduct({
    required ProductDetails product,
    required Function(Exception e) onError,
  }) async {
    try {
      PurchaseParam? purchaseParam;
      if (Platform.isAndroid) {
        purchaseParam = GooglePlayPurchaseParam(productDetails: product);
        await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        purchaseParam = PurchaseParam(productDetails: product);
        var transactions = await SKPaymentQueueWrapper().transactions();
        for (var skPaymentTransactionWrapper in transactions) {
          SKPaymentQueueWrapper().finishTransaction(
            skPaymentTransactionWrapper,
          );
        }
        await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } on Exception catch (e) {
      onError(e);
    }
  }

  Future<void> restorePurchase() async {
    await inAppPurchase.restorePurchases();
  }

  Future<void> getIOSSubscriptionStatus({
    required String transactionID,
    required String productID,
    required Function(Map<String, dynamic> userRequest) subscriptionResponse,
    required Function(Exception e) onError,
  }) async {
    try {
      String jwtToken = TokenGenerator.generateJwtToken();
      var json = {
        "Authorization": "Bearer $jwtToken",
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      var response = await Dio().get(
        iosSubscriptionStatusUrl(transactionID),
        options: Options(headers: json),
      );
      if (response.statusCode == 200) {
        AppleSubscriptionModel appleSubscriptionModel =
            AppleSubscriptionModel.fromJson(response.data);
        if ((appleSubscriptionModel.resData ?? []).isNotEmpty &&
            (appleSubscriptionModel.resData?.first.lastTransactions ?? [])
                .isNotEmpty) {
          int subscriptionStatus =
              appleSubscriptionModel
                  .resData
                  ?.first
                  .lastTransactions
                  ?.first
                  .status ??
              0;
          String originalTransactionId =
              appleSubscriptionModel
                  .resData
                  ?.first
                  .lastTransactions
                  ?.first
                  .originalTransactionId ??
              "";
          var signedTransactionInfo =
              appleSubscriptionModel
                  .resData
                  ?.first
                  .lastTransactions
                  ?.first
                  .signedTransactionInfo ??
              "";
          var decodeData = JWT.decode(signedTransactionInfo);
          var payload = decodeData.payload;
          DateTime expiresDate = DateTime.fromMillisecondsSinceEpoch(
            payload['expiresDate'],
          );
          subscriptionResponse({
            productIdKey: productID,
            originalTransactionIdKey: originalTransactionId,
            subscriptionStatusKey: subscriptionStatus,
            subscriptionExpiry: expiresDate.millisecondsSinceEpoch.toString(),
          });
        } else {
          subscriptionResponse({
            productIdKey: null,
            originalTransactionIdKey: null,
            transactionIdKey: null,
            subscriptionStatusKey: -1,
          });
        }
      } else if (response.statusCode == 404) {
        subscriptionResponse({
          productIdKey: null,
          originalTransactionIdKey: null,
          subscriptionStatusKey: null,
          transactionIdKey: null,
        });
      } else {
        subscriptionResponse({
          productIdKey: null,
          originalTransactionIdKey: null,
          subscriptionStatusKey: null,
          transactionIdKey: null,
        });
      }
    } on Exception catch (e) {
      onError(e);
    }
  }
}
