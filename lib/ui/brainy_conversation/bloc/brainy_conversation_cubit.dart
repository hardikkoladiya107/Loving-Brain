import 'package:flutter_bloc/flutter_bloc.dart';
import 'brainy_conversation_state.dart';

class BrainyConversationCubit extends Cubit<BrainyConversationState> {
  BrainyConversationCubit() : super(const BrainyConversationState());

  void init() {
    emit(
      state.copyWith(
        messages: [
          BrainyMessage(
            type: MessageType.user,
            chipTitle: "You asked",
            headline: "Why is bedtime harder lately?",
          ),
          BrainyMessage(
            type: MessageType.aiInfo,
            chipTitle: "What may be happening",
            headline: "Her nap has shortened",
            subtext:
                "Four of the last five ended early, which raises the chance of overtiredness by the evening.",
          ),
          BrainyMessage(
            type: MessageType.aiAction,
            chipTitle: "What to try now",
            headline: "Offer a quieter environment 30m earlier",
            subtext:
                "Dimming the lights and turning off background noise can help signal to her body that it is time to wind down.",
          ),
        ],
      ),
    );
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessage = BrainyMessage(
      type: MessageType.user,
      chipTitle: "You asked",
      headline: text.trim(),
    );

    emit(
      state.copyWith(messages: [...state.messages, newMessage], isTyping: true),
    );

    await Future.delayed(const Duration(seconds: 2));

    final aiResponse = BrainyMessage(
      type: MessageType.aiInfo,
      chipTitle: "Brainy says",
      headline: "That's a great observation.",
      subtext: "I'll keep this in mind when analyzing her patterns next time.",
    );

    emit(
      state.copyWith(
        messages: [...state.messages, aiResponse],
        isTyping: false,
      ),
    );
  }
}
