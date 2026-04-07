

class AccessTokenModel {
  AccessTokenModel({
      String? accessToken, 
      num? expiresIn, 
      String? scope, 
      String? tokenType,}){
    _accessToken = accessToken;
    _expiresIn = expiresIn;
    _scope = scope;
    _tokenType = tokenType;
}

  AccessTokenModel.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _expiresIn = json['expires_in'];
    _scope = json['scope'];
    _tokenType = json['token_type'];
  }
  String? _accessToken;
  num? _expiresIn;
  String? _scope;
  String? _tokenType;
AccessTokenModel copyWith({  String? accessToken,
  num? expiresIn,
  String? scope,
  String? tokenType,
}) => AccessTokenModel(  accessToken: accessToken ?? _accessToken,
  expiresIn: expiresIn ?? _expiresIn,
  scope: scope ?? _scope,
  tokenType: tokenType ?? _tokenType,
);
  String? get accessToken => _accessToken;
  num? get expiresIn => _expiresIn;
  String? get scope => _scope;
  String? get tokenType => _tokenType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['expires_in'] = _expiresIn;
    map['scope'] = _scope;
    map['token_type'] = _tokenType;
    return map;
  }

}