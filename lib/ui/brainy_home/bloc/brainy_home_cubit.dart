import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/ai_data_tools.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';

import 'brainy_home_state.dart';

/// Cubit managing Screen 37 (Brainy Home).
/// Conforms to AGENTS.md §3.1 and §4.2.
class BrainyHomeCubit extends Cubit<BrainyHomeState> {
  BrainyHomeCubit() : super(const BrainyHomeState());

  static const List<String> defaultQuestions = <String>[
    'Why is bedtime harder lately?',
    'What can I try tonight?',
    'How to handle evening meltdowns?',
  ];

  static const Map<String, List<String>> _topicQuestions =
      <String, List<String>>{
        'Behaviour': <String>[
          'What helps when they\'re overwhelmed?',
          'Why do sudden meltdowns happen?',
          'How do I handle public tantrums?',
        ],
        'Sleep': <String>[
          'What\'s a typical bedtime for this age?',
          'How can I make winding down smoother?',
          'What should I do during night wakings?',
        ],
        'Routines': <String>[
          'How do I start a simple evening routine?',
          'Tips for smoother morning transitions?',
          'How to handle routine disruptions?',
        ],
        'Milestones': <String>[
          'Is this normal for my child\'s age?',
          'What can I try tonight?',
          'How can I build a calmer evening routine?',
        ],
      };

  void changeProps({
    String? selectedTopic,
    String? chatText,
    String? parentName,
    String? childName,
    List<String>? suggestedQuestions,
  }) {
    emit(
      state.copyWith(
        selectedTopic: selectedTopic ?? state.selectedTopic,
        chatText: chatText ?? state.chatText,
        parentName: parentName ?? state.parentName,
        childName: childName ?? state.childName,
        suggestedQuestions: suggestedQuestions ?? state.suggestedQuestions,
      ),
    );
  }

  void reset() {
    emit(const BrainyHomeState());
  }

  Future<void> init() async {
    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();

    final String pName =
        (user?.parentName != null && user!.parentName!.trim().isNotEmpty)
        ? user.parentName!.trim()
        : 'Parent';
    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'your child';

    final List<String> contextQuestions = await _questionsFromRecentContext(
      child,
    );

    changeProps(
      parentName: pName,
      childName: cName,
      selectedTopic: '',
      suggestedQuestions: contextQuestions,
    );

    if (user?.uid != null && user!.uid!.isNotEmpty) {
      try {
        final UserModel? freshUser = await AuthRepo.instance
            .syncUserAndDefaultChild(uId: user.uid!);
        if (freshUser != null) {
          final ChildModel? freshChild = preferences.getChildModel();
          final String updatedPName =
              (freshUser.parentName != null &&
                  freshUser.parentName!.trim().isNotEmpty)
              ? freshUser.parentName!.trim()
              : pName;
          final String updatedCName =
              (freshChild?.childName != null &&
                  freshChild!.childName!.trim().isNotEmpty)
              ? freshChild.childName!.trim()
              : (freshUser.childName != null &&
                    freshUser.childName!.trim().isNotEmpty)
              ? freshUser.childName!.trim()
              : cName;
          changeProps(parentName: updatedPName, childName: updatedCName);
        }
      } catch (_) {}
    }
  }

  Future<List<String>> _questionsFromRecentContext(ChildModel? child) async {
    try {
      final BrainyContextSummary summary =
          await AiDataTools.buildFourteenDayContext(childModel: child);
      if (summary.hasSleepSignals && !summary.hasBehaviourSignals) {
        return List<String>.from(_topicQuestions['Sleep']!);
      }
      if (summary.hasBehaviourSignals && !summary.hasSleepSignals) {
        return List<String>.from(_topicQuestions['Behaviour']!);
      }
      if (summary.hasSleepSignals && summary.hasBehaviourSignals) {
        return const <String>[
          'Why is bedtime harder lately?',
          'What helps when they\'re overwhelmed?',
          'What can I try tonight?',
        ];
      }
    } catch (_) {}
    return List<String>.from(defaultQuestions);
  }

  void setTopic(String topic) {
    if (state.selectedTopic == topic) {
      changeProps(
        selectedTopic: '',
        suggestedQuestions: List<String>.from(defaultQuestions),
      );
    } else {
      changeProps(
        selectedTopic: topic,
        suggestedQuestions:
            _topicQuestions[topic] ?? List<String>.from(defaultQuestions),
      );
    }
  }

  void updateChatText(String value) {
    changeProps(chatText: value);
  }

  void clearChatText() {
    changeProps(chatText: '');
  }
}
