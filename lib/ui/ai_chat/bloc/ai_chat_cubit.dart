import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/ai_repo.dart';
import 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  AiChatCubit() : super(AiChatState());

  void init() {
    emit(AiChatState(userModel: preferences.getUserModel()));
  }

  void changeProps({String? chatText, UserModel? userModel}) {
    emit(
      state.copyWith(
        chatText: chatText ?? state.chatText,
        userModel: userModel ?? state.userModel,
      ),
    );
  }
}
