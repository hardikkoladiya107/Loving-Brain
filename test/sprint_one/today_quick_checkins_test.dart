import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_state.dart';

void main() {
  group('Today Tab - Sprint 1 Models & Serialization Tests', () {
    test('SleepLogModel serializes and deserializes accurately with V2 fields', () {
      final DateTime now = DateTime(2026, 10, 13, 14, 30);
      final DateTime bed = DateTime(2026, 10, 13, 13, 0);
      final DateTime wake = DateTime(2026, 10, 13, 14, 30);

      final SleepLogModel model = SleepLogModel(
        id: 'sleep_123',
        date: DateTime(2026, 10, 13),
        bedTime: bed,
        wakeTime: wake,
        fellAsleepTime: '01:00 PM',
        wokeUpTime: '02:30 PM',
        isNightWaking: false,
        sleepQualityIndex: 4,
        durationMinutes: 90,
        userId: 'user_xyz',
        childId: 'child_abc',
        createdAt: now,
      );

      final Map<String, dynamic> map = model.toMap();
      expect(map['fellAsleepTime'], equals('01:00 PM'));
      expect(map['wokeUpTime'], equals('02:30 PM'));
      expect(map['isNightWaking'], isFalse);
      expect(map['sleepQualityIndex'], equals(4));
      expect(map['durationMinutes'], equals(90));
      expect(map['userId'], equals('user_xyz'));
      expect(map['childId'], equals('child_abc'));
      expect(map['date'], isA<Timestamp>());
      expect(map['bedTime'], isA<Timestamp>());
      expect(map['wakeTime'], isA<Timestamp>());
    });

    test('TantrumLogModel handles round-trip data accurately', () {
      final DateTime eventTime = DateTime(2026, 10, 13, 17, 20);
      final TantrumLogModel model = TantrumLogModel(
        id: 'tantrum_456',
        whatHappened: 'Refused to leave the park',
        time: '05:20 PM',
        timestamp: eventTime,
        intensity: 0.8,
        triggers: <String>['Hunger', 'Transition'],
        whatHelped: 'Holding her close and soft singing',
        userId: 'user_123',
        childId: 'child_ira',
        createdAt: eventTime,
      );

      final Map<String, dynamic> map = model.toMap();
      expect(map['whatHappened'], equals('Refused to leave the park'));
      expect(map['time'], equals('05:20 PM'));
      expect(map['intensity'], equals(0.8));
      expect(map['triggers'], containsAll(<String>['Hunger', 'Transition']));
      expect(map['whatHelped'], equals('Holding her close and soft singing'));

      final TantrumLogModel parsed = TantrumLogModel.fromMap(map, id: 'tantrum_456');
      expect(parsed.whatHappened, equals(model.whatHappened));
      expect(parsed.time, equals(model.time));
      expect(parsed.intensity, equals(model.intensity));
      expect(parsed.triggers, equals(model.triggers));
      expect(parsed.whatHelped, equals(model.whatHelped));
      expect(parsed.childId, equals('child_ira'));
    });

    test('MoodLogModel supports child mood index and parent mood', () {
      final DateTime now = DateTime(2026, 10, 13, 11, 0);
      final MoodLogModel model = MoodLogModel(
        id: 'mood_789',
        childMood: 'Happy',
        childMoodIndex: 0,
        parentMood: 'Calm',
        logTime: now,
        userId: 'user_123',
        childId: 'child_ira',
        createdAt: now,
      );

      final Map<String, dynamic> map = model.toMap();
      expect(map['child_mood'], equals('Happy'));
      expect(map['child_mood_index'], equals(0));
      expect(map['parent_mood'], equals('Calm'));
      expect(map['childId'], equals('child_ira'));

      final MoodLogModel parsed = MoodLogModel.fromMap(map, id: 'mood_789');
      expect(parsed.childMood, equals('Happy'));
      expect(parsed.childMoodIndex, equals(0));
      expect(parsed.parentMood, equals('Calm'));
      expect(parsed.childId, equals('child_ira'));
    });

    test('HealthLogModel stores issues and notes cleanly', () {
      final DateTime now = DateTime(2026, 10, 13, 9, 15);
      final HealthLogModel model = HealthLogModel(
        id: 'health_999',
        issues: <String>['Teething', 'Low appetite'],
        notes: 'Warm cheeks since this afternoon',
        timestamp: now,
        userId: 'user_123',
        childId: 'child_ira',
        createdAt: now,
      );

      final Map<String, dynamic> map = model.toMap();
      expect(map['issues'], containsAll(<String>['Teething', 'Low appetite']));
      expect(map['notes'], equals('Warm cheeks since this afternoon'));

      final HealthLogModel parsed = HealthLogModel.fromMap(map, id: 'health_999');
      expect(parsed.issues, equals(<String>['Teething', 'Low appetite']));
      expect(parsed.notes, equals('Warm cheeks since this afternoon'));
    });

    test('QuickNoteModel serializes freeform parent notes', () {
      final DateTime now = DateTime(2026, 10, 13, 16, 45);
      final QuickNoteModel model = QuickNoteModel(
        id: 'note_111',
        note: 'Grandparents visited today. Skipped afternoon quiet time.',
        timestamp: now,
        userId: 'user_123',
        childId: 'child_ira',
        createdAt: now,
      );

      final Map<String, dynamic> map = model.toMap();
      expect(map['note'], equals('Grandparents visited today. Skipped afternoon quiet time.'));

      final QuickNoteModel parsed = QuickNoteModel.fromMap(map, id: 'note_111');
      expect(parsed.note, equals(model.note));
      expect(parsed.childId, equals('child_ira'));
    });

    test('TodayLogRepo.parseTimeString parses 12h AM/PM strings correctly', () {
      final DateTime base = DateTime(2026, 10, 13);
      final DateTime dtMorning = TodayLogRepo.parseTimeString('07:30 AM', referenceDate: base);
      expect(dtMorning.hour, equals(7));
      expect(dtMorning.minute, equals(30));

      final DateTime dtEvening = TodayLogRepo.parseTimeString('08:15 PM', referenceDate: base);
      expect(dtEvening.hour, equals(20));
      expect(dtEvening.minute, equals(15));

      final DateTime dtNoPad = TodayLogRepo.parseTimeString('5:20 PM', referenceDate: base);
      expect(dtNoPad.hour, equals(17));
      expect(dtNoPad.minute, equals(20));
    });

    test('TimelineEventModel parses new quick check-in event types', () {
      final Map<String, dynamic> sleepData = <String, dynamic>{
        'type': 'sleep_log',
        'title': 'Sleep logged',
        'subtitle': '90 min sleep • Quality: 4/5',
        'timestamp': Timestamp.fromDate(DateTime(2026, 10, 13, 14, 0)),
      };

      // Mock DocumentSnapshot behavior via static parsing methods
      expect(
        TimelineEventModel.fromFirestore(
          _FakeDocSnapshot('event_1', sleepData),
        ).title,
        equals('Sleep logged'),
      );
      expect(
        TimelineEventModel.fromFirestore(
          _FakeDocSnapshot('event_1', sleepData),
        ).subtitle,
        equals('90 min sleep • Quality: 4/5'),
      );
    });
  });

  group('TodayCubit - State Management & Form Validation Tests', () {
    late TodayCubit cubit;

    setUp(() {
      cubit = TodayCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has clean default values', () {
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.isSuccess, isFalse);
      expect(cubit.state.fellAsleepTime, isNull);
      expect(cubit.state.wokeUpTime, isNull);
      expect(cubit.state.selectedChildMoodIndex, equals(-1));
      expect(cubit.state.selectedHealthIssues, isEmpty);
      expect(cubit.state.quickNoteText, isEmpty);
      expect(cubit.state.showSleepUpdateErrors, isFalse);
      expect(cubit.state.showTantrumUpdateErrors, isFalse);
      expect(cubit.state.showMoodUpdateErrors, isFalse);
      expect(cubit.state.showHealthUpdateErrors, isFalse);
      expect(cubit.state.showNotesUpdateErrors, isFalse);
    });

    test('sleep form setters update state and clear error flag', () {
      cubit.triggerSleepUpdateErrors();
      expect(cubit.state.showSleepUpdateErrors, isTrue);

      cubit.setFellAsleepTime('01:30 PM');
      expect(cubit.state.fellAsleepTime, equals('01:30 PM'));
      expect(cubit.state.showSleepUpdateErrors, isFalse);

      cubit.setWokeUpTime('03:00 PM');
      expect(cubit.state.wokeUpTime, equals('03:00 PM'));

      cubit.toggleNightWaking(true);
      expect(cubit.state.isNightWaking, isTrue);

      cubit.setSleepQuality(4);
      expect(cubit.state.sleepQualityIndex, equals(4));
    });

    test('tantrum trigger toggle adds and removes triggers correctly', () {
      expect(cubit.state.selectedTantrumTriggers, isEmpty);

      cubit.toggleTantrumTrigger('Hunger');
      expect(cubit.state.selectedTantrumTriggers, contains('Hunger'));

      cubit.toggleTantrumTrigger('Transition');
      expect(cubit.state.selectedTantrumTriggers, containsAll(<String>['Hunger', 'Transition']));

      cubit.toggleTantrumTrigger('Hunger');
      expect(cubit.state.selectedTantrumTriggers, isNot(contains('Hunger')));
      expect(cubit.state.selectedTantrumTriggers, contains('Transition'));
    });

    test('health issues toggle adds and removes issues correctly', () {
      cubit.toggleHealthIssue('Fever');
      expect(cubit.state.selectedHealthIssues, contains('Fever'));

      cubit.toggleHealthIssue('Teething');
      expect(cubit.state.selectedHealthIssues, containsAll(<String>['Fever', 'Teething']));

      cubit.toggleHealthIssue('Fever');
      expect(cubit.state.selectedHealthIssues, equals(<String>['Teething']));
    });

    test('validation trigger methods set error flags on empty inputs', () {
      cubit.triggerSleepUpdateErrors();
      expect(cubit.state.showSleepUpdateErrors, isTrue);

      cubit.triggerMoodUpdateErrors();
      expect(cubit.state.showMoodUpdateErrors, isTrue);

      cubit.triggerTantrumUpdateErrors();
      expect(cubit.state.showTantrumUpdateErrors, isTrue);

      cubit.triggerHealthUpdateErrors();
      expect(cubit.state.showHealthUpdateErrors, isTrue);

      cubit.triggerNotesUpdateErrors();
      expect(cubit.state.showNotesUpdateErrors, isTrue);
    });

    test('saving with incomplete fields flags errors without throwing', () async {
      // Incomplete sleep log: fellAsleepTime missing
      await cubit.saveSleepLog();
      expect(cubit.state.showSleepUpdateErrors, isTrue);
      expect(cubit.state.isLoading, isFalse);

      // Incomplete mood log: no face selected (-1)
      await cubit.saveMoodLog();
      expect(cubit.state.showMoodUpdateErrors, isTrue);
      expect(cubit.state.isLoading, isFalse);

      // Incomplete tantrum log: empty description
      await cubit.saveTantrumLog();
      expect(cubit.state.showTantrumUpdateErrors, isTrue);
      expect(cubit.state.isLoading, isFalse);

      // Incomplete health log: no issues selected
      await cubit.saveHealthLog();
      expect(cubit.state.showHealthUpdateErrors, isTrue);
      expect(cubit.state.isLoading, isFalse);

      // Incomplete quick note: empty string
      await cubit.saveQuickNote();
      expect(cubit.state.showNotesUpdateErrors, isTrue);
      expect(cubit.state.isLoading, isFalse);
    });
  });
}

/// Lightweight mock DocumentSnapshot for testing TimelineEventModel.
class _FakeDocSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  _FakeDocSnapshot(this._id, this._data);

  final String _id;
  final Map<String, dynamic> _data;

  @override
  String get id => _id;

  @override
  Map<String, dynamic>? data() => _data;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
