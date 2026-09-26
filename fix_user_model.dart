import 'dart:io';

void main() {
  final file = File('lib/model/user_model.dart');
  var content = file.readAsStringSync();
  
  // 1. Add fields
  if (!content.contains('_preferredLanguage')) {
    content = content.replaceFirst(
      '  String? _partnerUserId;',
      '''  String? _partnerUserId;
  String? _preferredLanguage;
  String? _location;
  Map<String, dynamic>? _originalJson;'''
    );
  }

  // 2. Add to constructor
  if (!content.contains('preferredLanguage,')) {
    content = content.replaceFirst(
      '    String? partnerUserId,',
      '''    String? partnerUserId,
    String? preferredLanguage,
    String? location,'''
    );
    content = content.replaceFirst(
      '    _partnerUserId = partnerUserId;',
      '''    _partnerUserId = partnerUserId;
    _preferredLanguage = preferredLanguage;
    _location = location;'''
    );
  }

  // 3. Add getters
  if (!content.contains('get preferredLanguage')) {
    content = content.replaceFirst(
      '  String? get partnerUserId => _partnerUserId;',
      '''  String? get partnerUserId => _partnerUserId;
  String? get preferredLanguage => _preferredLanguage;
  String? get location => _location;
  Map<String, dynamic>? get jsonObject => _originalJson;'''
    );
  }

  // 4. Parse from JSON
  if (!content.contains('_preferredLanguage = jsonObject[')) {
    content = content.replaceFirst(
      '''    _partnerUserId = jsonObject['partner_user_id'] as String?;''',
      '''    _partnerUserId = jsonObject['partner_user_id'] as String?;
    _preferredLanguage = jsonObject['preferred_language']?.toString();
    _location = jsonObject['location']?.toString();
    _originalJson = jsonObject;'''
    );
  }

  // 5. Add to toJson
  if (!content.contains('''map['preferred_language'] = _preferredLanguage;''')) {
    content = content.replaceFirst(
      '''    map['partner_user_id'] = _partnerUserId;''',
      '''    map['partner_user_id'] = _partnerUserId;
    map['preferred_language'] = _preferredLanguage;
    map['location'] = _location;'''
    );
  }

  file.writeAsStringSync(content);
}
