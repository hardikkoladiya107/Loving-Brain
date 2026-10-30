import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/emergency_detector.dart';

void main() {
  group('EmergencyDetector Tests (BUG-38 & Screen 70)', () {
    test('detects critical breathing emergencies', () {
      expect(
        EmergencyDetector.isEmergency('child is not breathing and turned blue'),
        isTrue,
      );
      expect(EmergencyDetector.isEmergency('baby stopped breathing'), isTrue);
      expect(
        EmergencyDetector.isEmergency('toddler struggles to breathe'),
        isTrue,
      );
      expect(EmergencyDetector.isEmergency('can not breathe'), isTrue);
      expect(EmergencyDetector.isEmergency('gasping for air'), isTrue);
    });

    test('detects skin discoloration and cyanosis emergencies', () {
      expect(EmergencyDetector.isEmergency('lips turned blue'), isTrue);
      expect(EmergencyDetector.isEmergency('skin is blue'), isTrue);
      expect(
        EmergencyDetector.isEmergency('cyanosis noted around mouth'),
        isTrue,
      );
    });

    test('detects unresponsiveness and seizures', () {
      expect(
        EmergencyDetector.isEmergency('baby is unresponsive and limp'),
        isTrue,
      );
      expect(
        EmergencyDetector.isEmergency('child had a seizure and won\'t wake up'),
        isTrue,
      );
      expect(EmergencyDetector.isEmergency('convulsing on the floor'), isTrue);
      expect(
        EmergencyDetector.isEmergency('fell from chair and is unconscious'),
        isTrue,
      );
    });

    test('detects foreign object and chemical ingestion', () {
      expect(
        EmergencyDetector.isEmergency('swallowed a button battery'),
        isTrue,
      );
      expect(EmergencyDetector.isEmergency('child drank bleach'), isTrue);
      expect(EmergencyDetector.isEmergency('choking on a coin'), isTrue);
    });

    test('does NOT trigger on normal parenting queries', () {
      expect(
        EmergencyDetector.isEmergency('Why is my baby waking at 4am?'),
        isFalse,
      );
      expect(
        EmergencyDetector.isEmergency('Child had a tantrum before bedtime'),
        isFalse,
      );
      expect(
        EmergencyDetector.isEmergency('How long should an afternoon nap be?'),
        isFalse,
      );
      expect(
        EmergencyDetector.isEmergency('Baby is crying because of teething'),
        isFalse,
      );
      expect(
        EmergencyDetector.isEmergency('Blue shoes for bedtime routine'),
        isFalse,
      );
    });

    test('detects concerning non-emergency health statements', () {
      expect(
        EmergencyDetector.isConcerningHealth('high fever overnight'),
        isTrue,
      );
      expect(
        EmergencyDetector.isConcerningHealth('rash all over body'),
        isTrue,
      );
      expect(
        EmergencyDetector.isConcerningHealth('keeps vomiting all day'),
        isTrue,
      );
      expect(
        EmergencyDetector.isConcerningHealth('will not drink anything'),
        isTrue,
      );
      expect(
        EmergencyDetector.isConcerningHealth('ear pain since morning'),
        isTrue,
      );
    });

    test('acute emergency is not also clinical concern', () {
      expect(EmergencyDetector.isEmergency('not breathing'), isTrue);
      expect(EmergencyDetector.isConcerningHealth('not breathing'), isFalse);
    });

    test('normal queries are not clinical concerns', () {
      expect(
        EmergencyDetector.isConcerningHealth('Why is bedtime harder lately?'),
        isFalse,
      );
    });

    test('returns fallback emergency phone numbers', () {
      final String phone = EmergencyDetector.getEmergencyPhone();
      expect(phone, startsWith('tel:'));
      final String digits = EmergencyDetector.getEmergencyDisplayNumber();
      expect(digits.isNotEmpty, isTrue);
    });
  });
}
