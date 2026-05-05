import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/age_utils.dart';

void main() {
  group('AgeUtils', () {
    test('resolvedAgeInMonths prefers dob when available', () {
      final DateTime dob = DateTime.now().subtract(const Duration(days: 370));
      final int ageInMonths = AgeUtils.resolvedAgeInMonths(
        dob: dob,
        legacyAgeText: '6-9 years',
      );

      expect(ageInMonths, greaterThanOrEqualTo(12));
      expect(ageInMonths, lessThan(15));
    });

    test('falls back to legacy age text when dob is missing', () {
      final int ageInMonths = AgeUtils.resolvedAgeInMonths(
        dob: null,
        legacyAgeText: '3-6 years',
      );

      expect(ageInMonths, 54);
    });
  });
}
