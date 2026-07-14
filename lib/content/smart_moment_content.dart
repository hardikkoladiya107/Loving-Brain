import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:loving_brain/model/child_state_model.dart';

/// Age-banded Smart Moment copy from [assets/content/smart_moment_content.json].
class SmartMomentContentBundle {
  SmartMomentContentBundle({
    required this.activityTitle,
    required this.subtitle,
    required this.message,
    required this.steps,
  });

  final String activityTitle;
  final String subtitle;
  final String message;
  final List<String> steps;
}

class SmartMomentContent {
  SmartMomentContent._();

  static Map<String, dynamic>? _cachedRoot;

  static Future<void> _ensureLoaded() async {
    if (_cachedRoot != null) {
      return;
    }
    final String raw = await rootBundle.loadString(
      'assets/content/smart_moment_content.json',
    );
    _cachedRoot = jsonDecode(raw) as Map<String, dynamic>;
  }

  static String ageBandKey(int ageInMonths) {
    if (ageInMonths <= 36) {
      return '0_36';
    }
    if (ageInMonths <= 72) {
      return '36_72';
    }
    return '72_plus';
  }

  static String stateKey(ChildState? childState) {
    if (childState == null) {
      return 'unknown';
    }
    return childState.key;
  }

  static Future<SmartMomentContentBundle> resolve({
    required ChildState? childState,
    required int ageInMonths,
    required String childName,
  }) async {
    await _ensureLoaded();
    final Map<String, dynamic> root = _cachedRoot!;
    final Map<String, dynamic> states =
        root['states'] as Map<String, dynamic>;
    final String stateKeyValue = stateKey(childState);
    final String band = ageBandKey(ageInMonths);

    Map<String, dynamic>? stateNode =
        states[stateKeyValue] as Map<String, dynamic>?;
    stateNode ??= states['unknown'] as Map<String, dynamic>;

    Map<String, dynamic> bandNode =
        stateNode[band] as Map<String, dynamic>? ??
        stateNode['0_36'] as Map<String, dynamic>;

    final List<String> steps = (bandNode['steps'] as List<dynamic>)
        .cast<String>()
        .map((String step) => step.replaceAll('{childName}', childName))
        .toList();

    return SmartMomentContentBundle(
      activityTitle: bandNode['activityTitle'] as String,
      subtitle: bandNode['subtitle'] as String,
      message: (bandNode['message'] as String).replaceAll(
        '{childName}',
        childName,
      ),
      steps: steps,
    );
  }
}
