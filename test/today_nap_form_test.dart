import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';

void main() {
  test('nap switch, extra naps, and delete rules', () {
    final TodayCubit cubit = TodayCubit();

    expect(cubit.state.includeNaps, isFalse);
    expect(cubit.state.napDrafts, isEmpty);

    cubit.setIncludeNaps(true);
    expect(cubit.state.napDrafts.length, 1);

    cubit.addNapDraft();
    cubit.addNapDraft();
    expect(cubit.state.napDrafts.length, 3);

    cubit.removeNapDraft(0);
    expect(cubit.state.napDrafts.length, 3);

    cubit.removeNapDraft(2);
    expect(cubit.state.napDrafts.length, 2);

    cubit.setIncludeNaps(false);
    expect(cubit.state.includeNaps, isFalse);
    expect(cubit.state.napDrafts, isEmpty);

    cubit.close();
  });

  test('save blocks an incomplete nap and an end before start', () async {
    final TodayCubit cubit = TodayCubit();
    cubit.setFellAsleepTime('09:00 PM');
    cubit.setWokeUpTime('06:00 AM');
    cubit.setIncludeNaps(true);

    await cubit.saveSleepLog();
    expect(cubit.state.showSleepUpdateErrors, isTrue);
    expect(cubit.state.napDrafts.first.error, 'Required');
    expect(cubit.state.isLoading, isFalse);

    cubit.setNapDraftStart(0, '03:00 PM');
    cubit.setNapDraftEnd(0, '01:00 PM');
    await cubit.saveSleepLog();
    expect(cubit.state.napDrafts.first.error, 'Nap must end after it starts');

    cubit.close();
  });

  test('save blocks overlapping naps and a nap inside night sleep', () async {
    final TodayCubit cubit = TodayCubit();
    cubit.setFellAsleepTime('01:00 AM');
    cubit.setWokeUpTime('06:00 AM');
    cubit.setIncludeNaps(true);
    cubit.setNapDraftStart(0, '02:00 AM');
    cubit.setNapDraftEnd(0, '03:00 AM');

    await cubit.saveSleepLog();
    expect(cubit.state.napDrafts.first.error, 'This nap overlaps night sleep');

    cubit.setFellAsleepTime('09:00 PM');
    cubit.setWokeUpTime('10:30 PM');
    cubit.setNapDraftStart(0, '01:00 AM');
    cubit.setNapDraftEnd(0, '01:40 AM');
    cubit.addNapDraft();
    cubit.setNapDraftStart(1, '01:20 AM');
    cubit.setNapDraftEnd(1, '02:00 AM');

    await cubit.saveSleepLog();
    expect(cubit.state.napDrafts[0].error, TodayCubit.napOverlapError);
    expect(cubit.state.napDrafts[1].error, TodayCubit.napOverlapError);
    expect(cubit.state.isLoading, isFalse);

    cubit.close();
  });

  test('overlapping naps are flagged on both rows as soon as times match', () {
    final TodayCubit cubit = TodayCubit();
    cubit.setIncludeNaps(true);
    cubit.setNapDraftStart(0, '08:00 AM');
    cubit.setNapDraftEnd(0, '09:30 AM');
    cubit.addNapDraft();
    cubit.setNapDraftStart(1, '09:00 AM');
    cubit.setNapDraftEnd(1, '10:00 AM');

    expect(cubit.state.showSleepUpdateErrors, isTrue);
    expect(cubit.state.napDrafts[0].error, TodayCubit.napOverlapError);
    expect(cubit.state.napDrafts[1].error, TodayCubit.napOverlapError);

    cubit.addNapDraft();
    cubit.setNapDraftStart(2, '09:15 AM');
    cubit.setNapDraftEnd(2, '09:45 AM');
    expect(cubit.state.napDrafts[2].error, TodayCubit.napOverlapError);

    cubit.setNapDraftStart(1, '10:00 AM');
    cubit.setNapDraftEnd(1, '10:40 AM');
    cubit.setNapDraftStart(2, '11:00 AM');
    cubit.setNapDraftEnd(2, '11:30 AM');
    expect(cubit.state.napDrafts[0].error, isEmpty);
    expect(cubit.state.napDrafts[1].error, isEmpty);
    expect(cubit.state.napDrafts[2].error, isEmpty);

    cubit.close();
  });

  test('identical nap times and a nap inside another nap are overlaps', () {
    final TodayCubit cubit = TodayCubit();
    cubit.setIncludeNaps(true);
    cubit.setNapDraftStart(0, '08:00 AM');
    cubit.setNapDraftEnd(0, '09:00 AM');
    cubit.addNapDraft();
    cubit.setNapDraftStart(1, '08:00 AM');
    cubit.setNapDraftEnd(1, '09:00 AM');
    expect(cubit.state.napDrafts[0].error, TodayCubit.napOverlapError);
    expect(cubit.state.napDrafts[1].error, TodayCubit.napOverlapError);

    cubit.setNapDraftStart(1, '08:15 AM');
    cubit.setNapDraftEnd(1, '08:40 AM');
    expect(cubit.state.napDrafts[0].error, TodayCubit.napOverlapError);
    expect(cubit.state.napDrafts[1].error, TodayCubit.napOverlapError);

    cubit.removeNapDraft(1);
    expect(cubit.state.napDrafts.length, 1);
    expect(cubit.state.napDrafts.first.error, isEmpty);

    cubit.close();
  });

  test('a future nap end names that time in the error', () async {
    final DateTime now = DateTime.now();
    final DateTime start = now.subtract(const Duration(minutes: 40));
    final DateTime end = now.add(const Duration(hours: 1));
    final String startLabel = DateFormat('hh:mm a').format(start);
    final String endLabel = DateFormat('hh:mm a').format(end);

    final TodayCubit cubit = TodayCubit();
    cubit.setIncludeNaps(true);
    cubit.setNapDraftStart(0, startLabel);
    cubit.setNapDraftEnd(0, endLabel);
    await cubit.saveSleepLog();

    expect(cubit.state.showSleepUpdateErrors, isTrue);
    expect(cubit.state.napDrafts.first.error, contains(endLabel));
    expect(cubit.state.napDrafts.first.error, contains('already past'));
    expect(cubit.state.isLoading, isFalse);
    cubit.close();
  });

  test('add nap stops at four', () {
    final TodayCubit cubit = TodayCubit();
    cubit.setIncludeNaps(true);
    cubit.addNapDraft();
    cubit.addNapDraft();
    cubit.addNapDraft();
    cubit.addNapDraft();
    expect(cubit.state.napDrafts.length, TodayCubit.maxNapsPerUpdate);
    cubit.close();
  });
}
