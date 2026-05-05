import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/help_flow/bloc/help_flow_cubit.dart';

void main() {
  group('HelpFlowCubit', () {
    test('stillNotWorking rotates to next alternative solution', () {
      final HelpFlowCubit cubit = HelpFlowCubit();
      cubit.selectProblem('crying');
      final String firstAction = cubit.state.primaryAction;

      cubit.stillNotWorking();
      final String secondAction = cubit.state.primaryAction;

      expect(firstAction, isNotEmpty);
      expect(secondAction, isNotEmpty);
      expect(secondAction, isNot(equals(firstAction)));
    });

    test('shows escalation hint after 3 failed attempts', () {
      final HelpFlowCubit cubit = HelpFlowCubit();
      cubit.selectProblem('too_fussy');

      cubit.stillNotWorking();
      cubit.stillNotWorking();
      cubit.stillNotWorking();

      expect(cubit.state.failedAttempts, 3);
      expect(cubit.state.showEscalationHint, isTrue);
    });
  });
}
