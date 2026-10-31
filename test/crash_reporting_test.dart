import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/other/crash_reporting.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('CrashReporting exposes the release-only helpers', () {
    expect(CrashReporting.initialise, isA<Function>());
    expect(CrashReporting.setUser, isA<Function>());
    expect(CrashReporting.clearUser, isA<Function>());
    expect(CrashReporting.recordNonFatal, isA<Function>());
  });

  test('non-fatal recording is a no-op outside release', () async {
    expect(kReleaseMode, isFalse);
    await CrashReporting.recordNonFatal(
      Exception('unit-test-only'),
      StackTrace.current,
      reason: 'unit_test',
    );
  });
}
