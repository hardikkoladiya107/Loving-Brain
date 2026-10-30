import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/core/brainy_entry_context.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_cubit.dart';
import 'package:loving_brain/ui/calm_heads_up/bloc/calm_heads_up_cubit.dart';
import 'package:loving_brain/ui/calm_heads_up/calm_heads_up_screen.dart';
import 'package:loving_brain/ui/mentorship_unavailable/bloc/mentorship_unavailable_cubit.dart';
import 'package:loving_brain/ui/mentorship_unavailable/mentorship_unavailable_screen.dart';
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

  group('Conversation attached context merge', () {
    test('folds attached screen context into live context block', () async {
      final BrainyConversationCubit cubit = BrainyConversationCubit();
      await cubit.init(
        topic: 'Calm Heads-Up',
        attachedContext: 'Window: 5:30–7:00 PM\nSignals: short nap',
      );

      final String merged = cubit.mergeAttachedContextForTesting(
        'Relevant recorded data (last 14 days):\n- Sleep: shorter nap',
      );

      expect(merged, contains('Relevant recorded data'));
      expect(merged, contains('Attached screen context:'));
      expect(merged, contains('Window: 5:30–7:00 PM'));
      expect(cubit.state.attachedContext, contains('short nap'));

      await cubit.close();
    });
  });

  group('Calm Heads-Up Ask Brainy', () {
    testWidgets('shows Ask Brainy and pushes conversation extras', (
      WidgetTester tester,
    ) async {
      setPhoneSurface(tester);
      final _TestCalmHeadsUpCubit headsUpCubit = _TestCalmHeadsUpCubit();
      headsUpCubit.changeProps(
        headline: 'A harder window may be more likely',
        reason: 'Skipped nap today',
        windowStart: '5:30 PM',
        windowEnd: '7:00 PM',
        confidenceLabel: 'moderate',
        contributingSignals: <String>['short nap'],
        childName: 'Aria',
      );

      Map<String, dynamic>? pushedExtra;

      final GoRouter router = GoRouter(
        initialLocation: '/calm-heads-up',
        routes: <RouteBase>[
          GoRoute(
            path: '/calm-heads-up',
            builder: (BuildContext context, GoRouterState state) {
              return const CalmHeadsUpScreen();
            },
          ),
          GoRoute(
            path: RoutePaths.brainyConversation,
            builder: (BuildContext context, GoRouterState state) {
              if (state.extra is Map<String, dynamic>) {
                pushedExtra = Map<String, dynamic>.from(
                  state.extra as Map<String, dynamic>,
                );
              }
              return const Scaffold(body: Text('Conversation opened'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        BlocProvider<CalmHeadsUpCubit>.value(
          value: headsUpCubit,
          child: ScreenUtilInit(
            designSize: const Size(389, 780),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? _) {
              return MaterialApp.router(routerConfig: router);
            },
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Ask Brainy'), findsOneWidget);
      await tester.ensureVisible(find.text('Ask Brainy'));
      await tester.tap(find.text('Ask Brainy'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Conversation opened'), findsOneWidget);
      expect(pushedExtra, isNotNull);
      expect(pushedExtra!['topic'], 'Calm Heads-Up');
      expect(pushedExtra!['attachedContext'], contains('Skipped nap'));
      expect(pushedExtra!['attachedContext'], contains('short nap'));

      await headsUpCubit.close();
    });
  });

  group('Mentorship unavailable Ask Brainy', () {
    testWidgets('Ask Brainy instead pushes conversation with support extras', (
      WidgetTester tester,
    ) async {
      setPhoneSurface(tester);
      final MentorshipUnavailableCubit cubit = MentorshipUnavailableCubit();
      Map<String, dynamic>? pushedExtra;

      final GoRouter router = GoRouter(
        initialLocation: '/mentorship-unavailable',
        routes: <RouteBase>[
          GoRoute(
            path: '/mentorship-unavailable',
            builder: (BuildContext context, GoRouterState state) {
              return const MentorshipUnavailableScreen(
                detail: 'evening tantrums after nursery',
              );
            },
          ),
          GoRoute(
            path: RoutePaths.brainyConversation,
            builder: (BuildContext context, GoRouterState state) {
              if (state.extra is Map<String, dynamic>) {
                pushedExtra = Map<String, dynamic>.from(
                  state.extra as Map<String, dynamic>,
                );
              }
              return const Scaffold(body: Text('Conversation opened'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        BlocProvider<MentorshipUnavailableCubit>.value(
          value: cubit,
          child: ScreenUtilInit(
            designSize: const Size(389, 780),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? _) {
              return MaterialApp.router(routerConfig: router);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Ask Brainy instead'));
      await tester.tap(find.text('Ask Brainy instead'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Conversation opened'), findsOneWidget);
      expect(pushedExtra, isNotNull);
      expect(pushedExtra!['topic'], 'Support');
      expect(
        pushedExtra!['initialChat'],
        contains('evening tantrums after nursery'),
      );
      expect(
        pushedExtra!['attachedContext'],
        contains('Mentorship unavailable'),
      );

      final Map<String, dynamic> expected =
          BrainyEntryContext.fromMentorshipUnavailable(
            supportConcern: 'evening tantrums after nursery',
          );
      expect(pushedExtra!['topic'], expected['topic']);
      expect(pushedExtra!['initialChat'], expected['initialChat']);

      await cubit.close();
    });
  });
}

class _TestCalmHeadsUpCubit extends CalmHeadsUpCubit {
  @override
  void init({ChildModel? childModel}) {
    // Skip forecast load so Ask Brainy extras stay deterministic in tests.
  }
}
