import 'dart:convert';

import 'package:loving_brain/core/emergency_detector.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

/// Provides OpenAI function calling schemas and tool execution handlers
/// to make Brainy AI completely aware of all user and child data across the app.
class AiDataTools {
  AiDataTools._();

  /// OpenAI Tool / Function Definitions
  static final List<Map<String, dynamic>> openAiTools = <Map<String, dynamic>>[
    <String, dynamic>{
      'type': 'function',
      'function': <String, dynamic>{
        'name': 'get_child_profile',
        'description':
            'Retrieve the complete profile of the child including name, age, routines, known triggers, concerns, and current emotional/energy state.',
        'parameters': <String, dynamic>{
          'type': 'object',
          'properties': <String, dynamic>{},
        },
      },
    },
    <String, dynamic>{
      'type': 'function',
      'function': <String, dynamic>{
        'name': 'get_today_summary',
        'description':
            'Retrieve all activity, sleep, tantrums, health notes, mood, and quick notes logged today for this child.',
        'parameters': <String, dynamic>{
          'type': 'object',
          'properties': <String, dynamic>{},
        },
      },
    },
    <String, dynamic>{
      'type': 'function',
      'function': <String, dynamic>{
        'name': 'get_recent_sleep_logs',
        'description':
            'Retrieve the recent sleep history over the past 5-7 days including bedtimes, wake times, nap durations, night wakings, and quality ratings.',
        'parameters': <String, dynamic>{
          'type': 'object',
          'properties': <String, dynamic>{
            'limit': <String, dynamic>{
              'type': 'integer',
              'description': 'Number of logs to retrieve (default 5)',
            },
          },
        },
      },
    },
    <String, dynamic>{
      'type': 'function',
      'function': <String, dynamic>{
        'name': 'get_recent_tantrum_logs',
        'description':
            'Retrieve recent tantrum and meltdown incidents with exact triggers (hunger, tiredness, transition, sensory) and what soothing actions helped.',
        'parameters': <String, dynamic>{
          'type': 'object',
          'properties': <String, dynamic>{
            'limit': <String, dynamic>{
              'type': 'integer',
              'description': 'Number of logs to retrieve (default 5)',
            },
          },
        },
      },
    },
    <String, dynamic>{
      'type': 'function',
      'function': <String, dynamic>{
        'name': 'get_health_and_essentials',
        'description':
            'Retrieve child health notes, symptoms, and essential care instructions (allergies, medications, soothing cues).',
        'parameters': <String, dynamic>{
          'type': 'object',
          'properties': <String, dynamic>{},
        },
      },
    },
  ];

  /// Dispatches tool call from OpenAI and executes real data lookups
  static Future<String> executeTool(
    String functionName,
    Map<String, dynamic> arguments,
  ) async {
    final ChildModel? child = preferences.getChildModel();
    final String childId =
        TodayLogRepo.instance.resolveActiveChildId() ??
        child?.reference?.id ??
        '';

    switch (functionName) {
      case 'get_child_profile':
        final Map<String, dynamic> profile = <String, dynamic>{
          'name': child?.childName ?? 'Child',
          'age': child?.childAge ?? 'unknown',
          'dob': child?.childDob,
          'current_state': child?.childState?.label ?? 'Not logged',
          'usual_bedtime': child?.usualBedtime ?? 'Not set',
          'usual_wake_time': child?.usualWakeTime ?? 'Not set',
          'usual_naps': child?.usualNaps ?? 'Not set',
          'night_wakings': child?.nightWakings ?? 'Not set',
          'primary_concern': child?.primaryConcern ?? 'General support',
          'concerns': child?.concerns ?? <String>[],
          'difficult_times': child?.difficultTimes ?? <String>[],
          'possible_triggers': child?.possibleTriggers ?? <String>[],
        };
        return jsonEncode(profile);

      case 'get_today_summary':
        final Map<String, dynamic> summary = await getTodaySummaryData(
          childId: childId,
        );
        return jsonEncode(summary);

      case 'get_recent_sleep_logs':
        final int limit = (arguments['limit'] as num?)?.toInt() ?? 5;
        if (childId.isEmpty) {
          return jsonEncode(<String, dynamic>{'logs': <dynamic>[]});
        }
        final ApiResultStatus<List<SleepLogModel>> result = await TodayLogRepo
            .instance
            .getRecentSleepLogs(childId, limit: limit);
        List<Map<String, dynamic>> logs = <Map<String, dynamic>>[];
        result.whenOrNull(
          data: (List<SleepLogModel> list) {
            logs = list.map((SleepLogModel e) => e.toMap()).toList();
          },
        );
        return jsonEncode(<String, dynamic>{'sleep_logs': logs});

      case 'get_recent_tantrum_logs':
        final int limit = (arguments['limit'] as num?)?.toInt() ?? 5;
        if (childId.isEmpty) {
          return jsonEncode(<String, dynamic>{'logs': <dynamic>[]});
        }
        final ApiResultStatus<List<TantrumLogModel>> result = await TodayLogRepo
            .instance
            .getRecentTantrumLogs(childId, limit: limit);
        List<Map<String, dynamic>> logs = <Map<String, dynamic>>[];
        result.whenOrNull(
          data: (List<TantrumLogModel> list) {
            logs = list.map((TantrumLogModel e) => e.toMap()).toList();
          },
        );
        return jsonEncode(<String, dynamic>{'tantrum_logs': logs});

      case 'get_health_and_essentials':
        final ApiResultStatus<List<HealthLogModel>> result = await TodayLogRepo
            .instance
            .getRecentHealthLogs(childId, limit: 5);
        List<Map<String, dynamic>> healthLogs = <Map<String, dynamic>>[];
        result.whenOrNull(
          data: (List<HealthLogModel> list) {
            healthLogs = list.map((HealthLogModel e) => e.toMap()).toList();
          },
        );
        return jsonEncode(<String, dynamic>{
          'recent_health_logs': healthLogs,
          'concerns_and_essentials': child?.concerns ?? <String>[],
        });

      default:
        return jsonEncode(<String, dynamic>{
          'error': 'Unknown tool function: $functionName',
        });
    }
  }

  /// Aggregates all of today's logged data for the active child into a Map
  static Future<Map<String, dynamic>> getTodaySummaryData({
    String? childId,
  }) async {
    final String effectiveChildId =
        childId ??
        TodayLogRepo.instance.resolveActiveChildId() ??
        preferences.getChildModel()?.reference?.id ??
        '';

    final Map<String, dynamic> summary = <String, dynamic>{
      'date': DateTime.now().toIso8601String().split('T').first,
    };

    if (effectiveChildId.isEmpty) {
      return summary;
    }

    try {
      final DateTime now = DateTime.now();
      final DateTime startOfDay = DateTime(now.year, now.month, now.day);

      // Sleep
      final ApiResultStatus<List<SleepLogModel>> sleepRes = await TodayLogRepo
          .instance
          .getRecentSleepLogs(effectiveChildId, limit: 3);
      sleepRes.whenOrNull(
        data: (List<SleepLogModel> list) {
          if (list.isNotEmpty) {
            final SleepLogModel todayLog = list.first;
            summary['sleep'] = <String, dynamic>{
              'fell_asleep':
                  todayLog.fellAsleepTime ?? todayLog.bedTime.toIso8601String(),
              'woke_up':
                  todayLog.wokeUpTime ?? todayLog.wakeTime.toIso8601String(),
              'duration_mins': todayLog.durationMinutes,
              'night_waking': todayLog.isNightWaking,
              'sleep_quality': '${todayLog.sleepQualityIndex + 1}/5',
            };
          }
        },
      );

      // Tantrums
      final ApiResultStatus<List<TantrumLogModel>> tantrumRes =
          await TodayLogRepo.instance.getRecentTantrumLogs(
            effectiveChildId,
            limit: 5,
          );
      tantrumRes.whenOrNull(
        data: (List<TantrumLogModel> list) {
          final List<TantrumLogModel> todayTantrums = list.where((
            TantrumLogModel t,
          ) {
            return t.timestamp.isAfter(startOfDay);
          }).toList();
          if (todayTantrums.isNotEmpty) {
            summary['tantrums'] = todayTantrums.map((TantrumLogModel t) {
              return <String, dynamic>{
                'what_happened': t.whatHappened,
                'approximate_time': t.time ?? '',
                'intensity': t.intensity,
                'triggers': t.triggers,
                'what_helped': t.whatHelped,
              };
            }).toList();
          }
        },
      );

      // Health
      final ApiResultStatus<List<HealthLogModel>> healthRes = await TodayLogRepo
          .instance
          .getRecentHealthLogs(effectiveChildId, limit: 3);
      healthRes.whenOrNull(
        data: (List<HealthLogModel> list) {
          if (list.isNotEmpty) {
            summary['health_notes'] = list.first.notes;
          }
        },
      );

      // Quick notes
      final ApiResultStatus<List<QuickNoteModel>> notesRes = await TodayLogRepo
          .instance
          .getRecentQuickNotes(effectiveChildId, limit: 3);
      notesRes.whenOrNull(
        data: (List<QuickNoteModel> list) {
          if (list.isNotEmpty) {
            summary['quick_note'] = list.first.note;
          }
        },
      );
    } catch (_) {}

    return summary;
  }

  /// Builds a human-readable live data summary to inject into the system prompt
  static Future<String> buildLiveContextString({
    required ChildModel? childModel,
  }) async {
    final Map<String, dynamic> todayData = await getTodaySummaryData(
      childId: childModel?.reference?.id,
    );

    final StringBuffer buffer = StringBuffer();
    final String childName = (childModel?.childName ?? '').trim().isNotEmpty
        ? childModel!.childName!.trim()
        : 'your child';

    buffer.writeln("Live recorded data for $childName today:");

    if (todayData.containsKey('sleep')) {
      final Map<String, dynamic> sleep =
          todayData['sleep'] as Map<String, dynamic>;
      buffer.writeln(
        "- Sleep logged today: Fell asleep ${sleep['fell_asleep'] ?? 'N/A'}, Woke up ${sleep['woke_up'] ?? 'N/A'}, Nap: ${sleep['nap_duration_mins'] ?? 0}m, Night waking: ${sleep['night_waking'] == true ? 'Yes' : 'No'}, Quality rating: ${sleep['sleep_quality'] ?? 'N/A'}",
      );
    } else {
      buffer.writeln("- Sleep: No sleep update logged yet today.");
    }

    if (todayData.containsKey('tantrums')) {
      final List<dynamic> tantrums = todayData['tantrums'] as List<dynamic>;
      buffer.writeln(
        "- Tantrum / Meltdowns today (${tantrums.length} recorded):",
      );
      for (final dynamic item in tantrums) {
        final Map<String, dynamic> t = item as Map<String, dynamic>;
        buffer.writeln(
          "  * At ${t['approximate_time']}: '${t['what_happened']}' (Intensity: ${t['intensity']}). Triggers: ${(t['triggers'] as List<dynamic>?)?.join(', ') ?? 'None'}. What helped: '${t['what_helped'] ?? 'None'}'",
        );
      }
    } else {
      buffer.writeln("- Tantrums / Meltdowns: None logged today.");
    }

    if (todayData.containsKey('health_notes')) {
      buffer.writeln("- Health update: '${todayData['health_notes']}'");
    }

    if (todayData.containsKey('quick_note')) {
      buffer.writeln("- Parent note: '${todayData['quick_note']}'");
    }

    return buffer.toString();
  }

  /// Intelligent contextual fallback that uses the user's actual child data to generate
  /// authentic, clinical 3-part cards when offline or when OpenAI quota is exhausted.
  static Future<String> generateContextualResponse({
    required String question,
    required ChildModel? childModel,
    String? topic,
  }) async {
    final String childName = (childModel?.childName ?? '').trim().isNotEmpty
        ? childModel!.childName!.trim()
        : 'your child';
    final String age = (childModel?.childAge ?? '').trim().isNotEmpty
        ? childModel!.childAge!.trim()
        : 'this age';
    final String lower = question.toLowerCase();
    final String lowerTopic = (topic ?? '').toLowerCase();

    if (EmergencyDetector.isEmergency(question)) {
      final String phone = EmergencyDetector.getEmergencyDisplayNumber();
      return '''
Struggling to breathe, turning blue, or loss of consciousness is an acute clinical emergency.
---
Call emergency services ($phone) immediately.
Do not wait or rely on app guidance. Seek professional emergency medical care right away.
---
Contact emergency medical services or proceed to the nearest emergency department immediately.
''';
    }

    final Map<String, dynamic> todayData = await getTodaySummaryData(
      childId: childModel?.reference?.id,
    );

    // Sleep queries
    if (lower.contains('sleep') ||
        lower.contains('bedtime') ||
        lower.contains('nap') ||
        lower.contains('wake') ||
        lowerTopic == 'sleep') {
      final Map<String, dynamic>? sleep =
          todayData['sleep'] as Map<String, dynamic>?;
      final String bedtime = childModel?.usualBedtime ?? 'their usual bedtime';
      final bool hadNightWakings =
          sleep != null && sleep['night_waking'] == true;

      String sleepAnalysis =
          "$childName's nervous system and circadian rhythm may be shifting.";
      if (sleep != null) {
        sleepAnalysis =
            "Looking at $childName's logs today, bedtime is anchored to $bedtime${hadNightWakings ? ', but last night included night wakings which elevates daytime overtiredness' : ''}.";
      }

      return '''
$sleepAnalysis Shifts in daytime activity or sensory buildup can spike cortisol right when melatonin should be rising.
---
Start a soothing wind-down 25–30 minutes before $bedtime.
Dim overhead lights, turn off screens, and repeat the same 2–3 predictable cues so $childName recognizes it is safe to downshift.
---
If bedtime pushback persists for over 2 weeks alongside intense night terrors or physical snoring, consult your pediatrician.
''';
    }

    // Tantrum / Meltdown queries
    if (lower.contains('tantrum') ||
        lower.contains('meltdown') ||
        lower.contains('crying') ||
        lower.contains('angry') ||
        lower.contains('hitting') ||
        lower.contains('trigger') ||
        lowerTopic == 'behaviour') {
      final List<dynamic>? tantrums = todayData['tantrums'] as List<dynamic>?;
      String tantrumContext = '';
      String whatHelpedAdvice =
          'offer gentle physical closeness and a quiet space';

      if (tantrums != null && tantrums.isNotEmpty) {
        final Map<String, dynamic> firstTantrum =
            tantrums.first as Map<String, dynamic>;
        final String happened = firstTantrum['what_happened']?.toString() ?? '';
        final String helped = firstTantrum['what_helped']?.toString() ?? '';
        if (happened.isNotEmpty) {
          tantrumContext = " During the earlier incident ('$happened'), ";
        }
        if (helped.isNotEmpty) {
          whatHelpedAdvice =
              "continue using '$helped' which successfully aided co-regulation earlier";
        }
      }

      return '''
$childName's emotional brain is becoming overloaded during moments of friction or transition.$tantrumContext
At $age, executive function is still developing, meaning big emotions physically override self-control when fatigue or hunger is present.
---
Focus on co-regulation rather than verbal reasoning: $whatHelpedAdvice.
Get down to eye level, keep your vocal tone steady, and give simple 5-minute countdowns before transitions to prevent sudden emotional crashes.
---
If meltdowns frequently exceed 45 minutes or involve self-injury, consult your pediatric behavioural specialist.
''';
    }

    // Health / Sickness queries
    if (lower.contains('fever') ||
        lower.contains('health') ||
        lower.contains('sick') ||
        lower.contains('cough') ||
        lower.contains('teeth') ||
        lower.contains('teething') ||
        lowerTopic == 'health') {
      final String healthNote = todayData['health_notes']?.toString() ?? '';
      final String noteContext = healthNote.isNotEmpty
          ? " Taking note of today's observation: '$healthNote', "
          : " ";

      return '''
$childName may be experiencing physical discomfort or a mild immune response.$noteContext
When toddlers are uncomfortable from teething or viral bugs, their sleep architecture fragments and emotional tolerance drops sharply.
---
Prioritize comfort, hydration, and extra physical reassurance throughout the day.
Keep routines flexible, offer smaller and more frequent fluids, and allow quiet rest without strict scheduling pressure.
---
Seek immediate pediatric care if fever exceeds 102°F (39°C), persists over 3 days, or if $childName shows signs of lethargy or breathing difficulty.
''';
    }

    // General parenting / development query
    final String concern =
        childModel?.primaryConcern ?? 'daytime and nighttime balance';
    return '''
$childName is navigating a key developmental window at $age.
Milestone leaps in language and mobility often create temporary friction around $concern as growing autonomy clashes with emotional stamina.
---
Anchor $childName with predictable routines and clear, loving boundaries.
Acknowledge feelings first ('I know you wanted to stay'), then gently guide to the next step with calm, consistent presence.
---
If you observe regression in multiple developmental areas or persistent distress, reach out to your pediatrician for a developmental check.
''';
  }
}
