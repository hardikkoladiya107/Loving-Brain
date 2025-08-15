class AppleSubscriptionModel {
  String? environment;
  String? bundleId;
  List<ResData>? resData;

  AppleSubscriptionModel({
    this.environment,
    this.bundleId,
    this.resData,
  });

  factory AppleSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      AppleSubscriptionModel(
        environment: json["environment"],
        bundleId: json["bundleId"],
        resData: json["data"] == null
            ? []
            : List<ResData>.from(json["data"]!.map((x) => ResData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "environment": environment,
        "bundleId": bundleId,
        "data": resData == null
            ? []
            : List<dynamic>.from(resData!.map((x) => x.toJson())),
      };
}

class ResData {
  String? subscriptionGroupIdentifier;
  List<LastTransaction>? lastTransactions;

  ResData({
    this.subscriptionGroupIdentifier,
    this.lastTransactions,
  });

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        subscriptionGroupIdentifier: json["subscriptionGroupIdentifier"],
        lastTransactions: json["lastTransactions"] == null
            ? []
            : List<LastTransaction>.from(json["lastTransactions"]!
                .map((x) => LastTransaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subscriptionGroupIdentifier": subscriptionGroupIdentifier,
        "lastTransactions": lastTransactions == null
            ? []
            : List<dynamic>.from(lastTransactions!.map((x) => x.toJson())),
      };
}

class LastTransaction {
  String? originalTransactionId;
  int? status;
  String? signedTransactionInfo;
  String? signedRenewalInfo;

  LastTransaction({
    this.originalTransactionId,
    this.status,
    this.signedTransactionInfo,
    this.signedRenewalInfo,
  });

  factory LastTransaction.fromJson(Map<String, dynamic> json) =>
      LastTransaction(
        originalTransactionId: json["originalTransactionId"],
        status: json["status"],
        signedTransactionInfo: json["signedTransactionInfo"],
        signedRenewalInfo: json["signedRenewalInfo"],
      );

  Map<String, dynamic> toJson() => {
        "originalTransactionId": originalTransactionId,
        "status": status,
        "signedTransactionInfo": signedTransactionInfo,
        "signedRenewalInfo": signedRenewalInfo,
      };
}
