import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/auth/otp/bloc/otp_cubit.dart';
import 'package:loving_brain/ui/auth/register/bloc/register_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterCubit Email & Mobile Number Validation Tests', () {
    test('Empty input flags validation error', () async {
      final RegisterCubit cubit = RegisterCubit();
      cubit.init();

      cubit.changeProps(phoneNumber: '', emailAddress: '');
      await cubit.sendOtp();

      expect(
        cubit.state.phoneNumberError,
        'Please enter your mobile number or email address',
      );
      cubit.close();
    });

    test('Invalid email flags email validation error', () async {
      final RegisterCubit cubit = RegisterCubit();
      cubit.init();

      cubit.changeProps(emailAddress: 'notanemail@');
      await cubit.sendOtp();

      expect(cubit.state.emailAddressError, isNotEmpty);
      expect(cubit.state.isPhoneAuth, isFalse);
      cubit.close();
    });

    test(
      '10-digit Indian phone number without +91 automatically adds +91 and routes to phone auth',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(phoneNumber: '9876543210');
        await cubit.sendOtp();

        expect(cubit.state.phoneNumber, '+919876543210');
        expect(cubit.state.isPhoneAuth, isTrue);
        expect(cubit.state.phoneNumberError, isEmpty);
        cubit.close();
      },
    );

    test(
      'Non-+91 country code flags error that only Indian mobile numbers are allowed',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(phoneNumber: '+16505551234');
        await cubit.sendOtp();

        expect(
          cubit.state.phoneNumberError,
          'We only allow Indian mobile numbers (+91) at this time',
        );
        expect(cubit.state.isPhoneAuth, isFalse);
        cubit.close();
      },
    );

    test(
      'Phone numbers starting with 1-5 are rejected as invalid Indian mobile numbers',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(phoneNumber: '1234567890');
        await cubit.sendOtp();

        expect(
          cubit.state.phoneNumberError,
          'Please enter a valid 10-digit Indian mobile number',
        );
        expect(cubit.state.isPhoneAuth, isFalse);
        cubit.close();
      },
    );

    test(
      '11-digit phone with leading 0 strips 0 and automatically adds +91',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(phoneNumber: '09876543210');
        await cubit.sendOtp();

        expect(cubit.state.phoneNumber, '+919876543210');
        expect(cubit.state.isPhoneAuth, isTrue);
        expect(cubit.state.phoneNumberError, isEmpty);
        cubit.close();
      },
    );

    test(
      'Invalid phone length (<10 digits) flags valid 10-digit mobile error',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(phoneNumber: '98765');
        await cubit.sendOtp();

        expect(
          cubit.state.phoneNumberError,
          'Please enter a valid 10-digit Indian mobile number',
        );
        expect(cubit.state.isPhoneAuth, isFalse);
        cubit.close();
      },
    );

    test(
      'Valid phone with +91 country code routes to phone auth and codeSent',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(phoneNumber: '+919876543210');
        await cubit.sendOtp();

        expect(cubit.state.phoneNumber, '+919876543210');
        expect(cubit.state.isPhoneAuth, isTrue);
        expect(cubit.state.phoneNumberError, isEmpty);
        cubit.close();
      },
    );

    test(
      'Both mobile number and email provided: validates both and stores linked values',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(
          phoneNumber: '9976543210',
          emailAddress: 'parent@example.com',
        );
        await cubit.sendOtp();

        expect(cubit.state.phoneNumber, '+919976543210');
        expect(cubit.state.linkedPhone, '+919976543210');
        expect(cubit.state.linkedEmail, 'parent@example.com');
        expect(cubit.state.isPhoneAuth, isTrue);
        expect(cubit.state.phoneNumberError, isEmpty);
        expect(cubit.state.emailAddressError, isEmpty);
        cubit.close();
      },
    );

    test(
      'Both provided but email is invalid: halts and flags email error',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(
          phoneNumber: '9976543210',
          emailAddress: 'invalid-email',
        );
        await cubit.sendOtp();

        expect(cubit.state.emailAddressError, isNotEmpty);
        expect(cubit.state.isPhoneAuth, isFalse);
        cubit.close();
      },
    );
  });

  group('OtpCubit Dual Mode (Email vs Phone) Tests', () {
    test(
      'Initializes in email mode with the same 6-digit code requirement',
      () async {
        final OtpCubit cubit = OtpCubit();
        cubit.init(destination: 'user@example.com', isPhoneAuth: false);

        expect(cubit.state.isPhoneAuth, isFalse);
        expect(cubit.state.destination, 'user@example.com');

        cubit.onOtpChanged('1234');
        await cubit.verifyOtp();
        expect(cubit.state.otpError, 'Please enter 6-digit verification code');
        cubit.close();
      },
    );

    test(
      'Initializes in phone mode with 6-digit code requirement and verificationId',
      () async {
        final OtpCubit cubit = OtpCubit();
        cubit.init(
          destination: '+919976543210',
          verificationId: 'test_verification_id',
          resendToken: 998877,
          isPhoneAuth: true,
          linkedEmail: 'parent@example.com',
          linkedPhone: '+919976543210',
        );

        expect(cubit.state.isPhoneAuth, isTrue);
        expect(cubit.state.destination, '+919976543210');
        expect(cubit.state.verificationId, 'test_verification_id');
        expect(cubit.state.resendToken, 998877);
        expect(cubit.state.linkedEmail, 'parent@example.com');
        expect(cubit.state.linkedPhone, '+919976543210');

        // Attempting to verify with 4 or 5 digits in phone mode fails
        cubit.onOtpChanged('1234');
        await cubit.verifyOtp();
        expect(cubit.state.otpError, 'Please enter 6-digit verification code');
        cubit.close();
      },
    );
  });
}
