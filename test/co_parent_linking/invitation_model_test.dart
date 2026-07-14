import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/invitation_model.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';

void main() {
  group('InvitationModel', () {
    test('fromJson and toJson round-trip', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'calender_events': true,
        'childs_essentials': false,
        'from_parent': 'parent@test.com',
        'to_parent': 'coparent@test.com',
        'children': 'child1,child2',
        'status': CoParentInvitationHelpers.statusRequested,
      };

      final InvitationModel model = InvitationModel.fromJson(json);
      expect(model.fromParent, 'parent@test.com');
      expect(model.toParent, 'coparent@test.com');
      expect(model.children, 'child1,child2');
      expect(model.status, CoParentInvitationHelpers.statusRequested);
      expect(model.calenderEvents, isTrue);
      expect(model.childsEssentials, isFalse);
      expect(model.toJson(), json);
    });

    test('copyWith updates status', () {
      final InvitationModel model = InvitationModel(
        status: CoParentInvitationHelpers.statusRequested,
        toParent: 'a@test.com',
      );
      final InvitationModel accepted = model.copyWith(
        status: CoParentInvitationHelpers.statusAccepted,
      );
      expect(accepted.status, CoParentInvitationHelpers.statusAccepted);
      expect(accepted.toParent, 'a@test.com');
    });
  });
}
