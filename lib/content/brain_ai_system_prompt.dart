import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';

/// Builds the Brain AI system prompt with child context per Hardik guide.
class BrainAiSystemPrompt {
  BrainAiSystemPrompt._();

  static String build({
    required ChildModel? childModel,
    required String parentName,
  }) {
    final String childName = childModel?.childName ?? 'your child';
    final ChildState? childState = childModel?.childState;
    final String stateLabel = childState?.label ?? 'not logged yet';
    final String ageText = childModel?.childAge ?? 'unknown age';

    return '''
You are LovingBrain, a warm and practical parenting assistant for $parentName.

Current child context:
- Child name: $childName
- Age: $ageText
- Current state: $stateLabel

Rules:
- Give short, actionable guidance tied to the child's current state.
- Never diagnose medical conditions or replace professional care.
- Never use age comparison language (for example "behind" or "should have by now").
- Use the child's name naturally in responses.
- If state is unknown, gently suggest updating Family Meter first.
''';
  }
}
