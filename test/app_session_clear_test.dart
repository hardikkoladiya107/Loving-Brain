import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_session_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/provider.dart';
import 'package:loving_brain/ui/base_screen/bloc/base_cubit.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_cubit.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_cubit.dart';
import 'package:loving_brain/ui/sleep_forecast/bloc/sleep_forecast_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
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

  group('AppSessionManager & In-Memory State Purge Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        SharedPreference.isLogin: true,
        SharedPreference.user:
            '{"uid": "user_a", "parent_name": "Hardik", "email": "hardik@example.com"}',
        SharedPreference.child: '{"child_name": "K"}',
      });
      await SharedPreference.init();
    });

    test('TodayCubit.reset() immediately returns state to empty defaults', () {
      final TodayCubit cubit = TodayCubit();
      cubit.changeProps(
        activeChildId: 'child_123',
        childName: 'K',
        parentName: 'HARDIK',
        sleepForecastStart: '6:00 pm',
        sleepForecastEnd: '7:00 pm',
        bedtimeEstimate: '6:30 pm',
        sleepForecastReason: 'Woke at 10:55 am from a longer nap',
        fellAsleepTime: '10:53 pm',
        wokeUpTime: '10:53 pm',
      );

      expect(cubit.state.activeChildId, 'child_123');
      expect(cubit.state.childName, 'K');
      expect(cubit.state.sleepForecastStart, '6:00 pm');
      expect(cubit.state.sleepForecastReason.isNotEmpty, isTrue);

      cubit.reset();

      expect(cubit.state.activeChildId, '');
      expect(cubit.state.childName, '');
      expect(cubit.state.parentName, '');
      expect(cubit.state.sleepForecastStart, '--:--');
      expect(cubit.state.sleepForecastReason, '');
      expect(cubit.state.fellAsleepTime, isNull);
      expect(cubit.state.wokeUpTime, isNull);
    });

    test('BrainyConversationCubit.reset() wipes chat and audio states', () {
      final BrainyConversationCubit cubit = BrainyConversationCubit();
      cubit.changeProps(isAudioPlaying: true, isAttachedAudioPlaying: true);

      expect(cubit.state.isAudioPlaying, isTrue);
      expect(cubit.state.isAttachedAudioPlaying, isTrue);

      cubit.reset();

      expect(cubit.state.isAudioPlaying, isFalse);
      expect(cubit.state.isAttachedAudioPlaying, isFalse);
      expect(cubit.state.messages, isEmpty);
    });

    test(
      'FamilyMenuCubit and SleepForecastCubit reset() methods clean memory',
      () {
        final FamilyMenuCubit familyCubit = FamilyMenuCubit();
        familyCubit.changeProps(childName: 'K');
        expect(familyCubit.state.childName, 'K');
        familyCubit.reset();
        expect(familyCubit.state.childName, 'your child');

        final SleepForecastCubit sleepCubit = SleepForecastCubit();
        sleepCubit.changeProps(childName: 'K', windowStart: '6:00 pm');
        expect(sleepCubit.state.childName, 'K');
        sleepCubit.reset();
        expect(sleepCubit.state.childName, 'your child');
        expect(sleepCubit.state.windowStart, '07:45 PM');
      },
    );

    testWidgets(
      'AppSessionManager.clearAllSessionStates resets all cubits and prevents data leaking to next user',
      (WidgetTester tester) async {
        late BuildContext capturedContext;

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: blocProvider,
            child: MaterialApp(
              home: Builder(
                builder: (BuildContext context) {
                  capturedContext = context;
                  return const Scaffold(body: Text('Active Session'));
                },
              ),
            ),
          ),
        );

        // 1. Simulate User A logged in with child 'K' and bedtime window '6:00 pm'
        final TodayCubit todayCubit = capturedContext.read<TodayCubit>();
        todayCubit.changeProps(
          activeChildId: 'user_a_child_k',
          childName: 'K',
          parentName: 'HARDIK',
          sleepForecastStart: '6:00 pm',
          sleepForecastEnd: '7:00 pm',
          sleepForecastReason: 'K woke at 10:55 am from a longer nap',
        );

        final BaseCubit baseCubit = capturedContext.read<BaseCubit>();
        baseCubit.changeProps(bottomNavigationIndex: 2);

        expect(todayCubit.state.childName, 'K');
        expect(todayCubit.state.parentName, 'HARDIK');
        expect(todayCubit.state.sleepForecastStart, '6:00 pm');

        // 2. User A logs out -> clearAllSessionStates() is invoked
        await AppSessionManager.instance.clearAllSessionStates(
          context: capturedContext,
        );

        // Verify preferences are cleared
        expect(
          preferences.getBool(SharedPreference.isLogin, defValue: false),
          isFalse,
        );
        expect(preferences.getUserModel(), isNull);
        expect(preferences.getChildModel(), isNull);

        // Verify cubits in memory are completely reset to initial/empty
        expect(todayCubit.state.childName, '');
        expect(todayCubit.state.parentName, '');
        expect(todayCubit.state.sleepForecastStart, '--:--');
        expect(todayCubit.state.sleepForecastReason, '');
        expect(todayCubit.state.activeChildId, '');

        // 3. User B logs in with child 'Emma'
        await preferences.saveUserModel(
          UserModel(
            uid: 'user_b',
            parentName: 'Sarah',
            email: 'sarah@example.com',
          ),
        );
        await preferences.saveChildModel(
          ChildModel(childName: 'Emma', childAge: '24 months'),
        );
        await preferences.putBool(SharedPreference.isLogin, true);

        // 4. User B opens app, TodayCubit.init() runs
        await todayCubit.init();

        // 5. Ensure NO residual data from User A exists in TodayCubit
        expect(todayCubit.state.childName, 'Emma');
        expect(todayCubit.state.parentName, 'SARAH');
        expect(todayCubit.state.activeChildId.contains('local_Emma'), isTrue);
        expect(
          todayCubit.state.sleepForecastReason.contains('K woke at'),
          isFalse,
        );
      },
    );
  });
}
