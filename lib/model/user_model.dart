import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    String? referenceId,
    String? platform,
    String? productId,
    String? originalTransactionId,
    String? subscriptionStatus,
    String? transactionId,
    String? purchaseToken,
    DateTime? freeTaskUseTime,
    DateTime? updatedDate,
  }) {
    _platform = platform;
    _productId = productId;
    _originalTransactionId = originalTransactionId;
    _subscriptionStatus = subscriptionStatus;
    _freeTaskUseTime = freeTaskUseTime;
    _updatedDate = updatedDate;
    _transactionId = transactionId;
    _referenceId = referenceId;
    _purchaseToken = purchaseToken;
  }

  UserModel.fromJson(
    dynamic jsonObject,
    String id, {
    bool fromConvert = false,
  }) {
    _referenceId = id;
    _platform = jsonObject['platform'];
    _productId = jsonObject['product_id'];
    _originalTransactionId = jsonObject['original_transaction_id'];
    _transactionId = jsonObject['transactionId'];
    _subscriptionStatus = jsonObject['subscription_status'];
    _purchaseToken = jsonObject['purchase_token'];

    if (fromConvert) {
      if (jsonObject['updated_date'] != null) {
        _updatedDate = DateTime.parse(jsonObject['updated_date']);
      }
    } else {
      if (jsonObject['updated_date'] != null) {
        _updatedDate = (jsonObject['updated_date'] as Timestamp).toDate();
      }
    }

    if (fromConvert) {
      if (jsonObject['free_task_use_time'] != null) {
        _freeTaskUseTime = DateTime.parse(jsonObject['free_task_use_time']);
      }
    } else {
      if (jsonObject['free_task_use_time'] != null) {
        _freeTaskUseTime = (jsonObject['free_task_use_time'] as Timestamp)
            .toDate();
      }
    }
  }

  String? _referenceId;
  String? _platform;
  String? _productId;
  String? _originalTransactionId;
  String? _subscriptionStatus;
  String? _transactionId;
  String? _purchaseToken;
  DateTime? _freeTaskUseTime;
  DateTime? _updatedDate;

  UserModel copyWith({
    String? referenceId,
    String? platform,
    String? productId,
    String? originalTransactionId,
    String? subscriptionStatus,
    String? transactionId,
    String? purchaseToken,
    DateTime? freeTaskUseTime,
    DateTime? updatedDate,
  }) {
    return UserModel(
      referenceId: referenceId ?? _referenceId,
      platform: platform ?? _platform,
      productId: productId ?? _productId,
      subscriptionStatus: subscriptionStatus ?? _subscriptionStatus,
      originalTransactionId: originalTransactionId ?? _originalTransactionId,
      freeTaskUseTime: freeTaskUseTime ?? _freeTaskUseTime,
      updatedDate: updatedDate ?? _updatedDate,
      transactionId: transactionId ?? _transactionId,
      purchaseToken: purchaseToken ?? _purchaseToken,
    );
  }

  String? get platform => _platform;

  String? get productId => _productId;

  String? get subscriptionStatus => _subscriptionStatus;

  String? get originalTransactionId => _originalTransactionId;

  String? get referenceId => _referenceId;

  String? get transactionId => _transactionId;

  String? get purchaseToken => _purchaseToken;

  DateTime? get updatedDate => _updatedDate;

  DateTime? get freeTaskUseTime => _freeTaskUseTime;

  Map<String, dynamic> toJson({
    bool forConvert = false,
    bool updateFreeTaskTime = true,
  }) {
    final map = <String, dynamic>{};
    map['id'] = _referenceId;
    map['platform'] = _platform;
    map['product_id'] = _productId;
    map['original_transaction_id'] = _originalTransactionId;
    map['subscription_status'] = _subscriptionStatus;
    map['transactionId'] = _transactionId;
    map['purchase_token'] = _purchaseToken;

    if (forConvert) {
      if (_updatedDate != null) {
        Timestamp ts = Timestamp.fromDate(_updatedDate!);
        map['updated_date'] = ts.toDate().toIso8601String();
      }
    } else {
      if (_updatedDate != null) {
        Timestamp ts = Timestamp.fromDate(_updatedDate!);
        map['updated_date'] = ts;
      }
    }

    if (updateFreeTaskTime) {
      if (forConvert) {
        if (_freeTaskUseTime != null) {
          Timestamp ts = Timestamp.fromDate(_freeTaskUseTime!);
          map['free_task_use_time'] = ts.toDate().toIso8601String();
        }
      } else {
        if (_freeTaskUseTime != null) {
          Timestamp ts = Timestamp.fromDate(_freeTaskUseTime!);
          map['free_task_use_time'] = ts;
        }
      }
    }

    return map;
  }
}
