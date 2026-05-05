class AgeUtils {
  AgeUtils._();

  static int? ageInMonthsFromDob(DateTime? dob) {
    if (dob == null) {
      return null;
    }
    final DateTime now = DateTime.now();
    if (dob.isAfter(now)) {
      return null;
    }
    final int days = now.difference(dob).inDays;
    return (days / 30).floor();
  }

  static int ageInMonthsFromLegacyText(String legacyAgeText) {
    final String normalized = legacyAgeText.trim().toLowerCase();
    if (normalized.contains('0-3') || normalized.contains('0 - 3')) {
      return 18;
    }
    if (normalized.contains('3-6') || normalized.contains('3 - 6')) {
      return 54;
    }
    if (normalized.contains('6-9') || normalized.contains('6 - 9')) {
      return 90;
    }
    return 0;
  }

  static int resolvedAgeInMonths({
    required DateTime? dob,
    required String legacyAgeText,
  }) {
    final int? fromDob = ageInMonthsFromDob(dob);
    if (fromDob != null) {
      return fromDob;
    }
    return ageInMonthsFromLegacyText(legacyAgeText);
  }

  static String ageLabelFromMonths(int ageInMonths) {
    if (ageInMonths <= 0) {
      return '';
    }
    if (ageInMonths < 24) {
      return '$ageInMonths months';
    }
    final int years = ageInMonths ~/ 12;
    final int remainingMonths = ageInMonths % 12;
    if (remainingMonths == 0) {
      return '$years years';
    }
    return '$years years $remainingMonths months';
  }
}
