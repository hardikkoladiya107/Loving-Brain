import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

void main() {
  test('AgeUtils computes age in months from dob', () {
    final DateTime dob = DateTime.now().subtract(const Duration(days: 90));
    final int? ageInMonths = AgeUtils.ageInMonthsFromDob(dob);
    expect(ageInMonths, isNotNull);
    expect(ageInMonths, greaterThanOrEqualTo(2));
    expect(ageInMonths, lessThanOrEqualTo(3));
  });

  testWidgets(
    'AppButton renders SpinKitThreeBounce instead of CircularProgressIndicator when isLoading is true',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              home: Scaffold(
                body: AppButton(
                  title: 'Continue',
                  isLoading: true,
                  onTap: () {},
                ),
              ),
            );
          },
        ),
      );

      expect(find.byType(SpinKitThreeBounce), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
}
