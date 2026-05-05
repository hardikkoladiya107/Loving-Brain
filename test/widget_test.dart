import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/age_utils.dart';

void main() {
  test('AgeUtils computes age in months from dob', () {
    final DateTime dob = DateTime.now().subtract(const Duration(days: 90));
    final int? ageInMonths = AgeUtils.ageInMonthsFromDob(dob);
    expect(ageInMonths, isNotNull);
    expect(ageInMonths, greaterThanOrEqualTo(2));
    expect(ageInMonths, lessThanOrEqualTo(3));
  });
}
