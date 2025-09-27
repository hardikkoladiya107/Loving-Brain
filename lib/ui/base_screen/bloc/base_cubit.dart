import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repo/auth_repo.dart';
import 'base_state.dart';

class BaseCubit extends Cubit<BaseState> {
  BaseCubit() : super(BaseState());

  void changeProps({int? bottomNavigationIndex}) {
    emit(
      state.copyWith(
        bottomNavigationIndex:
            bottomNavigationIndex ?? state.bottomNavigationIndex,
      ),
    );
  }

  void init() {
    emit(BaseState());
    updateFCMToken();
  }

  Future updateFCMToken() async {
    try {
      String? getAPNSToken = await FirebaseMessaging.instance.getAPNSToken();
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        AuthRepo.instance.updateUserToFireStore( request: {
          "fcm_token" : token
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
