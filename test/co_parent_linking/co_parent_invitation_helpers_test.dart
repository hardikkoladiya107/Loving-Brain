import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';

void main() {
  group('CoParentInvitationHelpers.parseInvitationIdFromUri', () {
    test('extracts id from www universal link', () {
      final Uri uri = Uri.parse('https://www.lovingbrain.com/abc123xyz');
      expect(
        CoParentInvitationHelpers.parseInvitationIdFromUri(uri),
        'abc123xyz',
      );
    });

    test('extracts id from path with trailing slash', () {
      final Uri uri = Uri.parse('https://lovingbrain.com/invite-id-99/');
      expect(
        CoParentInvitationHelpers.parseInvitationIdFromUri(uri),
        'invite-id-99',
      );
    });

    test('extracts id from custom scheme lovingbrain://invite/abc123xyz', () {
      final Uri uri = Uri.parse('lovingbrain://invite/abc123xyz');
      expect(
        CoParentInvitationHelpers.parseInvitationIdFromUri(uri),
        'abc123xyz',
      );
    });

    test('extracts id from custom scheme lovingbrain://abc123xyz', () {
      final Uri uri = Uri.parse('lovingbrain://abc123xyz');
      expect(
        CoParentInvitationHelpers.parseInvitationIdFromUri(uri),
        'abc123xyz',
      );
    });

    test('extracts id from query parameter ?id=abc123xyz', () {
      final Uri uri = Uri.parse(
        'https://www.lovingbrain.com/invite.html?id=abc123xyz',
      );
      expect(
        CoParentInvitationHelpers.parseInvitationIdFromUri(uri),
        'abc123xyz',
      );
    });

    test('returns null for root path', () {
      final Uri uri = Uri.parse('https://www.lovingbrain.com/');
      expect(CoParentInvitationHelpers.parseInvitationIdFromUri(uri), isNull);
    });

    test('ignores reserved site paths like privacy and terms', () {
      for (final String path in <String>[
        'privacy',
        'terms',
        'faq',
        'welcome',
        'login',
        'register',
        'otp',
      ]) {
        expect(
          CoParentInvitationHelpers.parseInvitationIdFromUri(
            Uri.parse('https://www.lovingbrain.com/$path'),
          ),
          isNull,
          reason: 'path /$path must not be treated as an invite id',
        );
      }
    });

    test('extracts id from /invite/{id} path', () {
      final Uri uri = Uri.parse('https://www.lovingbrain.com/invite/abc123xyz');
      expect(
        CoParentInvitationHelpers.parseInvitationIdFromUri(uri),
        'abc123xyz',
      );
    });
  });

  group('CoParentInvitationHelpers store & custom scheme builders', () {
    test('builds universal invite link under /invite/', () {
      expect(
        CoParentInvitationHelpers.buildInvitationLink('inv999'),
        'https://www.lovingbrain.com/invite/inv999',
      );
    });

    test('builds custom scheme link properly', () {
      expect(
        CoParentInvitationHelpers.buildCustomSchemeInvitationLink('inv999'),
        'lovingbrain://invite/inv999',
      );
    });

    test('store URLs contain valid package name and app identifiers', () {
      expect(
        CoParentInvitationHelpers.playStoreUrl,
        contains('com.app.loving_brain'),
      );
      expect(CoParentInvitationHelpers.appStoreUrl, contains('loving-brain'));
    });
  });

  group('CoParentInvitationHelpers.emailsMatch', () {
    test('matches case-insensitively with surrounding spaces', () {
      expect(
        CoParentInvitationHelpers.emailsMatch(
          ' Parent@Email.com ',
          'parent@email.com',
        ),
        isTrue,
      );
    });

    test('does not match different emails', () {
      expect(
        CoParentInvitationHelpers.emailsMatch('a@test.com', 'b@test.com'),
        isFalse,
      );
    });
  });

  group('CoParentInvitationHelpers child id csv', () {
    test('parseChildIdsFromCsv trims and drops empty segments', () {
      expect(
        CoParentInvitationHelpers.parseChildIdsFromCsv(' child1 , ,child2, '),
        <String>['child1', 'child2'],
      );
    });

    test('buildChildrenCsv joins non-empty ids', () {
      expect(
        CoParentInvitationHelpers.buildChildrenCsv(<String>['a', ' b ', '']),
        'a,b',
      );
    });

    test('round-trip csv parse and build', () {
      final List<String> ids = <String>['id1', 'id2', 'id3'];
      final String csv = CoParentInvitationHelpers.buildChildrenCsv(ids);
      expect(CoParentInvitationHelpers.parseChildIdsFromCsv(csv), ids);
    });
  });

  group('CoParentInvitationHelpers.buildInvitationLink', () {
    test('uses production base url', () {
      expect(
        CoParentInvitationHelpers.buildInvitationLink('doc123'),
        'https://www.lovingbrain.com/invite/doc123',
      );
    });
  });

  group('CoParentInvitationHelpers.validateInvitationForAccept', () {
    test('returns null for valid pending invitation', () {
      expect(
        CoParentInvitationHelpers.validateInvitationForAccept(
          invitedEmail: 'co@parent.com',
          loggedInEmail: 'CO@parent.com',
          invitationStatus: CoParentInvitationHelpers.statusRequested,
        ),
        isNull,
      );
    });

    test('rejects email mismatch', () {
      expect(
        CoParentInvitationHelpers.validateInvitationForAccept(
          invitedEmail: 'a@test.com',
          loggedInEmail: 'b@test.com',
          invitationStatus: CoParentInvitationHelpers.statusRequested,
        ),
        'thisInvitationIsNotForYou',
      );
    });

    test('rejects already accepted invitation', () {
      expect(
        CoParentInvitationHelpers.validateInvitationForAccept(
          invitedEmail: 'a@test.com',
          loggedInEmail: 'a@test.com',
          invitationStatus: CoParentInvitationHelpers.statusAccepted,
        ),
        'invitationAlreadyUsed',
      );
    });

    test('rejects empty invited email', () {
      expect(
        CoParentInvitationHelpers.validateInvitationForAccept(
          invitedEmail: '',
          loggedInEmail: 'a@test.com',
          invitationStatus: CoParentInvitationHelpers.statusRequested,
        ),
        'deepLinkInvitationInvalidEmail',
      );
    });
  });

  group('CoParentInvitationHelpers.toggleChildSelection', () {
    test('adds and removes items by id', () {
      final List<_TestChild> selected =
          CoParentInvitationHelpers.toggleChildSelection<_TestChild>(
            selected: <_TestChild>[],
            child: const _TestChild(id: 'c1', name: 'Emma'),
            idForItem: (_TestChild item) => item.id,
          );
      expect(selected.length, 1);

      final List<_TestChild> deselected =
          CoParentInvitationHelpers.toggleChildSelection<_TestChild>(
            selected: selected,
            child: const _TestChild(id: 'c1', name: 'Emma'),
            idForItem: (_TestChild item) => item.id,
          );
      expect(deselected, isEmpty);
    });
  });

  group('CoParentInvitationHelpers.validateSendInviteForm', () {
    bool alwaysValid(String _) => true;
    bool alwaysInvalid(String _) => false;

    test('requires at least one child', () {
      final InviteFormValidationResult result =
          CoParentInvitationHelpers.validateSendInviteForm(
            toEmail: 'co@parent.com',
            fromEmail: 'me@parent.com',
            selectedChildrenCount: 0,
            isValidEmailFormat: alwaysValid,
          );
      expect(result.isValid, isFalse);
      expect(result.selectChildrenErrorKey, 'pleaseSelectChild');
    });

    test('requires co-parent email', () {
      final InviteFormValidationResult result =
          CoParentInvitationHelpers.validateSendInviteForm(
            toEmail: '',
            fromEmail: 'me@parent.com',
            selectedChildrenCount: 1,
            isValidEmailFormat: alwaysValid,
          );
      expect(result.isValid, isFalse);
      expect(result.coParentEmailErrorKey, 'pleaseEnterCoParentEmail');
    });

    test('rejects invalid email format', () {
      final InviteFormValidationResult result =
          CoParentInvitationHelpers.validateSendInviteForm(
            toEmail: 'not-an-email',
            fromEmail: 'me@parent.com',
            selectedChildrenCount: 1,
            isValidEmailFormat: alwaysInvalid,
          );
      expect(result.isValid, isFalse);
      expect(result.coParentEmailErrorKey, 'pleaseEnterValidEmail');
    });

    test('rejects self-invite', () {
      final InviteFormValidationResult result =
          CoParentInvitationHelpers.validateSendInviteForm(
            toEmail: 'Me@Parent.com',
            fromEmail: 'me@parent.com',
            selectedChildrenCount: 1,
            isValidEmailFormat: alwaysValid,
          );
      expect(result.isValid, isFalse);
      expect(result.coParentEmailErrorKey, 'cannotInviteYourself');
    });

    test('passes valid form', () {
      final InviteFormValidationResult result =
          CoParentInvitationHelpers.validateSendInviteForm(
            toEmail: 'co@parent.com',
            fromEmail: 'me@parent.com',
            selectedChildrenCount: 2,
            isValidEmailFormat: alwaysValid,
          );
      expect(result.isValid, isTrue);
    });
  });
}

class _TestChild {
  const _TestChild({required this.id, required this.name});

  final String id;
  final String name;
}
