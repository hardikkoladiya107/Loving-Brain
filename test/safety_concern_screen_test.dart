import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/core/emergency_detector.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/base_screen/bloc/base_cubit.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_cubit.dart';
import 'package:loving_brain/ui/safety_concern/safety_concern_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers.global'),
          (MethodCall methodCall) async => 1,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers'),
          (MethodCall methodCall) async => 1,
        );
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPreference.init();
  });

  void setPhoneSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget wrapSafety({
    required SafetyConcernMode mode,
    String? sourceMessage,
    required BaseCubit baseCubit,
  }) {
    final GoRouter router = GoRouter(
      initialLocation: RoutePaths.safetyConcern,
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.safetyConcern,
          builder: (BuildContext context, GoRouterState state) {
            return SafetyConcernScreen(
              mode: mode,
              sourceMessage: sourceMessage,
            );
          },
        ),
        GoRoute(
          path: RoutePaths.helpSafety,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: Text('Help Safety'));
          },
        ),
        GoRoute(
          path: RoutePaths.baseScreen,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: Text('Base Screen'));
          },
        ),
      ],
    );

    return BlocProvider<BaseCubit>.value(
      value: baseCubit,
      child: ScreenUtilInit(
        designSize: const Size(389, 780),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? _) {
          return MaterialApp.router(routerConfig: router);
        },
      ),
    );
  }

  group('SafetyConcernScreen (p70)', () {
    testWidgets('acute mode shows Call emergency as primary action', (
      WidgetTester tester,
    ) async {
      setPhoneSurface(tester);
      final BaseCubit baseCubit = BaseCubit();
      final String displayNumber =
          EmergencyDetector.getEmergencyDisplayNumber();

      await tester.pumpWidget(
        wrapSafety(
          mode: SafetyConcernMode.acute,
          sourceMessage: 'not breathing',
          baseCubit: baseCubit,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Please contact emergency services'), findsOneWidget);
      expect(
        find.text('Call emergency services ($displayNumber)'),
        findsOneWidget,
      );
      expect(find.text('Read safety information'), findsOneWidget);
      expect(find.text('Not now — go back to Brainy'), findsOneWidget);
      expect(find.text('not breathing'), findsOneWidget);

      await baseCubit.close();
    });

    testWidgets('clinical mode leads with Read safety, no Call emergency', (
      WidgetTester tester,
    ) async {
      setPhoneSurface(tester);
      final BaseCubit baseCubit = BaseCubit();

      await tester.pumpWidget(
        wrapSafety(mode: SafetyConcernMode.clinical, baseCubit: baseCubit),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Please speak with a health professional'),
        findsOneWidget,
      );
      expect(find.text('Read safety information'), findsOneWidget);
      expect(find.textContaining('Call emergency services'), findsNothing);

      await baseCubit.close();
    });

    testWidgets('Not now navigates to base screen (Brainy home tab)', (
      WidgetTester tester,
    ) async {
      setPhoneSurface(tester);
      final BaseCubit baseCubit = BaseCubit();

      await tester.pumpWidget(
        wrapSafety(mode: SafetyConcernMode.acute, baseCubit: baseCubit),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Not now — go back to Brainy'));
      await tester.tap(find.text('Not now — go back to Brainy'));
      await tester.pumpAndSettle();

      expect(find.text('Base Screen'), findsOneWidget);
      expect(baseCubit.state.bottomNavigationIndex, 1);

      await baseCubit.close();
    });
  });

  group('Conversation → Safety Concern plumbing', () {
    test('pendingSafetyMode is set/cleared for one-shot p70 navigation', () {
      final BrainyConversationCubit cubit = BrainyConversationCubit();

      cubit.changeProps(
        pendingSafetyMode: 'acute',
        pendingSafetySourceMessage: 'lips turned blue',
      );
      expect(cubit.state.pendingSafetyMode, 'acute');
      expect(cubit.state.pendingSafetySourceMessage, 'lips turned blue');

      cubit.clearPendingSafetyNavigation();
      expect(cubit.state.pendingSafetyMode, isNull);
      expect(cubit.state.pendingSafetySourceMessage, isNull);

      cubit.changeProps(
        pendingSafetyMode: 'clinical',
        pendingSafetySourceMessage: 'high fever overnight',
      );
      expect(cubit.state.pendingSafetyMode, 'clinical');

      cubit.close();
    });

    test(
      'conversation screen routes to SafetyConcern, not AlertBottomSheet',
      () async {
        final String screenSource = await File(
          'lib/ui/brainy_conversation/brainy_conversation_screen.dart',
        ).readAsString();
        expect(screenSource.contains('RoutePaths.safetyConcern'), isTrue);
        expect(screenSource.contains('pendingSafetyMode'), isTrue);
        expect(screenSource.contains('AlertBottomSheet'), isFalse);
        expect(screenSource.contains('showSafetyConcern'), isFalse);
      },
    );
  });
}
