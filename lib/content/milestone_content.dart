import 'dart:convert';

import 'package:flutter/services.dart';

class MilestoneDefinition {
  MilestoneDefinition({
    required this.key,
    required this.chapter,
    required this.title,
    required this.ageRangeMonths,
    required this.whatThisMeans,
    required this.storyPrompt,
  });

  final String key;
  final int chapter;
  final String title;
  final String ageRangeMonths;
  final String whatThisMeans;
  final String storyPrompt;
}

class MilestoneContent {
  MilestoneContent._();

  static Map<String, dynamic>? _cachedRoot;

  static Future<void> _ensureLoaded() async {
    if (_cachedRoot != null) {
      return;
    }
    final String raw = await rootBundle.loadString(
      'assets/content/milestones.json',
    );
    _cachedRoot = jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<MilestoneDefinition> resolveForAge({
    required String childName,
    required String parentName,
    required int ageInMonths,
  }) async {
    await _ensureLoaded();
    final List<Map<String, dynamic>> items = _allItems();
    for (final Map<String, dynamic> item in items) {
      final String range = item['ageRangeMonths'] as String;
      if (_ageInRange(ageInMonths, range)) {
        return _fromJson(
          item,
          childName: childName,
          parentName: parentName,
          ageInMonths: ageInMonths,
        );
      }
    }
    return resolveDefault(
      childName: childName,
      parentName: parentName,
      ageInMonths: ageInMonths,
    );
  }

  static Future<MilestoneDefinition?> resolveByKey({
    required String milestoneKey,
    required String childName,
    required String parentName,
    required int ageInMonths,
  }) async {
    await _ensureLoaded();
    Map<String, dynamic>? item;
    for (final Map<String, dynamic> entry in _allItems()) {
      if (entry['key'] == milestoneKey) {
        item = entry;
        break;
      }
    }
    if (item == null) {
      return null;
    }
    return _fromJson(
      item,
      childName: childName,
      parentName: parentName,
      ageInMonths: ageInMonths,
    );
  }

  static Future<List<MilestoneDefinition>> catalogForAge({
    required String childName,
    required String parentName,
    required int ageInMonths,
  }) async {
    final List<MilestoneDefinition> all = await catalog(
      childName: childName,
      parentName: parentName,
      ageInMonths: ageInMonths,
    );
    final List<MilestoneDefinition> filtered = all
        .where((MilestoneDefinition m) {
          return _ageInRange(ageInMonths, m.ageRangeMonths) ||
              (ageInMonths - _parseRangeMidpoint(m.ageRangeMonths)).abs() <= 12;
        })
        .toList();
    if (filtered.isEmpty) {
      return all;
    }
    return filtered;
  }

  static int _parseRangeMidpoint(String range) {
    if (range.contains('-')) {
      final List<String> parts = range.split('-');
      return ((int.parse(parts[0]) + int.parse(parts[1])) / 2).round();
    }
    return int.parse(range.trim());
  }

  static Future<MilestoneDefinition> resolveDefault({
    required String childName,
    required String parentName,
    required int ageInMonths,
  }) async {
    await _ensureLoaded();
    final Map<String, dynamic> root = _cachedRoot!;
    final String defaultKey = root['defaultKey'] as String;
    final Map<String, dynamic> item = _allItems().firstWhere(
      (Map<String, dynamic> m) => m['key'] == defaultKey,
      orElse: () => _allItems().first,
    );
    return _fromJson(
      item,
      childName: childName,
      parentName: parentName,
      ageInMonths: ageInMonths,
    );
  }

  static Future<List<MilestoneDefinition>> catalog({
    required String childName,
    required String parentName,
    required int ageInMonths,
  }) async {
    await _ensureLoaded();
    return _allItems()
        .map(
          (Map<String, dynamic> item) => _fromJson(
            item,
            childName: childName,
            parentName: parentName,
            ageInMonths: ageInMonths,
          ),
        )
        .toList();
  }

  static List<Map<String, dynamic>> _allItems() {
    final List<dynamic> milestones = _cachedRoot!['milestones'] as List<dynamic>;
    return milestones.cast<Map<String, dynamic>>();
  }

  static bool _ageInRange(int ageInMonths, String range) {
    final String trimmed = range.trim();
    if (trimmed.contains('-')) {
      final List<String> parts = trimmed.split('-');
      final int minMonths = int.parse(parts[0].trim());
      final int maxMonths = int.parse(parts[1].trim());
      return ageInMonths >= minMonths && ageInMonths <= maxMonths;
    }
    final int target = int.parse(trimmed);
    return (ageInMonths - target).abs() <= 2;
  }

  static MilestoneDefinition _fromJson(
    Map<String, dynamic> item, {
    required String childName,
    required String parentName,
    required int ageInMonths,
  }) {
    String interpolate(String text) {
      return text
          .replaceAll('{childName}', childName)
          .replaceAll('{parentName}', parentName)
          .replaceAll('{ageMonths}', '$ageInMonths');
    }

    return MilestoneDefinition(
      key: item['key'] as String,
      chapter: (item['chapter'] as int?) ?? 1,
      title: item['title'] as String,
      ageRangeMonths: item['ageRangeMonths'] as String,
      whatThisMeans: interpolate(item['whatThisMeans'] as String),
      storyPrompt: interpolate(item['storyPrompt'] as String),
    );
  }
}
