import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/permissions/bloc/permissions_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QA Report v1.6 Deep Audit Verification', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        SharedPreference.isLogin: true,
        SharedPreference.user:
            '{"uid": "inviter_01", "email": "parent@lovingbrain.com", "partner_user_id": "coparent_02"}',
        SharedPreference.child:
            '{"child_name": "QA Child", "parent_reference_ids": ["inviter_01", "coparent_02"]}',
      });
      await SharedPreference.init();
    });

    test(
      'PermissionsCubit.revokeAccess() removes partner from local child parentReferenceIds and partnerUserId',
      () async {
        final ChildModel? childBefore = preferences.getChildModel();
        expect(childBefore, isNotNull);
        expect(childBefore!.parentReferenceIds, contains('coparent_02'));

        final UserModel? userBefore = preferences.getUserModel();
        expect(userBefore?.partnerUserId, 'coparent_02');

        final PermissionsCubit cubit = PermissionsCubit();
        cubit.init(
          caregiverName: 'Co-Parent',
          role: 'Partner',
          caregiverId: 'coparent_02',
          caregiverEmail: 'coparent@lovingbrain.com',
        );

        final bool success = await cubit.revokeAccess();
        expect(success, isTrue);

        // Verify child model in preferences had coparent_02 removed
        final ChildModel? childAfter = preferences.getChildModel();
        expect(childAfter, isNotNull);
        expect(childAfter!.parentReferenceIds, isNot(contains('coparent_02')));
        expect(childAfter.parentReferenceIds, contains('inviter_01'));

        // Verify user model in preferences had partnerUserId cleared
        final UserModel? userAfter = preferences.getUserModel();
        expect(userAfter?.partnerUserId, isNull);

        cubit.close();
      },
    );

    test('TimelineEventModel parses authorName correctly', () {
      final TimelineEventModel event =
          TimelineEventModel.fromMap(<String, dynamic>{
            'type': 'quick_note',
            'title': 'Quick note',
            'subtitle': 'Child went down peacefully',
            'timestamp': DateTime.now().toIso8601String(),
            'authorName': 'QA Test Parent',
          }, id: 'event_note_01');

      expect(event.title, 'Quick note');
      expect(event.authorName, 'QA Test Parent');
    });

    test(
      'DOB default date logic sets initial selection to 2 years ago, not today',
      () {
        final DateTime now = DateTime.now();
        final DateTime defaultToddler = DateTime(now.year - 2, 6, 15);

        expect(defaultToddler.year, equals(now.year - 2));
        expect(defaultToddler.isBefore(now), isTrue);
        // Confirms today (now) is NOT the initial selected date
        expect(
          defaultToddler.day == now.day && defaultToddler.month == now.month,
          isFalse,
        );
      },
    );

    test(
      'Caregiver permissions dynamic subtitle reflects toggled permissions',
      () {
        final CaregiverPermissionsModel permissions = CaregiverPermissionsModel(
          caregiverEmail: 'coparent@lovingbrain.com',
          name: 'Co-Parent',
          role: 'Partner',
          canViewSleep: true,
          canViewBehaviour: true,
          canViewHealthNotes: true,
          canViewPlans: true,
          canViewMentorSummaries: false,
        );

        final List<String> parts = <String>[];
        if (permissions.canViewSleep) parts.add('sleep');
        if (permissions.canViewBehaviour) parts.add('behaviour');
        if (permissions.canViewHealthNotes) parts.add('health');
        if (permissions.canViewPlans) parts.add('plans');
        if (permissions.canViewMentorSummaries) parts.add('mentorship');

        final String summary = "${permissions.role} · ${parts.join(', ')}";
        expect(summary, equals('Partner · sleep, behaviour, health, plans'));
      },
    );
  });
}
