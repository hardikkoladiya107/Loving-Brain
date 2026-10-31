import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/manager/apple_sign_in/apple_signin_manager.dart';

void main() {
  group('Apple nonce hash', () {
    test('empty string matches the SHA-256 spec', () {
      expect(
        AppleSignInManager.sha256Hex(''),
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
    });

    test('abc matches the SHA-256 spec', () {
      expect(
        AppleSignInManager.sha256Hex('abc'),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
    });

    test('a nonce-length string is 64 lowercase hex chars', () {
      const String nonce = 'abcdefghijklmnopqrstuvwxyz012345';
      final String hash = AppleSignInManager.sha256Hex(nonce);
      expect(hash, hasLength(64));
      expect(hash, isNot(contains(RegExp('[A-Z]'))));
      expect(hash, isNot(nonce));
    });
  });

  group('Apple name and email', () {
    test('first approval uses given and family name', () {
      expect(
        appleDisplayName(givenName: 'Ava', familyName: 'Cole'),
        'Ava Cole',
      );
    });

    test('blank Apple name keeps the name already stored', () {
      expect(
        appleDisplayName(
          givenName: ' ',
          familyName: null,
          storedName: 'Ava Cole',
        ),
        'Ava Cole',
      );
    });

    test('only a family name is kept', () {
      expect(appleDisplayName(givenName: null, familyName: 'Cole'), 'Cole');
    });

    test(
      'a later approval does not replace a stored name when Apple sends nothing',
      () {
        expect(
          appleDisplayName(
            givenName: null,
            familyName: null,
            storedName: 'Ava',
          ),
          'Ava',
        );
      },
    );

    test('firebase email wins over a second Apple email', () {
      expect(
        appleEmail(
          appleEmail: 'new@privaterelay.appleid.com',
          storedEmail: 'ava@privaterelay.appleid.com',
        ),
        'ava@privaterelay.appleid.com',
      );
    });

    test('Hide My Email is stored when Firebase has no email yet', () {
      expect(
        appleEmail(
          appleEmail: 'abc123@privaterelay.appleid.com',
          storedEmail: '  ',
        ),
        'abc123@privaterelay.appleid.com',
      );
    });

    test('both emails empty stays empty', () {
      expect(appleEmail(appleEmail: null, storedEmail: null), '');
    });
  });

  group('Apple errors the parent actually sees', () {
    test('cancel stays silent', () {
      expect(isSilentSignInCancellation(appleCancelledMessage), isTrue);
      expect(
        isSilentSignInCancellation('Exception: $appleCancelledMessage'),
        isTrue,
      );
    });

    test('missing token, iCloud, and Firebase failures are shown', () {
      final List<String> shown = <String>[
        appleMissingTokenMessage,
        'Sign in with Apple could not start. Make sure this iPhone is signed in to iCloud, then try again.',
        'Sign in with Apple failed. Please try again.',
        appleSignInFailureMessage('network-request-failed'),
        appleSignInFailureMessage('invalid-credential'),
        appleSignInFailureMessage('missing-or-invalid-nonce'),
        appleSignInFailureMessage('account-exists-with-different-credential'),
        appleSignInFailureMessage('user-disabled'),
        appleSignInFailureMessage('too-many-requests'),
        appleSignInFailureMessage('something-else'),
      ];
      for (final String message in shown) {
        expect(message.trim().isNotEmpty, isTrue);
        expect(isSilentSignInCancellation(message), isFalse, reason: message);
      }
    });

    test('network and collision copy name the problem', () {
      expect(
        appleSignInFailureMessage('network-request-failed'),
        contains('internet'),
      );
      expect(
        appleSignInFailureMessage('account-exists-with-different-credential'),
        contains('another sign-in'),
      );
      expect(
        appleSignInFailureMessage('invalid-credential'),
        'Apple sign-in could not be verified. Please try again.',
      );
    });
  });
}
