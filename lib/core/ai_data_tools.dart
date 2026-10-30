import 'dart:convert';

import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/essential_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

/// Summary of the last 14 days of child logs for Brainy prompts.
class BrainyContextSummary {
  final String contextString;
  final bool hasPersonalData;
  final bool hasSleepSignals;
  final bool hasBehaviourSignals;

  const BrainyContextSummary({
    required this.contextString,
    required this.hasPersonalData,
    required this.hasSleepSignals,
    required this.hasBehaviourSignals,
  });
}

/// Provides OpenAI function calling schemas and tool execution handlers
/// to make Brainy AI completely aware of all user and child data across the app.
class AiDataTools {
  AiDataTools._();

  static const int contextWindowDays = 14;
  static const String generalGuidanceLabel =
      'This answer is general guidance and is not based on your child\'s pattern yet.';

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
        'name': 'get_recent_mood_and_notes',
        'description':
            'Retrieve recent mood check-ins and parent quick notes from the last two weeks.',
        'parameters': <String, dynamic>{
          'type': 'object',
          'properties': <String, dynamic>{
            'limit': <String, dynamic>{
              'type': 'integer',
              'description': 'Number of each log type to retrieve (default 6)',
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
          'success_goal': child?.successGoal ?? '',
          'conditions': child?.conditions ?? <String>[],
          'care_notes': (child?.essentials ?? <EssentialNote>[])
              .map(
                (EssentialNote note) => <String, dynamic>{
                  'title': note.title ?? '',
                  'detail': note.description ?? '',
                },
              )
              .toList(),
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

      case 'get_recent_mood_and_notes':
        final int moodLimit = (arguments['limit'] as num?)?.toInt() ?? 6;
        if (childId.isEmpty) {
          return jsonEncode(<String, dynamic>{
            'mood_logs': <dynamic>[],
            'quick_notes': <dynamic>[],
          });
        }
        final ApiResultStatus<List<MoodLogModel>> moodResult =
            await TodayLogRepo.instance.getRecentMoodLogs(
              childId,
              limit: moodLimit,
            );
        final ApiResultStatus<List<QuickNoteModel>> noteResult =
            await TodayLogRepo.instance.getRecentQuickNotes(
              childId,
              limit: moodLimit,
            );
        List<Map<String, dynamic>> moodLogs = <Map<String, dynamic>>[];
        List<Map<String, dynamic>> quickNotes = <Map<String, dynamic>>[];
        moodResult.whenOrNull(
          data: (List<MoodLogModel> list) {
            moodLogs = list
                .map(
                  (MoodLogModel m) => <String, dynamic>{
                    'date': m.logTime.toIso8601String().split('T').first,
                    'child_mood': m.childMood,
                    'parent_mood': m.parentMood,
                  },
                )
                .toList();
          },
        );
        noteResult.whenOrNull(
          data: (List<QuickNoteModel> list) {
            quickNotes = list
                .map(
                  (QuickNoteModel n) => <String, dynamic>{
                    'date': n.timestamp.toIso8601String().split('T').first,
                    'note': n.note,
                  },
                )
                .toList();
          },
        );
        return jsonEncode(<String, dynamic>{
          'mood_logs': moodLogs,
          'quick_notes': quickNotes,
        });

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
          'conditions': child?.conditions ?? <String>[],
          'care_notes': (child?.essentials ?? <EssentialNote>[])
              .map(
                (EssentialNote note) => <String, dynamic>{
                  'title': note.title ?? '',
                  'detail': note.description ?? '',
                },
              )
              .toList(),
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

      final ApiResultStatus<List<MoodLogModel>> moodRes = await TodayLogRepo
          .instance
          .getRecentMoodLogs(effectiveChildId, limit: 5);
      moodRes.whenOrNull(
        data: (List<MoodLogModel> list) {
          final List<MoodLogModel> todayMoods = list
              .where((MoodLogModel m) => m.logTime.isAfter(startOfDay))
              .toList();
          if (todayMoods.isNotEmpty) {
            summary['mood'] = todayMoods
                .map(
                  (MoodLogModel m) => <String, dynamic>{
                    'child_mood': m.childMood,
                    'parent_mood': m.parentMood,
                  },
                )
                .toList();
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
    final BrainyContextSummary summary = await buildFourteenDayContext(
      childModel: childModel,
    );
    return summary.contextString;
  }

  /// Last 14 days of relevant logs for Brainy (not the whole child record).
  static Future<BrainyContextSummary> buildFourteenDayContext({
    required ChildModel? childModel,
  }) async {
    final String childId =
        childModel?.reference?.id ??
        TodayLogRepo.instance.resolveActiveChildId() ??
        '';
    final String childName = (childModel?.childName ?? '').trim().isNotEmpty
        ? childModel!.childName!.trim()
        : 'your child';
    final StringBuffer buffer = StringBuffer();
    buffer.writeln(
      'Relevant recorded data for $childName (last $contextWindowDays days):',
    );

    if (childId.isEmpty) {
      buffer.writeln('- No child profile selected yet.');
      return BrainyContextSummary(
        contextString: buffer.toString(),
        hasPersonalData: false,
        hasSleepSignals: false,
        hasBehaviourSignals: false,
      );
    }

    final DateTime cutoff = DateTime.now().subtract(
      const Duration(days: contextWindowDays),
    );
    bool hasSleep = false;
    bool hasBehaviour = false;
    bool hasMood = false;
    bool hasHealth = false;
    bool hasNotes = false;

    final ApiResultStatus<List<SleepLogModel>> sleepRes = await TodayLogRepo
        .instance
        .getRecentSleepLogs(childId, limit: 20);
    sleepRes.whenOrNull(
      data: (List<SleepLogModel> list) {
        final List<SleepLogModel> recent = list
            .where((SleepLogModel s) => s.bedTime.isAfter(cutoff))
            .toList();
        if (recent.isEmpty) return;
        hasSleep = true;
        buffer.writeln('- Sleep logs (${recent.length}):');
        for (final SleepLogModel s in recent.take(8)) {
          buffer.writeln(
            '  * ${s.bedTime.toIso8601String().split('T').first}: fell asleep ${s.fellAsleepTime ?? s.bedTime.toIso8601String()}, woke ${s.wokeUpTime ?? s.wakeTime.toIso8601String()}, night waking: ${s.isNightWaking ? 'Yes' : 'No'}, quality: ${s.sleepQualityIndex + 1}/5',
          );
        }
      },
    );

    final ApiResultStatus<List<TantrumLogModel>> tantrumRes = await TodayLogRepo
        .instance
        .getRecentTantrumLogs(childId, limit: 20);
    tantrumRes.whenOrNull(
      data: (List<TantrumLogModel> list) {
        final List<TantrumLogModel> recent = list
            .where((TantrumLogModel t) => t.timestamp.isAfter(cutoff))
            .toList();
        if (recent.isEmpty) return;
        hasBehaviour = true;
        buffer.writeln('- Tantrum / meltdowns (${recent.length}):');
        for (final TantrumLogModel t in recent.take(8)) {
          buffer.writeln(
            '  * ${t.time ?? t.timestamp.toIso8601String()}: \'${t.whatHappened}\' (intensity ${t.intensity}). Triggers: ${t.triggers.join(', ')}. Helped: \'${t.whatHelped}\'',
          );
        }
      },
    );

    final ApiResultStatus<List<MoodLogModel>> moodRes = await TodayLogRepo
        .instance
        .getRecentMoodLogs(childId, limit: 20);
    moodRes.whenOrNull(
      data: (List<MoodLogModel> list) {
        final List<MoodLogModel> recent = list
            .where((MoodLogModel m) => m.logTime.isAfter(cutoff))
            .toList();
        if (recent.isEmpty) return;
        hasMood = true;
        buffer.writeln('- Mood check-ins (${recent.length}):');
        for (final MoodLogModel m in recent.take(6)) {
          buffer.writeln(
            '  * ${m.logTime.toIso8601String().split('T').first}: child ${m.childMood}, parent ${m.parentMood}',
          );
        }
      },
    );

    final ApiResultStatus<List<HealthLogModel>> healthRes = await TodayLogRepo
        .instance
        .getRecentHealthLogs(childId, limit: 10);
    healthRes.whenOrNull(
      data: (List<HealthLogModel> list) {
        final List<HealthLogModel> recent = list
            .where((HealthLogModel h) => h.timestamp.isAfter(cutoff))
            .toList();
        if (recent.isEmpty) return;
        hasHealth = true;
        buffer.writeln('- Health notes (${recent.length}):');
        for (final HealthLogModel h in recent.take(5)) {
          buffer.writeln(
            '  * ${h.timestamp.toIso8601String().split('T').first}: \'${h.notes}\'',
          );
        }
      },
    );

    final ApiResultStatus<List<QuickNoteModel>> noteRes = await TodayLogRepo
        .instance
        .getRecentQuickNotes(childId, limit: 10);
    noteRes.whenOrNull(
      data: (List<QuickNoteModel> list) {
        final List<QuickNoteModel> recent = list
            .where((QuickNoteModel n) => n.timestamp.isAfter(cutoff))
            .toList();
        if (recent.isEmpty) return;
        hasNotes = true;
        buffer.writeln('- Parent notes (${recent.length}):');
        for (final QuickNoteModel n in recent.take(5)) {
          buffer.writeln(
            '  * ${n.timestamp.toIso8601String().split('T').first}: \'${n.note}\'',
          );
        }
      },
    );

    final String? concern = childModel?.primaryConcern?.trim();
    if (concern != null && concern.isNotEmpty) {
      buffer.writeln('- Active focus / concern: $concern');
    }
    final String? goal = childModel?.successGoal?.trim();
    if (goal != null && goal.isNotEmpty) {
      buffer.writeln('- Current goal: $goal');
    }
    final List<EssentialNote> careNotes =
        childModel?.essentials ?? <EssentialNote>[];
    if (careNotes.isNotEmpty) {
      buffer.writeln('- Care notes (allergies, medication, soothing):');
      for (final EssentialNote note in careNotes.take(8)) {
        final String title = (note.title ?? '').trim();
        final String detail = (note.description ?? '').trim();
        if (title.isEmpty && detail.isEmpty) continue;
        buffer.writeln('  * $title${detail.isEmpty ? '' : ': $detail'}');
      }
    }

    final bool hasPersonalData =
        hasSleep || hasBehaviour || hasMood || hasHealth || hasNotes;
    if (!hasPersonalData) {
      buffer.writeln(
        '- No sleep, behaviour, mood, or health logs in the last $contextWindowDays days.',
      );
    }

    return BrainyContextSummary(
      contextString: buffer.toString(),
      hasPersonalData: hasPersonalData,
      hasSleepSignals: hasSleep,
      hasBehaviourSignals: hasBehaviour,
    );
  }
}
