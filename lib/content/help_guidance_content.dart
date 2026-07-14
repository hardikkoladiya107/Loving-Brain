import 'dart:convert';

import 'package:flutter/services.dart';

/// Loads Part 4 Help Guidance from [assets/content/part4_help_guidance.json].
///
/// Sprint 1 maps four UI problem keys to Part 4 problems; `too_fussy` falls back
/// to crying content for 0–6 months.
class HelpGuidanceContent {
  HelpGuidanceContent._();

  static Map<String, dynamic>? _cachedRoot;

  static Future<void> _ensureLoaded() async {
    if (_cachedRoot != null) {
      return;
    }
    final String raw = await rootBundle.loadString(
      'assets/content/part4_help_guidance.json',
    );
    _cachedRoot = jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Resolves age band from [ageInMonths] per Content Guide bands.
  static String ageBandKey(int ageInMonths) {
    if (ageInMonths <= 6) {
      return '0_6';
    }
    if (ageInMonths <= 18) {
      return '6_18';
    }
    return '18_36';
  }

  /// Returns all suggestions for a problem + age, sorted by suggestionIndex.
  static Future<List<HelpGuidanceSuggestion>> suggestionsFor({
    required String appProblemKey,
    required int ageInMonths,
    required String childName,
  }) async {
    await _ensureLoaded();
    final Map<String, dynamic> root = _cachedRoot!;
    final Map<String, dynamic> sprint1Mapping =
        root['sprint1Mapping'] as Map<String, dynamic>;

    String part4ProblemKey = appProblemKey;
    String ageBand = ageBandKey(ageInMonths);

    if (appProblemKey == 'too_fussy') {
      final Map<String, dynamic> fallback =
          sprint1Mapping['too_fussy'] as Map<String, dynamic>;
      part4ProblemKey = fallback['fallbackProblem'] as String;
      ageBand = fallback['fallbackAgeBand'] as String;
    } else {
      final dynamic mapped = sprint1Mapping[appProblemKey];
      if (mapped is String) {
        part4ProblemKey = mapped;
      }
    }

    final List<dynamic> problems = root['problems'] as List<dynamic>;
    final Map<String, dynamic>? problem = problems.cast<Map<String, dynamic>>().where(
      (Map<String, dynamic> p) => p['problemKey'] == part4ProblemKey,
    ).firstOrNull;

    if (problem == null) {
      return <HelpGuidanceSuggestion>[];
    }

    final List<dynamic> allSuggestions =
        problem['suggestions'] as List<dynamic>;
    List<Map<String, dynamic>> bandMatches = allSuggestions
        .cast<Map<String, dynamic>>()
        .where((Map<String, dynamic> s) => s['ageBand'] == ageBand)
        .toList();

    if (bandMatches.isEmpty) {
      bandMatches = allSuggestions.cast<Map<String, dynamic>>().toList();
    }

    bandMatches.sort(
      (Map<String, dynamic> a, Map<String, dynamic> b) =>
          (a['suggestionIndex'] as int).compareTo(b['suggestionIndex'] as int),
    );

    return bandMatches
        .map(
          (Map<String, dynamic> json) => HelpGuidanceSuggestion.fromJson(
            json,
            childName: childName,
          ),
        )
        .toList();
  }

  /// Test-only: reset cached JSON between tests.
  static void resetCacheForTests() {
    _cachedRoot = null;
  }
}

class HelpGuidanceSuggestion {
  const HelpGuidanceSuggestion({
    required this.suggestionIndex,
    required this.contextLine,
    required this.primaryAction,
    required this.steps,
    required this.fallbackText,
    required this.solutionId,
  });

  final int suggestionIndex;
  final String contextLine;
  final String primaryAction;
  final List<String> steps;
  final String fallbackText;
  final String solutionId;

  factory HelpGuidanceSuggestion.fromJson(
    Map<String, dynamic> json, {
    required String childName,
  }) {
    final List<dynamic> stepList =
        json['steps'] as List<dynamic>? ?? <dynamic>[];
    final List<String> stepInstructions = stepList
        .cast<Map<String, dynamic>>()
        .map(
          (Map<String, dynamic> step) => _interpolateChildName(
            step['instruction'] as String?,
            childName,
          ),
        )
        .where((String s) => s.isNotEmpty)
        .toList();

    final String? why = json['whyItIsHappening'] as String?;
    final String primary = stepInstructions.isNotEmpty
        ? stepInstructions.first
        : '';

    return HelpGuidanceSuggestion(
      suggestionIndex: json['suggestionIndex'] as int? ?? 1,
      contextLine: _interpolateChildName(why, childName),
      primaryAction: primary,
      steps: stepInstructions,
      fallbackText: _interpolateChildName(
        json['fallback'] as String?,
        childName,
      ),
      solutionId: 'suggestion_${json['suggestionIndex'] ?? 1}',
    );
  }
}

String _interpolateChildName(String? text, String childName) {
  return (text ?? '').replaceAll('{childName}', childName);
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }
    return iterator.current;
  }
}
