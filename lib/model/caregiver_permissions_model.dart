/// Model representing granular caregiver access permissions per V2 spec (Screen 58).
/// Rule from v2-doc/01_COMPLETE_USER_FLOW.md:
/// - Sleep, Behaviour, Plans are permitted by default for primary co-parents.
/// - Health notes and mentorship summaries remain private unless explicitly enabled.
/// - Grandparent role defaults to sleep and plans only.
/// - Parent reflections are NEVER shared under any circumstances.
class CaregiverPermissionsModel {
  final String caregiverEmail;
  final String role;
  final bool canViewSleep;
  final bool canViewBehaviour;
  final bool canViewHealthNotes;
  final bool canViewPlans;
  final bool canViewMentorSummaries;

  const CaregiverPermissionsModel({
    required this.caregiverEmail,
    this.role = 'partner',
    this.canViewSleep = true,
    this.canViewBehaviour = true,
    this.canViewHealthNotes = false,
    this.canViewPlans = true,
    this.canViewMentorSummaries = false,
  });

  /// Factory for default permissions based on caregiver relationship role.
  factory CaregiverPermissionsModel.defaultForRole({
    required String email,
    required String role,
  }) {
    final String cleanRole = role.toLowerCase().trim();
    if (cleanRole == 'grandparent') {
      return CaregiverPermissionsModel(
        caregiverEmail: email,
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
      'caregiverEmail': caregiverEmail,
      'role': role,
      'canViewSleep': canViewSleep,
      'canViewBehaviour': canViewBehaviour,
      'canViewHealthNotes': canViewHealthNotes,
      'canViewPlans': canViewPlans,
      'canViewMentorSummaries': canViewMentorSummaries,
    };
  }

  factory CaregiverPermissionsModel.fromMap(Map<String, dynamic> map) {
    return CaregiverPermissionsModel(
      caregiverEmail: map['caregiverEmail']?.toString() ?? '',
      role: map['role']?.toString() ?? 'partner',
      canViewSleep: map['canViewSleep'] != false,
      canViewBehaviour: map['canViewBehaviour'] != false,
      canViewHealthNotes: map['canViewHealthNotes'] == true,
      canViewPlans: map['canViewPlans'] != false,
      canViewMentorSummaries: map['canViewMentorSummaries'] == true,
    );
  }

  CaregiverPermissionsModel copyWith({
    String? caregiverEmail,
    String? role,
    bool? canViewSleep,
    bool? canViewBehaviour,
    bool? canViewHealthNotes,
    bool? canViewPlans,
    bool? canViewMentorSummaries,
  }) {
    return CaregiverPermissionsModel(
      caregiverEmail: caregiverEmail ?? this.caregiverEmail,
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
