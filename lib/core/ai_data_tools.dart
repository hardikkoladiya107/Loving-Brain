import 'dart:convert';

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
              'nap_duration_mins': todayLog.durationMinutes,
              'night_waking': todayLog.isNightWaking,
              'sleep_quality': '${todayLog.sleepQualityIndex + 1}/5',
              'is_today': todayLog.bedTime.isAfter(startOfDay),
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
      final bool isToday = sleep['is_today'] == true;
      final String prefix = isToday
          ? 'Sleep logged today'
          : 'Most recent sleep log';
      buffer.writeln(
        "- $prefix: Fell asleep ${sleep['fell_asleep'] ?? 'N/A'}, Woke up ${sleep['woke_up'] ?? 'N/A'}, Nap: ${sleep['nap_duration_mins'] ?? 0}m, Night waking: ${sleep['night_waking'] == true ? 'Yes' : 'No'}, Quality rating: ${sleep['sleep_quality'] ?? 'N/A'}",
      );
    } else {
      buffer.writeln("- Sleep: No sleep update logged yet.");
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
}
