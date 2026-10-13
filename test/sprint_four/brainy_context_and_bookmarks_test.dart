import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/content/brain_ai_system_prompt.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_cubit.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_state.dart';
import 'package:loving_brain/ui/brainy_history/bloc/brainy_history_cubit.dart';
import 'package:loving_brain/ui/brainy_saved_guidance/bloc/brainy_saved_guidance_cubit.dart';

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

  group('Sprint 4 — Brainy AI Context & 3-Part Clinical Guidance Tests', () {
    test(
      'BrainAiSystemPrompt builds comprehensive prompt with child context',
      () {
        final ChildModel child = ChildModel(
          childName: 'Aria',
          childAge: '24m',
          childState: ChildState.tired,
          primaryConcern: 'Frequent night wakings and bedtime pushback',
          usualBedtime: '7:30 PM',
          usualWakeTime: '6:30 AM',
          usualNaps: '1 nap, 1h 15m',
          nightWakings: '1-2 times',
          difficultTimes: <String>['Late afternoon', 'Bedtime'],
          possibleTriggers: <String>['Overtiredness', 'Transition from play'],
        );

        final String prompt = BrainAiSystemPrompt.build(
          childModel: child,
          parentName: 'Sarah',
          topic: 'Sleep',
        );

        expect(prompt, contains('Aria'));
        expect(prompt, contains('Sarah'));
        expect(prompt, contains('24m'));
        expect(prompt, contains(ChildState.tired.label));
        expect(prompt, contains('Frequent night wakings and bedtime pushback'));
        expect(prompt, contains('Bedtime: 7:30 PM'));
        expect(prompt, contains('Hardest times: Late afternoon, Bedtime'));
        expect(
          prompt,
          contains('Triggers: Overtiredness, Transition from play'),
        );
        expect(prompt, contains('Selected topic: Sleep'));

        // Verify strict clinical 3-part rules from v2-doc/05_APP_CONTENT_COPY_MASTER.md
        expect(prompt, contains('Part 1 (What may be happening)'));
        expect(prompt, contains('Part 2 (What to try now)'));
        expect(prompt, contains('Part 3 (When to get help)'));
        expect(prompt, contains('Never diagnose medical conditions'));
        expect(prompt, contains('Never use age comparison language'));
      },
    );

    test(
      'BrainAiSystemPrompt handles null child gracefully with sensible defaults',
      () {
        final String prompt = BrainAiSystemPrompt.build(
          childModel: null,
          parentName: 'Alex',
          topic: null,
        );

        expect(prompt, contains('your child'));
        expect(prompt, contains('Alex'));
        expect(prompt, contains('unknown age'));
        expect(prompt, contains('General support'));
        expect(prompt, contains('Part 1 (What may be happening)'));
        expect(prompt, contains('Part 2 (What to try now)'));
        expect(prompt, contains('Part 3 (When to get help)'));
      },
    );

    test(
      'BrainyConversationCubit initial state provides default conversational cards',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();
        await cubit.init();

        expect(cubit.state.messages.length, greaterThanOrEqualTo(3));
        expect(cubit.state.messages[0].type, MessageType.user);
        expect(cubit.state.messages[0].chipTitle, 'You asked');

        expect(cubit.state.messages[1].type, MessageType.aiInfo);
        expect(cubit.state.messages[1].chipTitle, 'What may be happening');

        expect(cubit.state.messages[2].type, MessageType.aiAction);
        expect(cubit.state.messages[2].chipTitle, 'What to try now');

        await cubit.close();
      },
    );

    test(
      'BrainyConversationCubit toggleSaveGuidance toggles isSaved in message state',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();
        await cubit.init();

        final BrainyMessage targetMessage = cubit.state.messages[1];
        expect(targetMessage.isSaved, isFalse);

        await cubit.toggleSaveGuidance(targetMessage, 1);
        expect(cubit.state.messages[1].isSaved, isTrue);

        await cubit.toggleSaveGuidance(cubit.state.messages[1], 1);
        expect(cubit.state.messages[1].isSaved, isFalse);

        await cubit.close();
      },
    );

    test(
      'BrainySavedGuidanceCubit initializes with default categorized guidance',
      () {
        final BrainySavedGuidanceCubit cubit = BrainySavedGuidanceCubit();
        cubit.init();

        expect(cubit.state.sleepItems, isNotEmpty);
        expect(cubit.state.behaviourItems, isNotEmpty);
        expect(cubit.state.parentWellbeingItems, isNotEmpty);

        expect(cubit.state.sleepItems.first.topic, 'Sleep');
        expect(cubit.state.behaviourItems.first.topic, 'Behaviour');
        expect(cubit.state.parentWellbeingItems.first.topic, 'Health');

        cubit.close();
      },
    );

    test(
      'BrainyHistoryCubit initializes with grouped conversation history',
      () {
        final BrainyHistoryCubit cubit = BrainyHistoryCubit();
        cubit.init();

        expect(cubit.state.thisWeekHistory, isNotEmpty);
        expect(cubit.state.earlierHistory, isNotEmpty);

        expect(cubit.state.thisWeekHistory.first.title, contains('bedtime'));
        expect(cubit.state.earlierHistory.first.title, contains('naps'));

        cubit.close();
      },
    );
  });
}
