import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'brainy_home_state.dart';

class BrainyHomeCubit extends Cubit<BrainyHomeState> {
  BrainyHomeCubit() : super(const BrainyHomeState());

  static const Map<String, List<String>> _topicQuestions = {
    'Sleep': [
      'Why is bedtime harder lately?',
      'What can I try tonight?',
      'What are some tips for consistent sleep?',
    ],
    'Behaviour': [
      'Why is bedtime harder lately?',
      'What can I try tonight?',
      'How can I handle a toddler tantrum in public?',
    ],
    'Mood': [
      'How can I encourage my child to express their feelings?',
      'Why do evening meltdowns happen?',
      'What can I try tonight?',
    ],
    'Health': [
      'How do teething or minor colds affect sleep?',
      'What comfort measures help on an unsettled night?',
    ],
    'General': [
      'Is this normal for my child\'s age?',
      'What can I try tonight?',
      'How can I build a calmer evening routine?',
    ],
  };

  Future<void> init() async {
    var user = preferences.getUserModel();
    var child = preferences.getChildModel();

    final pName =
        (user?.parentName != null && user!.parentName!.trim().isNotEmpty)
        ? user.parentName!.trim()
        : 'Parent';
    final cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'your child';

    emit(
      state.copyWith(
        parentName: pName,
        childName: cName,
        suggestedQuestions:
            _topicQuestions[state.selectedTopic] ??
            _topicQuestions['Behaviour']!,
      ),
    );

    if (user?.uid != null && user!.uid!.isNotEmpty) {
      try {
        final freshUser = await AuthRepo.instance.syncUserAndDefaultChild(
          uId: user.uid!,
        );
        if (freshUser != null) {
          final freshChild = preferences.getChildModel();
          final updatedPName =
              (freshUser.parentName != null &&
                  freshUser.parentName!.trim().isNotEmpty)
              ? freshUser.parentName!.trim()
              : pName;
          final updatedCName =
              (freshChild?.childName != null &&
                  freshChild!.childName!.trim().isNotEmpty)
              ? freshChild.childName!.trim()
              : (freshUser.childName != null &&
                    freshUser.childName!.trim().isNotEmpty)
              ? freshUser.childName!.trim()
              : cName;
          emit(
            state.copyWith(parentName: updatedPName, childName: updatedCName),
          );
        }
      } catch (_) {}
    }
  }

  void setTopic(String topic) {
    emit(
      state.copyWith(
        selectedTopic: topic,
        suggestedQuestions:
            _topicQuestions[topic] ?? _topicQuestions['Behaviour']!,
      ),
    );
  }

  void updateChatText(String value) {
    emit(state.copyWith(chatText: value));
  }

  void clearChatText() {
    emit(state.copyWith(chatText: ''));
  }
}
