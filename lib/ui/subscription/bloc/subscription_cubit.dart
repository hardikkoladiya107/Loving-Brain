import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:loving_brain/ui/subscription/bloc/subscription_state.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../manager/subscription_manager/subscription_utils.dart';
import '../../../model/subscription/apple_subscription_model.dart';
import '../../../model/user_model.dart';
import '../../../other/extra_methods.dart';
import '../../../other/preferances.dart';
import '../../../repo/subscription_repo.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionState());

  void changeProps({
    int? selectedPlan,
    bool? isLoading,
    String? message,
    List<ProductDetails>? products,
    ProductDetails? selectedProduct,
    UserModel? userModel,
    List<SubsProductDetails>? subsProductDetails,
  }) {
    emit(
      state.copyWith(
        selectedPlan: selectedPlan ?? state.selectedPlan,
        isLoading: isLoading ?? state.isLoading,
        message: message ?? "",
        products: products ?? state.products,
        userModel: userModel ?? state.userModel,
        selectedProduct: selectedProduct ?? state.selectedProduct,
        subsProductDetails: subsProductDetails ?? state.subsProductDetails,
      ),
    );
  }

  void selectPlan({ProductDetails? selectedProduct}) {
    emit(state.copyWith(selectedProduct: selectedProduct));
  }

  ///
  ///
  ///
  ///

  StreamSubscription? _subscription;
  StreamSubscription? _userSubscription;
  final InAppPurchase inAppPurchase = InAppPurchase.instance;

  void _listenToSubscription() {
    _subscription?.cancel();
    _subscription = inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) {
        listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        error;
      },
    );
  }

  Future<void> init() async {
    emit(SubscriptionState(userModel: preferences.getUserModel()));
    try {
      _listenToUser();
      _listenToSubscription();
      _fetchCurrentSubscription();
      initStoreInfo();
      restorePurchase();
    } catch (e) {
      e;
    }
  }

  Future _fetchCurrentSubscription() async {
    if (Platform.isAndroid) {
      restorePurchase();
    } else {
      if (state.userModel?.productId != null &&
          state.userModel!.transactionId != null) {
        startLoading();
        await getIOSSubscriptionStatus(
          isForTest: true,
          productID: state.userModel!.productId!,
          transactionID: state.userModel!.transactionId!,
          userModel: state.userModel!,
        );
        stopLoading();
      }
    }
  }

  Future<void> _listenToUser() async {
    var uniqueId = await getUniqueDeviceId();
    _userSubscription?.cancel();
    _userSubscription = usersCollection.doc(uniqueId).snapshots().listen((
      event,
    ) async {
      if (event.data() != null) {
        var userModel = UserModel.fromJson(event.data(), event.reference.id);
        await preferences.saveUserModel(userModel);
        changeProps(userModel: userModel);
      }
    });
  }

  Future<void> listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailList,
  ) async {
    try {
      if (Platform.isAndroid && purchaseDetailList.isEmpty) {
        removeSubscription();
        return;
      }
      if (Platform.isAndroid) {
        List<PurchaseDetails> tempPurchaseDetailList = [];
        tempPurchaseDetailList.addAll(purchaseDetailList);
        tempPurchaseDetailList.sort(
          (a, b) => a.transactionDate!.compareTo(b.transactionDate!),
        );
        if (tempPurchaseDetailList.last.status == PurchaseStatus.pending) {
          startLoading();
        } else {
          if (tempPurchaseDetailList.last.status == PurchaseStatus.error ||
              tempPurchaseDetailList.last.status == PurchaseStatus.canceled) {
            stopLoading();
            if (tempPurchaseDetailList.last.error != null) {
              log('${tempPurchaseDetailList.last.error!}', name: 'IAPError');
            }
          } else if (tempPurchaseDetailList.last.status ==
                  PurchaseStatus.purchased ||
              tempPurchaseDetailList.last.status == PurchaseStatus.restored) {
            stopLoading();
            updateGoogleCloudStatus(tempPurchaseDetailList.last);
          }
          if (tempPurchaseDetailList.last.pendingCompletePurchase) {
            await inAppPurchase.completePurchase(tempPurchaseDetailList.last);
            stopLoading();
          }
        }
      } else if (Platform.isIOS) {
        if (purchaseDetailList.isNotEmpty) {
          List<PurchaseDetails> tempPurchaseDetailList = [];
          tempPurchaseDetailList.addAll(purchaseDetailList);
          tempPurchaseDetailList.sort(
            (a, b) => a.transactionDate!.compareTo(b.transactionDate!),
          );
          SKPaymentTransactionWrapper skProduct =
              (tempPurchaseDetailList.last as AppStorePurchaseDetails)
                  .skPaymentTransaction;
          String transactionIdentifier = skProduct.transactionIdentifier ?? "";
          startLoading();
          var snapshot = await usersCollection.get();
          var allUser = snapshot.docs
              .map((e) => UserModel.fromJson(e.data(), e.reference.id))
              .toList();
          if (transactionIdentifier.isNotEmpty &&
              !allUser.any(
                (element) => element.transactionId == transactionIdentifier,
              )) {
            await _updateCurrentUser({transactionIdKey: transactionIdentifier});
            if (state.userModel != null) {
              await getIOSSubscriptionStatus(
                isForTest: true,
                transactionID: transactionIdentifier,
                productID: tempPurchaseDetailList.last.productID,
                userModel: state.userModel!,
              );
            }
          }
        }
      }
      stopLoading();
    } catch (e) {
      if (kDebugMode) {
        print("Subscription Listen error is ---> $e");
      }
    }
  }

  Future<void> updateGoogleCloudStatus(PurchaseDetails purchaseDetails) async {
    startLoading();
    var tempPurchaseDetail = purchaseDetails as GooglePlayPurchaseDetails;
    String purchaseToken =
        tempPurchaseDetail.billingClientPurchase.purchaseToken;
    String packageName = tempPurchaseDetail.billingClientPurchase.packageName;
    String productId = tempPurchaseDetail.productID;
    var snapshot = await usersCollection.get();
    var allUser = snapshot.docs
        .map((e) => UserModel.fromJson(e.data(), e.reference.id))
        .toList();
    if (purchaseToken.isNotEmpty &&
        !allUser.any((element) => element.purchaseToken == purchaseToken)) {
      var accessTokenModel = await SubscriptionRepo().getAccessToken();
      if ((accessTokenModel?.accessToken ?? "").isNotEmpty) {
        var subscriptionStatus = await SubscriptionRepo()
            .checkSubscriptionStatus(
              token: accessTokenModel?.accessToken ?? "",
              subscriptionId: productId,
              purchaseToken: purchaseToken,
            );
        _updateCurrentUser({
          purchaseTokenKey: purchaseToken,
          packageNameKey: packageName,
          productIdKey: productId,
          subscriptionExpiry: subscriptionStatus?.expiryTimeMillis,
        });
      }
    }
    stopLoading();
  }

  Future<void> removeSubscription() async {
    _updateCurrentUser({productIdKey: null});
  }

  List<String> kIOSProductIds = [];

  void startLoading() {
    changeProps(isLoading: true);
  }

  void stopLoading() {
    changeProps(isLoading: false);
  }

  Future<void> initStoreInfo() async {
    try {
      changeProps(products: [], subsProductDetails: []);
      startLoading();
      final bool available = await inAppPurchase.isAvailable();
      if (!available) {
        changeProps(products: [], subsProductDetails: []);
        stopLoading();
        return;
      }
      if (Platform.isIOS) {
        try {
          final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
              inAppPurchase
                  .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
          await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
        } catch (e) {
          if (kDebugMode) {
            print(
              "IOS Erro"
              "r is -----> $e",
            );
          }
        }
      }

      final ProductDetailsResponse productDetailResponse = await inAppPurchase
          .queryProductDetails(kProductIds.toSet());
      if (productDetailResponse.error != null) {
        changeProps(products: productDetailResponse.productDetails);
        List<SubsProductDetails> subsProductDetails = [];
        for (var element in productDetailResponse.productDetails) {
          subsProductDetails.add(
            SubsProductDetails(
              id: element.id,
              name: element.title,
              description: element.description,
              price: element.price,
              currencySymbol: element.currencySymbol,
            ),
          );
        }
        changeProps(subsProductDetails: subsProductDetails);
        stopLoading();
        return;
      }

      List<ProductDetails> tempProducts = [];
      List<SubsProductDetails> tempSubsProductDetails = [];
      for (var id in kProductIds) {
        ProductDetails productDetails = productDetailResponse.productDetails
            .firstWhere((element) {
              return element.id == id;
            });
        tempProducts.add(productDetails);
        tempSubsProductDetails.add(
          SubsProductDetails(
            id: productDetails.id,
            name: productDetails.title,
            description: productDetails.description,
            price: productDetails.price,
            currencySymbol: productDetails.currencySymbol,
          ),
        );
      }

      changeProps(
        subsProductDetails: tempSubsProductDetails,
        products: tempProducts,
      );

      for (var element in state.products) {
        if (element is GooglePlayProductDetails) {
          final ProductDetailsWrapper product = element.productDetails;
          SubsProductDetails subsProductDetail = state.subsProductDetails
              .firstWhere((element) => element.id == product.productId);
          final List<SubscriptionOfferDetailsWrapper> offer =
              product.subscriptionOfferDetails!;
          for (var element1 in offer) {
            final List<PricingPhaseWrapper> pricingPhases =
                element1.pricingPhases;
            if (pricingPhases.length >= 2 &&
                pricingPhases.first.priceAmountMicros <
                    pricingPhases[1].priceAmountMicros) {
              subsProductDetail.price = pricingPhases[1].formattedPrice;
              subsProductDetail.currencySymbol = pricingPhases[1].formattedPrice
                  .substring(0, 1);
            }
          }
        }
      }
      stopLoading();
      return;
    } catch (e) {
      if (kDebugMode) {
        print("Init Subscription error is-----> $e");
      }
      stopLoading();
    }
  }

  void buyProduct() async {
    if (state.selectedProduct != null) {
      startLoading();
      try {
        late PurchaseParam purchaseParam;
        if (Platform.isAndroid) {
          purchaseParam = GooglePlayPurchaseParam(
            productDetails: state.selectedProduct!,
          );
          await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        } else {
          purchaseParam = PurchaseParam(productDetails: state.selectedProduct!);
          var transactions = await SKPaymentQueueWrapper().transactions();
          for (var skPaymentTransactionWrapper in transactions) {
            SKPaymentQueueWrapper().finishTransaction(
              skPaymentTransactionWrapper,
            );
          }
          await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        }
      } catch (e) {
        stopLoading();
      }
    } else {
      stopLoading();
      changeProps(message: LocaleKeys.somethingWentWrong.tr());
    }
  }

  Future<void> getIOSSubscriptionStatus({
    bool isForTest = false,
    required String transactionID,
    required String productID,
    required UserModel userModel,
  }) async {
    try {
      String jwtToken = TokenGenerator.generateJwtToken();
      String url = /*isForTest
          ? "https://api.storekit-sandbox.itunes.apple.com/inApps/v1/subscriptions/$transactionID?status=1"
          : */
          "https://api.storekit.itunes.apple.com/inApps/v1/transactions/$transactionID?status=1";
      var json = {
        "Authorization": "Bearer $jwtToken",
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      var response = await Dio().get(url, options: Options(headers: json));
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
          _updateCurrentUser({
            productIdKey: productID,
            originalTransactionIdKey: originalTransactionId,
            subscriptionStatusKey: subscriptionStatus,
            subscriptionExpiry: expiresDate.millisecondsSinceEpoch.toString(),
          });
        } else {
          _updateCurrentUser({
            productIdKey: null,
            originalTransactionIdKey: null,
            transactionIdKey: null,
            subscriptionStatusKey: -1,
          });
          FirebaseFirestore.instance.collection("errors").add({
            "type": "subscription",
            "type2": "cancelled",
            "error": response.statusCode.toString(),
            "detail": jsonEncode(response.data),
            "time": DateTime.now().toIso8601String(),
            "uId": userModel.referenceId,
          });
        }
      } else if (response.statusCode == 404) {
        _updateCurrentUser({
          productIdKey: null,
          originalTransactionIdKey: null,
          subscriptionStatusKey: null,
          transactionIdKey: null,
        });
        _addError({
          "type": "subscription",
          "error": response.statusCode.toString(),
          "detail": jsonEncode(response.data),
          "time": DateTime.now().toIso8601String(),
          "uId": userModel.referenceId,
        });
      } else {
        _updateCurrentUser({
          productIdKey: null,
          originalTransactionIdKey: null,
          subscriptionStatusKey: null,
          transactionIdKey: null,
        });
        _addError({
          "type": "subscription",
          "error": response.statusCode.toString(),
          "detail": jsonEncode(response.data),
          "time": DateTime.now().toIso8601String(),
          "uId": userModel.referenceId,
        });
      }
    } catch (e) {
      saveErrorToFirebase(e, userModel.referenceId);
    }
  }

  void saveErrorToFirebase(Object e, String? uid) {
    _addError({
      "type": "subscription",
      "error": e.toString(),
      "time": DateTime.now().toIso8601String(),
      "uId": uid,
    });
  }

  Future<void> restorePurchase() async {
    startLoading();
    await inAppPurchase.restorePurchases();
    stopLoading();
  }

  CollectionReference usersCollection = FirebaseFirestore.instance.collection(
    "users",
  );
  CollectionReference errorsCollection = FirebaseFirestore.instance.collection(
    "errors",
  );

  Future<void> _updateCurrentUser(Map<String, Object?> map) async {
    var uniqueId = await getUniqueDeviceId();
    await usersCollection.doc(uniqueId).update(map);
  }

  void _updateError(Map<String, Object?> map) async {
    var uniqueId = await getUniqueDeviceId();
    await errorsCollection.doc(uniqueId).update(map);
  }

  void _addError(Map<String, Object?> map) {
    errorsCollection.add(map);
  }
}
