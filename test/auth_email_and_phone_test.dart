import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/auth/otp/bloc/otp_cubit.dart';
import 'package:loving_brain/ui/auth/register/bloc/register_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterCubit Email & Mobile Number Validation Tests', () {
    test('Empty input flags validation error', () async {
      final RegisterCubit cubit = RegisterCubit();
      cubit.init();

      cubit.changeProps(emailAddress: '');
      await cubit.sendOtp();

      expect(
        cubit.state.emailAddressError,
        'Please enter your email or mobile number',
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

        cubit.changeProps(emailAddress: '9876543210');
        await cubit.sendOtp();

        expect(cubit.state.emailAddress, '+919876543210');
        expect(cubit.state.isPhoneAuth, isTrue);
        expect(cubit.state.emailAddressError, isEmpty);
        cubit.close();
      },
    );

    test(
      '11-digit phone with leading 0 strips 0 and automatically adds +91',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(emailAddress: '09876543210');
        await cubit.sendOtp();

        expect(cubit.state.emailAddress, '+919876543210');
        expect(cubit.state.isPhoneAuth, isTrue);
        expect(cubit.state.emailAddressError, isEmpty);
        cubit.close();
      },
    );

    test(
      'Invalid phone length (<10 digits) flags valid 10-digit mobile error',
      () async {
        final RegisterCubit cubit = RegisterCubit();
        cubit.init();

        cubit.changeProps(emailAddress: '98765');
        await cubit.sendOtp();

        expect(
          cubit.state.emailAddressError,
          'Please enter a valid 10-digit mobile number',
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

        cubit.changeProps(emailAddress: '+919876543210');
        await cubit.sendOtp();

        expect(cubit.state.emailAddress, '+919876543210');
        expect(cubit.state.isPhoneAuth, isTrue);
        expect(cubit.state.emailAddressError, isEmpty);
        cubit.close();
      },
    );
  });

  group('OtpCubit Dual Mode (Email vs Phone) Tests', () {
    test(
      'Initializes in email mode by default with 4-digit code requirement',
      () async {
        final OtpCubit cubit = OtpCubit();
        cubit.init(destination: 'user@example.com', isPhoneAuth: false);

        expect(cubit.state.isPhoneAuth, isFalse);
        expect(cubit.state.destination, 'user@example.com');

        // Attempting to verify with less than 4 digits fails
        cubit.onOtpChanged('123');
        await cubit.verifyOtp();
        expect(cubit.state.otpError, 'Please enter 4-digit verification code');
        cubit.close();
      },
    );

    test(
      'Initializes in phone mode with 6-digit code requirement and verificationId',
      () async {
        final OtpCubit cubit = OtpCubit();
        cubit.init(
          destination: '+16505551234',
          verificationId: 'test_verification_id',
          resendToken: 998877,
          isPhoneAuth: true,
        );

        expect(cubit.state.isPhoneAuth, isTrue);
        expect(cubit.state.destination, '+16505551234');
        expect(cubit.state.verificationId, 'test_verification_id');
        expect(cubit.state.resendToken, 998877);

        // Attempting to verify with 4 or 5 digits in phone mode fails
        cubit.onOtpChanged('1234');
        await cubit.verifyOtp();
        expect(cubit.state.otpError, 'Please enter 6-digit verification code');
        cubit.close();
      },
    );
  });
}
