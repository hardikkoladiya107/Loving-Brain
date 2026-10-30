import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

/// Centralized detector for acute safety concerns and medical emergencies.
/// Adheres to v2-doc Screen 70 (Safety Concern) and Rule 6.
class EmergencyDetector {
  EmergencyDetector._();

  static const List<String> _emergencyKeywords = <String>[
    'not breathing',
    'stopped breathing',
    'struggling to breathe',
    'struggles to breathe',
    'cannot breathe',
    'cant breathe',
    "can't breathe",
    'hard to breathe',
    'difficulty breathing',
    'trouble breathing',
    'gasping for air',
    'gasping',
    'turned blue',
    'turning blue',
    'blue lips',
    'blue face',
    'skin turned blue',
    'skin is blue',
    'cyanosis',
    'unresponsive',
    'unconscious',
    'passed out',
    'wont wake up',
    "won't wake up",
    'cannot wake',
    'cant wake',
    "can't wake",
    'not waking up',
    'loss of consciousness',
    'seizure',
    'convulsion',
    'convulsing',
    'shaking uncontrollably',
    'choking',
    'swallowed battery',
    'swallowed button battery',
    'swallowed coin',
    'swallowed poison',
    'swallowed bleach',
    'drank bleach',
    'drank poison',
    'ingested poison',
    'poisoning',
    'severe bleeding',
    'heavy bleeding',
    'gushing blood',
    'coughing blood',
    'vomiting blood',
    'head injury unconscious',
  ];

  static final List<RegExp> _emergencyPatterns = <RegExp>[
    RegExp(
      r'\b(not|cant|cannot|stopped|difficulty|trouble|struggl\w*)\s+(to\s+)?breath\w*\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\b(turn\w*|skin|lips|face)\s+(is\s+|are\s+)?blue\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\b(unresponsive|unconscious|convuls\w*|seizure|chok\w*)\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\b(swallow\w*|drank|ingest\w*)\b.*?\b(battery|poison|coin|magnet|object|chemical|bleach|detergent|medication)\b',
      caseSensitive: false,
    ),
  ];

  static const List<String> _clinicalKeywords = <String>[
    'high fever',
    'fever of',
    'fever over',
    'temperature of',
    'rash',
    'spots all over',
    'repeated vomiting',
    'keeps vomiting',
    'vomiting all day',
    'throwing up all day',
    'will not drink',
    "won't drink",
    'wont drink',
    'not drinking',
    'refusing fluids',
    'dehydrated',
    'dehydration',
    'ear pain',
    'earache',
    'pulling at ear',
    'stiff neck',
    'swollen glands',
    'persistent cough',
    'wheezing',
    'chest pain',
  ];

  static final List<RegExp> _clinicalPatterns = <RegExp>[
    RegExp(
      r'\b(fever|temperature)\b.{0,20}\b(10[2-9]|1[1-9]\d|[4-9]\d)\b',
      caseSensitive: false,
    ),
    RegExp(r'\bhigh\s+fever\b', caseSensitive: false),
    RegExp(
      r'\b(rash|spots)\b.{0,30}\b(body|face|chest|legs|arms|everywhere)\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\b(vomit\w*|throwing up)\b.{0,40}\b(repeat|again|all day|all night|won.?t stop)\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\b(won.?t|will not|not|refusing)\s+(drink|drinking|fluids|water|milk)\b',
      caseSensitive: false,
    ),
    RegExp(r'\bdehydra\w*\b', caseSensitive: false),
    RegExp(
      r'\b(ear\s*ache|ear\s*pain|pulling at (an |the )?ear)\b',
      caseSensitive: false,
    ),
  ];

  /// Returns true if the provided text indicates an acute clinical emergency.
  static bool isEmergency(String text) {
    final String clean = text.trim();
    if (clean.isEmpty) return false;

    final String rawLower = clean.toLowerCase();
    final String normalized = rawLower.replaceAll(RegExp(r'[^\w\s]'), '');

    for (final String keyword in _emergencyKeywords) {
      if (rawLower.contains(keyword) ||
          normalized.contains(keyword.replaceAll(RegExp(r'[^\w\s]'), ''))) {
        return true;
      }
    }

    for (final RegExp pattern in _emergencyPatterns) {
      if (pattern.hasMatch(clean)) {
        return true;
      }
    }

    return false;
  }

  /// Non-emergency but concerning health statements that must not get AI advice.
  static bool isConcerningHealth(String text) {
    final String clean = text.trim();
    if (clean.isEmpty) return false;
    if (isEmergency(clean)) return false;

    final String rawLower = clean.toLowerCase();
    final String normalized = rawLower.replaceAll(RegExp(r'[^\w\s]'), '');

    for (final String keyword in _clinicalKeywords) {
      if (rawLower.contains(keyword) ||
          normalized.contains(keyword.replaceAll(RegExp(r'[^\w\s]'), ''))) {
        return true;
      }
    }

    for (final RegExp pattern in _clinicalPatterns) {
      if (pattern.hasMatch(clean)) {
        return true;
      }
    }

    return false;
  }

  /// Region-aware emergency calling phone number string (e.g. 'tel:911', 'tel:112', 'tel:999')
  static String getEmergencyPhone() {
    final UserModel? user = preferences.getUserModel();
    final String location = (user?.location ?? '').toLowerCase();
    if (location.contains('uk') ||
        location.contains('united kingdom') ||
        location == 'gb') {
      return 'tel:999';
    }
    if (location.contains('india') ||
        location == 'in' ||
        location.contains('europe') ||
        location.contains('eu')) {
      return 'tel:112';
    }
    return 'tel:911';
  }

  /// Clean display digits for UI buttons (e.g. '911', '112', '999')
  static String getEmergencyDisplayNumber() {
    final String phone = getEmergencyPhone();
    return phone.replaceFirst('tel:', '');
  }
}
