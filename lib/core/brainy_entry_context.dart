import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/preferances.dart';

/// Builds conversation launch extras so Ask Brainy entry points attach real
/// screen context (v2 screens 28/29/32/45/71 and Journey review flows).
class BrainyEntryContext {
  BrainyEntryContext._();

  static Map<String, dynamic> extras({
    required String topic,
    required String initialChat,
    String? attachedContext,
  }) {
    return <String, dynamic>{
      'topic': topic,
      'initialChat': initialChat.trim(),
      if (attachedContext != null && attachedContext.trim().isNotEmpty)
        'attachedContext': attachedContext.trim(),
    };
  }

  static Map<String, dynamic> fromHeadsUp({
    required String headline,
    required String reason,
    required String windowStart,
    required String windowEnd,
    required String confidenceLabel,
    List<String> contributingSignals = const <String>[],
    String? healthCaveat,
    String? childName,
  }) {
    final String name = (childName ?? '').trim().isNotEmpty
        ? childName!.trim()
        : 'your child';
    final StringBuffer attached = StringBuffer();
    attached.writeln('Calm Heads-Up for $name');
    attached.writeln('- Headline: $headline');
    attached.writeln('- Reason: $reason');
    attached.writeln('- Window: $windowStart – $windowEnd');
    attached.writeln('- Confidence: $confidenceLabel');
    if (contributingSignals.isNotEmpty) {
      attached.writeln('- Signals: ${contributingSignals.join(', ')}');
    }
    if (healthCaveat != null && healthCaveat.trim().isNotEmpty) {
      attached.writeln('- Health caveat: ${healthCaveat.trim()}');
    }

    return extras(
      topic: 'Calm Heads-Up',
      initialChat:
          'A harder evening window looks more likely ($windowStart–$windowEnd). What can I do to keep bedtime calm for $name?',
      attachedContext: attached.toString(),
    );
  }

  static Map<String, dynamic> fromCalmPlan({
    String? childName,
    List<String> planSteps = const <String>[],
    String? windowLabel,
  }) {
    final String name = (childName ?? '').trim().isNotEmpty
        ? childName!.trim()
        : 'your child';
    final StringBuffer attached = StringBuffer();
    attached.writeln('Calm Plan context for $name');
    if (windowLabel != null && windowLabel.trim().isNotEmpty) {
      attached.writeln('- Harder window: ${windowLabel.trim()}');
    }
    if (planSteps.isNotEmpty) {
      attached.writeln('- Plan steps:');
      for (final String step in planSteps) {
        if (step.trim().isEmpty) continue;
        attached.writeln('  * ${step.trim()}');
      }
    }

    return extras(
      topic: 'Calm Plan',
      initialChat:
          'Can you help me use a calming plan for $name during a hard moment?',
      attachedContext: attached.toString(),
    );
  }

  static Map<String, dynamic> fromProgrammeDetail({
    required String programmeName,
    ChildModel? child,
  }) {
    final ChildModel? effectiveChild = child ?? preferences.getChildModel();
    final String name = (effectiveChild?.childName ?? '').trim().isNotEmpty
        ? effectiveChild!.childName!.trim()
        : 'your child';
    final StringBuffer attached = StringBuffer();
    attached.writeln('Programme fit question');
    attached.writeln('- Programme: $programmeName');
    attached.writeln('- Child: $name');
    if ((effectiveChild?.childAge ?? '').trim().isNotEmpty) {
      attached.writeln('- Age: ${effectiveChild!.childAge}');
    }
    final List<String> sleepBits = <String>[
      if ((effectiveChild?.usualBedtime ?? '').trim().isNotEmpty)
        'Bedtime ${effectiveChild!.usualBedtime}',
      if ((effectiveChild?.usualWakeTime ?? '').trim().isNotEmpty)
        'Wake ${effectiveChild!.usualWakeTime}',
      if ((effectiveChild?.usualNaps ?? '').trim().isNotEmpty)
        'Naps ${effectiveChild!.usualNaps}',
      if ((effectiveChild?.nightWakings ?? '').trim().isNotEmpty)
        'Night wakings ${effectiveChild!.nightWakings}',
    ];
    if (sleepBits.isNotEmpty) {
      attached.writeln('- Sleep routine: ${sleepBits.join(' | ')}');
    }
    if ((effectiveChild?.primaryConcern ?? '').trim().isNotEmpty) {
      attached.writeln('- Focus: ${effectiveChild!.primaryConcern}');
    }

    return extras(
      topic: 'Sleep Journey',
      initialChat:
          'Can you help me understand if $programmeName fits our situation with $name?',
      attachedContext: attached.toString(),
    );
  }

  static Map<String, dynamic> fromMentorshipUnavailable({
    String? supportConcern,
  }) {
    final String concern = (supportConcern ?? '').trim().isNotEmpty
        ? supportConcern!.trim()
        : 'guided parenting support while a mentor is unavailable';
    return extras(
      topic: 'Support',
      initialChat:
          'A mentor is not available right now. Can you help with $concern?',
      attachedContext:
          'Mentorship unavailable.\n- Parent support concern: $concern\n- Offer practical Brainy guidance while human support is unavailable.',
    );
  }

  static Map<String, dynamic> fromWeeklyReview({
    required String prompt,
    String? attachedSummary,
  }) {
    return extras(
      topic: 'Weekly Review',
      initialChat: prompt,
      attachedContext: attachedSummary,
    );
  }

  static Map<String, dynamic> fromHarderWeek({
    required String prompt,
    String? attachedSummary,
  }) {
    return extras(
      topic: 'Harder Week Support',
      initialChat: prompt,
      attachedContext: attachedSummary,
    );
  }

  static Map<String, dynamic> gettingStarted() {
    return extras(
      topic: 'Getting Started',
      initialChat:
          "I'm new here and want to understand how Loving Brain works for my child.",
      attachedContext:
          'Parent is opening Brainy from Today with little or no logged pattern yet.',
    );
  }
}
