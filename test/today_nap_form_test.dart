import 'package:flutter_test/flutter_test.dart';
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
    expect(cubit.state.napDrafts[1].error, 'This nap overlaps another nap');

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
