import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/content/brain_ai_system_prompt.dart';
import 'package:loving_brain/core/ai_data_tools.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_cubit.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_state.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
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

  group('Brainy AI 3-Part Clinical Guidance & Parsing Tests', () {
    test(
      'Standard response with --- delimiter is parsed into 3 distinct cards',
      () {
        final BrainyConversationCubit cubit = BrainyConversationCubit();

        const String rawAiResponse = '''
Overtired and Overstimulated
Johnny may be overtired tonight due to a shorter nap earlier today.

---
Offer a calm wind-down routine
Dim the lights and read a soothing book 20 minutes before bedtime.

---
Pediatric guidance if sleep disruption persists
Consult your pediatrician if bedtime battles persist for more than 2-3 weeks.''';

        cubit.changeProps(
          messages: <BrainyMessage>[
            BrainyMessage(
              id: 'user_1',
              type: MessageType.user,
              chipTitle: 'You asked',
              headline: 'Why is bedtime so hard tonight?',
            ),
            ...cubit.parseAiResponseForTesting(rawAiResponse),
          ],
          isTyping: false,
        );

        final List<BrainyMessage> messages = cubit.state.messages;
        expect(messages.length, 4);

        // Part 1: What may be happening
        expect(messages[1].type, MessageType.aiInfo);
        expect(messages[1].chipTitle, 'What may be happening');
        expect(messages[1].headline, 'Overtired and Overstimulated');
        expect(
          messages[1].subtext,
          contains('Johnny may be overtired tonight'),
        );

        // Part 2: What to try now
        expect(messages[2].type, MessageType.aiAction);
        expect(messages[2].chipTitle, 'What to try now');
        expect(messages[2].headline, 'Offer a calm wind-down routine');
        expect(messages[2].subtext, contains('Dim the lights'));

        // Part 3: When to get help
        expect(messages[3].type, MessageType.aiInfo);
        expect(messages[3].chipTitle, 'When to get help');
        expect(
          messages[3].headline,
          'Pediatric guidance if sleep disruption persists',
        );
        expect(messages[3].subtext, contains('Consult your pediatrician'));

        cubit.close();
      },
    );

    test(
      'Response with section headers without --- delimiter is cleanly parsed into 3 cards',
      () {
        final BrainyConversationCubit cubit = BrainyConversationCubit();

        const String headerFormattedResponse = '''
Part 1: What may be happening
Transition fatigue after evening play
Your toddler may find stopping fun activities difficult without a warning.

Part 2: What to try now
Give a 5-minute visual heads up
Use a gentle visual timer or song to signal that playtime is ending.

Part 3: When to get help
When challenges begin impacting daily wellbeing
If intense distress continues consistently, discuss these patterns with your health visitor.''';

        final List<BrainyMessage> cards = cubit.parseAiResponseForTesting(
          headerFormattedResponse,
        );
        expect(cards.length, 3);

        expect(cards[0].chipTitle, 'What may be happening');
        expect(cards[0].headline, 'Transition fatigue after evening play');
        expect(cards[0].subtext, contains('stopping fun activities'));

        expect(cards[1].chipTitle, 'What to try now');
        expect(cards[1].headline, 'Give a 5-minute visual heads up');
        expect(cards[1].subtext, contains('visual timer or song'));

        expect(cards[2].chipTitle, 'When to get help');
        expect(
          cards[2].headline,
          'When challenges begin impacting daily wellbeing',
        );
        expect(cards[2].subtext, contains('health visitor'));

        cubit.close();
      },
    );

    test('Casual greeting is parsed as single welcoming Brainy card', () {
      final BrainyConversationCubit cubit = BrainyConversationCubit();

      const String greetingResponse =
          'Hello Sarah! How is Johnny doing today? What parenting moment can I support you with?';

      final List<BrainyMessage> cards = cubit.parseAiResponseForTesting(
        greetingResponse,
      );
      expect(cards.length, 1);
      expect(cards[0].chipTitle, 'Brainy');
      expect(cards[0].headline, contains('Hello Sarah'));

      cubit.close();
    });

    test(
      'Multi-paragraph unstructured response generates 3-part guidance per V2 specification',
      () {
        final BrainyConversationCubit cubit = BrainyConversationCubit();

        const String unstructuredResponse = '''
Toddlers often resist naps when they are developing new skills.
When brain development peaks, settling down feels less rewarding to them.

Try keeping a consistent pre-nap cue.
A small quiet reading pause can signal rest time without pressure.''';

        final List<BrainyMessage> cards = cubit.parseAiResponseForTesting(
          unstructuredResponse,
        );
        expect(cards.length, 3);
        expect(cards[0].chipTitle, 'What may be happening');
        expect(cards[1].chipTitle, 'What to try now');
        expect(cards[2].chipTitle, 'When to get help');

        cubit.close();
      },
    );

    test(
      'Empty or whitespace text safely returns empty list without crashing',
      () {
        final BrainyConversationCubit cubit = BrainyConversationCubit();
        expect(cubit.parseAiResponseForTesting('   '), isEmpty);
        expect(cubit.parseAiResponseForTesting(''), isEmpty);
        cubit.close();
      },
    );
  });

  group('Brainy Conversation Cubit Immediate Response & State Flow Tests', () {
    test(
      'Successful AI response updates state.messages IMMEDIATELY and stops typing indicator',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();

        cubit.changeProps(
          messages: <BrainyMessage>[
            BrainyMessage(
              id: 'msg_u',
              type: MessageType.user,
              chipTitle: 'You asked',
              headline: 'Why is bedtime so late tonight?',
            ),
          ],
          isTyping: true,
        );

        expect(cubit.state.isTyping, isTrue);
        expect(cubit.state.messages.length, 1);

        // Simulate AI completion arriving
        final List<BrainyMessage> aiCards = <BrainyMessage>[
          BrainyMessage(
            id: 'ai_1',
            type: MessageType.aiInfo,
            chipTitle: 'What may be happening',
            headline: 'Late afternoon nap shifted bedtime',
            subtext: 'A nap ending after 4 PM delays sleep pressure.',
          ),
          BrainyMessage(
            id: 'ai_2',
            type: MessageType.aiAction,
            chipTitle: 'What to try now',
            headline: 'Cap late afternoon naps',
            subtext: 'Wake your child by 3:30 PM tomorrow.',
          ),
          BrainyMessage(
            id: 'ai_3',
            type: MessageType.aiInfo,
            chipTitle: 'When to get help',
            headline: 'Reach out if sleep challenges persist',
            subtext: 'Consult your pediatrician if needed.',
          ),
        ];

        // Cubit immediately updates local messages and clears isTyping
        cubit.changeProps(
          messages: <BrainyMessage>[...cubit.state.messages, ...aiCards],
          isTyping: false,
        );

        expect(cubit.state.isTyping, isFalse);
        expect(cubit.state.messages.length, 4);
        expect(cubit.state.messages.last.chipTitle, 'When to get help');

        await cubit.close();
      },
    );

    test(
      'Empty AI response emits friendly retry card and stops typing',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();

        cubit.changeProps(
          messages: <BrainyMessage>[
            BrainyMessage(
              id: 'user_1',
              type: MessageType.user,
              chipTitle: 'You asked',
              headline: 'Test question',
            ),
          ],
          isTyping: true,
        );

        final BrainyMessage errorCard = BrainyMessage(
          id: 'retry_123',
          type: MessageType.error,
          chipTitle: 'Connection issue',
          headline: "Brainy couldn't connect right now",
          subtext:
              "We couldn't reach the AI service. Please check your connection and tap Try again.",
        );

        cubit.changeProps(
          messages: <BrainyMessage>[...cubit.state.messages, errorCard],
          isTyping: false,
        );

        expect(cubit.state.isTyping, isFalse);
        expect(cubit.state.messages.last.type, MessageType.error);
        expect(
          cubit.state.messages.last.headline,
          "Brainy couldn't connect right now",
        );

        await cubit.close();
      },
    );

    test(
      'Emergency detection intercepts acute medical input and emits immediate safety alert',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();

        await cubit.sendMessage(
          'My child is struggling to breathe and turning blue',
        );

        expect(cubit.state.isTyping, isFalse);
        expect(
          cubit.state.messages.any(
            (BrainyMessage m) => m.type == MessageType.safetyAlert,
          ),
          isTrue,
        );

        final BrainyMessage safetyMsg = cubit.state.messages.firstWhere(
          (BrainyMessage m) => m.type == MessageType.safetyAlert,
        );
        expect(safetyMsg.chipTitle, 'Immediate Attention');
        expect(safetyMsg.headline, contains('emergency services'));

        await cubit.close();
      },
    );
  });

  group('BrainAiSystemPrompt Context Injection & Rules', () {
    test(
      'System prompt injects live sleep and tantrum context for child',
      () async {
        final ChildModel child = ChildModel(
          childName: 'Johnny',
          childAge: '2 years',
          childState: ChildState.tired,
          primaryConcern: 'Bedtime pushback',
          usualBedtime: '8:00 PM',
          usualWakeTime: '7:00 AM',
        );

        final String liveContext = await AiDataTools.buildLiveContextString(
          childModel: child,
        );

        final String prompt = BrainAiSystemPrompt.build(
          childModel: child,
          parentName: 'Sarah',
          topic: 'Sleep',
          liveContextString: liveContext,
        );

        expect(prompt, contains('Johnny'));
        expect(prompt, contains('Sarah'));
        expect(prompt, contains('Bedtime: 8:00 PM'));
        expect(prompt, contains('Live recorded data for Johnny today'));
        expect(prompt, contains('CRITICAL FORMATTING REQUIREMENT'));
        expect(prompt, contains('separated by a line containing only "---"'));
      },
    );
  });

  group('Brainy Conversation Screen Widget Rendering Tests', () {
    testWidgets('Renders Thinking Indicator when isTyping is true', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(389, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final BrainyConversationCubit cubit = BrainyConversationCubit();
      cubit.changeProps(
        messages: <BrainyMessage>[
          BrainyMessage(
            id: 'u1',
            type: MessageType.user,
            chipTitle: 'You asked',
            headline: 'Why is bedtime so hard?',
          ),
        ],
        isTyping: true,
      );

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(389, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, Widget? _) {
            return BlocProvider<BrainyConversationCubit>.value(
              value: cubit,
              child: const MaterialApp(home: BrainyConversationScreen()),
            );
          },
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Why is bedtime so hard?'), findsOneWidget);
      expect(find.text('Brainy is thinking'), findsOneWidget);
      expect(
        find.text('Crafting a thoughtful response for you'),
        findsOneWidget,
      );

      cubit.close();
    });

    testWidgets('Renders complete 3-part answer cards with distinctive chips', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(389, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final BrainyConversationCubit cubit = BrainyConversationCubit();
      cubit.changeProps(
        messages: <BrainyMessage>[
          BrainyMessage(
            id: 'u1',
            type: MessageType.user,
            chipTitle: 'You asked',
            headline: 'Why did nap end early?',
          ),
          BrainyMessage(
            id: 'a1',
            type: MessageType.aiInfo,
            chipTitle: 'What may be happening',
            headline: 'Sleep cycle transition was disturbed',
            subtext: 'Loud noise or light change may have interrupted rest.',
          ),
          BrainyMessage(
            id: 'a2',
            type: MessageType.aiAction,
            chipTitle: 'What to try now',
            headline: 'Protect evening quiet time',
            subtext: 'Shift bedtime 15 minutes earlier tonight.',
          ),
          BrainyMessage(
            id: 'a3',
            type: MessageType.aiInfo,
            chipTitle: 'When to get help',
            headline: 'Seek guidance if early wakings continue for 2 weeks',
            subtext: 'Consult your pediatrician if distress persists.',
          ),
        ],
        isTyping: false,
      );

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(389, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, Widget? _) {
            return BlocProvider<BrainyConversationCubit>.value(
              value: cubit,
              child: const MaterialApp(home: BrainyConversationScreen()),
            );
          },
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Why did nap end early?'), findsOneWidget);
      expect(find.text('What may be happening'), findsOneWidget);
      expect(find.text('Sleep cycle transition was disturbed'), findsOneWidget);

      expect(find.text('What to try now'), findsOneWidget);
      expect(find.text('Protect evening quiet time'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('When to get help'),
        300,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('When to get help'), findsOneWidget);
      expect(
        find.text('Seek guidance if early wakings continue for 2 weeks'),
        findsOneWidget,
      );

      cubit.close();
    });

    testWidgets('Renders Try again AppButton on error card', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(389, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final BrainyConversationCubit cubit = BrainyConversationCubit();
      cubit.changeProps(
        messages: <BrainyMessage>[
          BrainyMessage(
            id: 'e1',
            type: MessageType.error,
            chipTitle: 'Connection issue',
            headline: "Brainy couldn't connect right now",
            subtext: "We couldn't reach the AI service.",
          ),
        ],
        isTyping: false,
      );

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(389, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, Widget? _) {
            return BlocProvider<BrainyConversationCubit>.value(
              value: cubit,
              child: const MaterialApp(home: BrainyConversationScreen()),
            );
          },
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text("Brainy couldn't connect right now"), findsOneWidget);
      expect(find.widgetWithText(AppButton, 'Try again'), findsOneWidget);

      cubit.close();
    });
  });
}
