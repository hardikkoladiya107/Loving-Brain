import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/auth/otp/bloc/otp_cubit.dart';

void main() {
  group('OtpCubit Lockout & Attempt Limit Tests (BUG-04)', () {
    test('initial state has 0 failed attempts and not locked', () {
      final OtpCubit cubit = OtpCubit();
      expect(cubit.state.failedAttempts, equals(0));
      expect(cubit.state.isLocked, isFalse);
      expect(cubit.state.lockoutSeconds, equals(0));
      cubit.close();
    });

    test('increments failed attempts and locks out after 5 failures', () {
      final OtpCubit cubit = OtpCubit();
      cubit.changeProps(failedAttempts: 4);

      // 5th failed attempt triggers lockout
      cubit.changeProps(
        failedAttempts: 5,
        isLocked: true,
        lockoutSeconds: 120,
        otpError:
            'Too many incorrect attempts (5/5). Locked for 2 minutes. Please request a new code.',
      );

      expect(cubit.state.isLocked, isTrue);
      expect(cubit.state.failedAttempts, equals(5));
      expect(cubit.state.lockoutSeconds, equals(120));
      expect(cubit.state.otpError, contains('Locked for 2 minutes'));

      cubit.close();
    });

    test('lockout blocks onOtpChanged input updates', () {
      final OtpCubit cubit = OtpCubit();
      cubit.changeProps(isLocked: true, otpCode: '1234');
      cubit.onOtpChanged('5678');
      expect(cubit.state.otpCode, equals('1234'));
      cubit.close();
    });
  });
}
