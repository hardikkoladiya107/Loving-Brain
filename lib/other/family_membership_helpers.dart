/// Pure helpers for family membership / child link payloads (unit-testable).
class FamilyMembershipHelpers {
  FamilyMembershipHelpers._();

  /// Keys written to the user document when adding a new child.
  /// Child identity fields must never appear here.
  static Set<String> addChildUserUpdateKeys({required bool hasDefaultChild}) {
    final Set<String> keys = <String>{'children'};
    if (!hasDefaultChild) {
      keys.add('default_child');
    }
    return keys;
  }

  /// Forbidden user-document keys when creating a child from the app.
  static const Set<String> forbiddenChildFieldsOnUser = <String>{
    'child_name',
    'child_dob',
    'concerns',
    'location',
    'relationship_to_child',
  };

  /// Onboarding must array-union the new child and only set default when empty.
  static bool shouldSetDefaultChildOnOnboarding({
    required bool hasExistingDefaultChild,
  }) {
    return !hasExistingDefaultChild;
  }

  /// True when [userUpdate] only touches membership fields for add-child.
  static bool isValidAddChildUserPayload(Map<String, dynamic> userUpdate) {
    final Set<String> keys = userUpdate.keys.toSet();
    if (keys.intersection(forbiddenChildFieldsOnUser).isNotEmpty) {
      return false;
    }
    if (!keys.contains('children')) return false;
    final Set<String> allowed = addChildUserUpdateKeys(
      hasDefaultChild: !keys.contains('default_child'),
    );
    return keys.difference(allowed).isEmpty;
  }
}
