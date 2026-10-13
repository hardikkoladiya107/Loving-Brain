/// Model representing granular caregiver access permissions per V2 spec (Screen 58).
/// Rule from v2-doc/01_COMPLETE_USER_FLOW.md:
/// - Sleep, Behaviour, Plans are permitted by default for primary co-parents.
/// - Health notes and mentorship summaries remain private unless explicitly enabled.
/// - Grandparent role defaults to sleep and plans only.
/// - Parent reflections are NEVER shared under any circumstances.
class CaregiverPermissionsModel {
  final String caregiverEmail;
  final String? name;
  final String role;
  final bool canViewSleep;
  final bool canViewBehaviour;
  final bool canViewHealthNotes;
  final bool canViewPlans;
  final bool canViewMentorSummaries;

  const CaregiverPermissionsModel({
    required this.caregiverEmail,
    this.name,
    this.role = 'partner',
    this.canViewSleep = true,
    this.canViewBehaviour = true,
    this.canViewHealthNotes = false,
    this.canViewPlans = true,
    this.canViewMentorSummaries = false,
  });

  /// STRICT PRIVACY INVARIANT: Parent reflections must NEVER be shared under any circumstances.
  bool get parentReflectionsNeverShared => true;

  String get caregiverName {
    if (name != null && name!.trim().isNotEmpty) return name!.trim();
    return caregiverEmail.contains('@')
        ? caregiverEmail.split('@').first
        : caregiverEmail;
  }

  bool get canViewMentorshipSummaries => canViewMentorSummaries;

  /// Convenience factory for tests and UI defaults
  static CaregiverPermissionsModel forRole(
    String role,
    String name, {
    String? caregiverEmail,
  }) {
    return CaregiverPermissionsModel.defaultForRole(
      email: caregiverEmail ?? '$name@example.com',
      name: name,
      role: role,
    );
  }

  /// Factory for default permissions based on caregiver relationship role.
  factory CaregiverPermissionsModel.defaultForRole({
    required String email,
    required String role,
    String? name,
  }) {
    final String cleanRole = role.toLowerCase().trim();
    if (cleanRole == 'grandparent') {
      return CaregiverPermissionsModel(
        caregiverEmail: email,
        name: name,
        role: role,
        canViewSleep: true,
        canViewBehaviour: false,
        canViewHealthNotes: false,
        canViewPlans: true,
        canViewMentorSummaries: false,
      );
    }
    if (cleanRole == 'nanny' || cleanRole == 'babysitter') {
      return CaregiverPermissionsModel(
        caregiverEmail: email,
        name: name,
        role: role,
        canViewSleep: true,
        canViewBehaviour: true,
        canViewHealthNotes: false,
        canViewPlans: true,
        canViewMentorSummaries: false,
      );
    }
    // Default partner permissions
    return CaregiverPermissionsModel(
      caregiverEmail: email,
      name: name,
      role: role,
      canViewSleep: true,
      canViewBehaviour: true,
      canViewHealthNotes: false,
      canViewPlans: true,
      canViewMentorSummaries: false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caregiver_email': caregiverEmail,
      'caregiverEmail': caregiverEmail,
      'name': caregiverName,
      'caregiver_name': caregiverName,
      'caregiverName': caregiverName,
      'role': role,
      'can_view_sleep': canViewSleep,
      'canViewSleep': canViewSleep,
      'can_view_behaviour': canViewBehaviour,
      'canViewBehaviour': canViewBehaviour,
      'can_view_health_notes': canViewHealthNotes,
      'canViewHealthNotes': canViewHealthNotes,
      'can_view_plans': canViewPlans,
      'canViewPlans': canViewPlans,
      'can_view_mentor_summaries': canViewMentorSummaries,
      'canViewMentorSummaries': canViewMentorSummaries,
      'parent_reflections_never_shared': parentReflectionsNeverShared,
      'parentReflectionsNeverShared': parentReflectionsNeverShared,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory CaregiverPermissionsModel.fromMap(Map<String, dynamic> map) {
    final String email =
        (map['caregiver_email'] ?? map['caregiverEmail'])?.toString() ?? '';
    final String? n =
        (map['name'] ?? map['caregiver_name'] ?? map['caregiverName'])
            ?.toString();
    final String role = map['role']?.toString() ?? 'partner';
    final bool canSleep =
        (map['can_view_sleep'] ?? map['canViewSleep']) != false;
    final bool canBehaviour =
        (map['can_view_behaviour'] ?? map['canViewBehaviour']) != false;
    final bool canHealth =
        (map['can_view_health_notes'] ?? map['canViewHealthNotes']) == true;
    final bool canPlans =
        (map['can_view_plans'] ?? map['canViewPlans']) != false;
    final bool canMentor =
        (map['can_view_mentor_summaries'] ??
            map['canViewMentorSummaries'] ??
            map['can_view_mentorship_summaries']) ==
        true;

    return CaregiverPermissionsModel(
      caregiverEmail: email,
      name: n,
      role: role,
      canViewSleep: canSleep,
      canViewBehaviour: canBehaviour,
      canViewHealthNotes: canHealth,
      canViewPlans: canPlans,
      canViewMentorSummaries: canMentor,
    );
  }

  factory CaregiverPermissionsModel.fromJson(Map<String, dynamic> json) =>
      CaregiverPermissionsModel.fromMap(json);

  CaregiverPermissionsModel copyWith({
    String? caregiverEmail,
    String? name,
    String? role,
    bool? canViewSleep,
    bool? canViewBehaviour,
    bool? canViewHealthNotes,
    bool? canViewPlans,
    bool? canViewMentorSummaries,
  }) {
    return CaregiverPermissionsModel(
      caregiverEmail: caregiverEmail ?? this.caregiverEmail,
      name: name ?? this.name,
      role: role ?? this.role,
      canViewSleep: canViewSleep ?? this.canViewSleep,
      canViewBehaviour: canViewBehaviour ?? this.canViewBehaviour,
      canViewHealthNotes: canViewHealthNotes ?? this.canViewHealthNotes,
      canViewPlans: canViewPlans ?? this.canViewPlans,
      canViewMentorSummaries:
          canViewMentorSummaries ?? this.canViewMentorSummaries,
    );
  }
}
