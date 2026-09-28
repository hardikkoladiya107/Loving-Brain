import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';

/// Builds the Brain AI system prompt with child context per Hardik guide.
class BrainAiSystemPrompt {
  BrainAiSystemPrompt._();

  static String build({
    required ChildModel? childModel,
    required String parentName,
    String? topic,
  }) {
    final String childName =
        (childModel?.childName != null &&
            childModel!.childName!.trim().isNotEmpty)
        ? childModel.childName!.trim()
        : 'your child';
    final ChildState? childState = childModel?.childState;
    final String stateLabel = childState?.label ?? 'not logged yet';
    final String ageText =
        (childModel?.childAge != null &&
            childModel!.childAge!.trim().isNotEmpty)
        ? childModel.childAge!.trim()
        : 'unknown age';
    final String primaryConcern =
        childModel?.primaryConcern ??
        ((childModel?.concerns != null && childModel!.concerns!.isNotEmpty)
            ? childModel.concerns!.join(', ')
            : 'General support');
    final String sleepRoutine = [
      if (childModel?.usualBedtime != null &&
          childModel!.usualBedtime!.isNotEmpty)
        'Bedtime: ${childModel.usualBedtime}',
      if (childModel?.usualWakeTime != null &&
          childModel!.usualWakeTime!.isNotEmpty)
        'Wake time: ${childModel.usualWakeTime}',
      if (childModel?.usualNaps != null && childModel!.usualNaps!.isNotEmpty)
        'Naps: ${childModel.usualNaps}',
      if (childModel?.nightWakings != null &&
          childModel!.nightWakings!.isNotEmpty)
        'Night wakings: ${childModel.nightWakings}',
    ].join(' | ');

    final String triggersText = [
      if (childModel?.difficultTimes != null &&
          childModel!.difficultTimes!.isNotEmpty)
        'Hardest times: ${childModel.difficultTimes!.join(", ")}',
      if (childModel?.possibleTriggers != null &&
          childModel!.possibleTriggers!.isNotEmpty)
        'Triggers: ${childModel.possibleTriggers!.join(", ")}',
    ].join(' | ');

    return '''
You are Brainy, a warm, empathetic, and practical parenting assistant for $parentName in LovingBrain.

Current child context:
- Child name: $childName
- Age: $ageText
- Current state: $stateLabel
- Focus / Concerns: $primaryConcern
${sleepRoutine.isNotEmpty ? '- Sleep routine: $sleepRoutine' : ''}
${triggersText.isNotEmpty ? '- Patterns & triggers: $triggersText' : ''}
${topic != null && topic.isNotEmpty ? '- Selected topic: $topic' : ''}

Rules:
- Give short, actionable guidance tied to $childName's age, sleep, and patterns.
- Never diagnose medical conditions or replace professional care.
- Never use age comparison language (for example "behind" or "should have by now").
- Use $childName's name naturally in responses.
- Format your response into two clear parts separated by "---" if possible:
  Part 1 (What may be happening): A short headline on the first line, followed by 1-2 sentences explaining what may be happening.
  Part 2 (What to try now): A short actionable headline on the first line, followed by 1-2 sentences explaining what to try next.
''';
  }
}
