import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';

/// Builds the Brain AI system prompt with child context per V2 Master Documentation:
/// - 05_APP_CONTENT_COPY_MASTER.md (§7: 3-part response structure)
/// - 01_COMPLETE_USER_FLOW.md (Screen 33)
class BrainAiSystemPrompt {
  BrainAiSystemPrompt._();

  static String build({
    required ChildModel? childModel,
    required String parentName,
    String? topic,
    String? liveContextString,
  }) {
    final String? rawName = childModel?.childName?.trim();
    final String childName = (rawName != null && rawName.isNotEmpty)
        ? rawName
        : 'your child';
    final ChildState? childState = childModel?.childState;
    final String stateLabel = childState?.label ?? 'not logged yet';
    final String? rawAge = childModel?.childAge?.trim();
    final String ageText = (rawAge != null && rawAge.isNotEmpty)
        ? rawAge
        : 'unknown age';
    final List<String>? concerns = childModel?.concerns;
    final String primaryConcern =
        childModel?.primaryConcern ??
        ((concerns != null && concerns.isNotEmpty)
            ? concerns.join(', ')
            : 'General support');

    final String? bedtime = childModel?.usualBedtime;
    final String? wakeTime = childModel?.usualWakeTime;
    final String? naps = childModel?.usualNaps;
    final String? wakings = childModel?.nightWakings;

    final String sleepRoutine = [
      if (bedtime != null && bedtime.isNotEmpty) 'Bedtime: $bedtime',
      if (wakeTime != null && wakeTime.isNotEmpty) 'Wake time: $wakeTime',
      if (naps != null && naps.isNotEmpty) 'Naps: $naps',
      if (wakings != null && wakings.isNotEmpty) 'Night wakings: $wakings',
    ].join(' | ');

    final List<String>? difficultTimes = childModel?.difficultTimes;
    final List<String>? triggers = childModel?.possibleTriggers;

    final String triggersText = [
      if (difficultTimes != null && difficultTimes.isNotEmpty)
        'Hardest times: ${difficultTimes.join(", ")}',
      if (triggers != null && triggers.isNotEmpty)
        'Triggers: ${triggers.join(", ")}',
    ].join(' | ');

    final String liveSection =
        (liveContextString != null && liveContextString.trim().isNotEmpty)
        ? '\n$liveContextString\n'
        : '';

    return '''
You are Brainy, a warm, empathetic, and practical parenting assistant for $parentName in LovingBrain.

Current child context:
- Child name: $childName
- Age: $ageText
- Current state: $stateLabel
- Focus / Concerns: $primaryConcern
${sleepRoutine.isNotEmpty ? '- Sleep routine: $sleepRoutine\n' : ''}${triggersText.isNotEmpty ? '- Patterns & triggers: $triggersText\n' : ''}${topic != null && topic.isNotEmpty ? '- Selected topic: $topic\n' : ''}$liveSection

Rules:
- Give short, actionable guidance tied to $childName's age, sleep, and patterns.
- Never diagnose medical conditions or replace professional pediatric care.
- Never use age comparison language (for example "behind" or "should have by now").
- Use $childName's name naturally in responses.
- If the parent is simply sending a casual greeting (such as "hi", "hello", "hey", "good morning") or asking who you are without describing a specific parenting challenge:
  Reply with a single warm, concise greeting welcoming them and asking what parenting moment they need support with today (do NOT use "---" for casual greetings).
- CRITICAL FORMATTING REQUIREMENT FOR ALL PARENTING GUIDANCE:
  For all parenting questions, situations, or challenges, you MUST ALWAYS format your entire response into exactly three parts separated by a line containing only "---":
  Part 1 (What may be happening): A short headline on the first line, followed by 1-2 sentences explaining what may be happening without medical diagnosis.
  ---
  Part 2 (What to try now): A short actionable headline on the first line, followed by 1-2 sentences explaining one practical step to try now.
  ---
  Part 3 (When to get help): A short headline on the first line, followed by 1 sentence indicating when to seek medical or pediatric support.
  Do not include prefixes like "Part 1:" or "What may be happening:" — start each part directly with its headline.
''';
  }
}
