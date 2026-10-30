import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/other/family_membership_helpers.dart';

void main() {
  group('FamilyMembershipHelpers.addChildUserUpdateKeys', () {
    test('includes only children when default already set', () {
      expect(
        FamilyMembershipHelpers.addChildUserUpdateKeys(hasDefaultChild: true),
        <String>{'children'},
      );
    });

    test('includes children and default_child when none set', () {
      expect(
        FamilyMembershipHelpers.addChildUserUpdateKeys(hasDefaultChild: false),
        <String>{'children', 'default_child'},
      );
    });

    test('rejects payloads that copy child fields onto the parent', () {
      expect(
        FamilyMembershipHelpers.isValidAddChildUserPayload(<String, dynamic>{
          'children': <Object>[],
          'child_name': 'Maya',
        }),
        isFalse,
      );
      expect(
        FamilyMembershipHelpers.isValidAddChildUserPayload(<String, dynamic>{
          'children': <Object>[],
          'default_child': 'ref',
        }),
        isTrue,
      );
    });
  });

  group('FamilyMembershipHelpers.onboarding default child', () {
    test('sets default only when accepter has none', () {
      expect(
        FamilyMembershipHelpers.shouldSetDefaultChildOnOnboarding(
          hasExistingDefaultChild: true,
        ),
        isFalse,
      );
      expect(
        FamilyMembershipHelpers.shouldSetDefaultChildOnOnboarding(
          hasExistingDefaultChild: false,
        ),
        isTrue,
      );
    });
  });
}
