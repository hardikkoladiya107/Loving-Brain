import 'dart:convert';

class SubscriptionStatusModel {
  SubscriptionStatusModel({
      String? startTimeMillis, 
      String? expiryTimeMillis, 
      bool? autoRenewing, 
      String? priceCurrencyCode, 
      String? priceAmountMicros, 
      String? countryCode, 
      String? developerPayload, 
      num? cancelReason, 
      String? orderId, 
      num? purchaseType, 
      num? acknowledgementState, 
      String? kind,}){
    _startTimeMillis = startTimeMillis;
    _expiryTimeMillis = expiryTimeMillis;
    _autoRenewing = autoRenewing;
    _priceCurrencyCode = priceCurrencyCode;
    _priceAmountMicros = priceAmountMicros;
    _countryCode = countryCode;
    _developerPayload = developerPayload;
    _cancelReason = cancelReason;
    _orderId = orderId;
    _purchaseType = purchaseType;
    _acknowledgementState = acknowledgementState;
    _kind = kind;
}

  SubscriptionStatusModel.fromJson(dynamic json) {
    _startTimeMillis = json['startTimeMillis'];
    _expiryTimeMillis = json['expiryTimeMillis'];
    _autoRenewing = json['autoRenewing'];
    _priceCurrencyCode = json['priceCurrencyCode'];
    _priceAmountMicros = json['priceAmountMicros'];
    _countryCode = json['countryCode'];
    _developerPayload = json['developerPayload'];
    _cancelReason = json['cancelReason'];
    _orderId = json['orderId'];
    _purchaseType = json['purchaseType'];
    _acknowledgementState = json['acknowledgementState'];
    _kind = json['kind'];
  }
  String? _startTimeMillis;
  String? _expiryTimeMillis;
  bool? _autoRenewing;
  String? _priceCurrencyCode;
  String? _priceAmountMicros;
  String? _countryCode;
  String? _developerPayload;
  num? _cancelReason;
  String? _orderId;
  num? _purchaseType;
  num? _acknowledgementState;
  String? _kind;
SubscriptionStatusModel copyWith({  String? startTimeMillis,
  String? expiryTimeMillis,
  bool? autoRenewing,
  String? priceCurrencyCode,
  String? priceAmountMicros,
  String? countryCode,
  String? developerPayload,
  num? cancelReason,
  String? orderId,
  num? purchaseType,
  num? acknowledgementState,
  String? kind,
}) => SubscriptionStatusModel(  startTimeMillis: startTimeMillis ?? _startTimeMillis,
  expiryTimeMillis: expiryTimeMillis ?? _expiryTimeMillis,
  autoRenewing: autoRenewing ?? _autoRenewing,
  priceCurrencyCode: priceCurrencyCode ?? _priceCurrencyCode,
  priceAmountMicros: priceAmountMicros ?? _priceAmountMicros,
  countryCode: countryCode ?? _countryCode,
  developerPayload: developerPayload ?? _developerPayload,
  cancelReason: cancelReason ?? _cancelReason,
  orderId: orderId ?? _orderId,
  purchaseType: purchaseType ?? _purchaseType,
  acknowledgementState: acknowledgementState ?? _acknowledgementState,
  kind: kind ?? _kind,
);
  String? get startTimeMillis => _startTimeMillis;
  String? get expiryTimeMillis => _expiryTimeMillis;
  bool? get autoRenewing => _autoRenewing;
  String? get priceCurrencyCode => _priceCurrencyCode;
  String? get priceAmountMicros => _priceAmountMicros;
  String? get countryCode => _countryCode;
  String? get developerPayload => _developerPayload;
  num? get cancelReason => _cancelReason;
  String? get orderId => _orderId;
  num? get purchaseType => _purchaseType;
  num? get acknowledgementState => _acknowledgementState;
  String? get kind => _kind;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['startTimeMillis'] = _startTimeMillis;
    map['expiryTimeMillis'] = _expiryTimeMillis;
    map['autoRenewing'] = _autoRenewing;
    map['priceCurrencyCode'] = _priceCurrencyCode;
    map['priceAmountMicros'] = _priceAmountMicros;
    map['countryCode'] = _countryCode;
    map['developerPayload'] = _developerPayload;
    map['cancelReason'] = _cancelReason;
    map['orderId'] = _orderId;
    map['purchaseType'] = _purchaseType;
    map['acknowledgementState'] = _acknowledgementState;
    map['kind'] = _kind;
    return map;
  }

}