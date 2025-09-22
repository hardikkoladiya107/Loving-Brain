import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/thought_list/bloc/thought_list_state.dart';

import '../../../model/journal_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/auth_repo.dart';

class ThoughtListCubit extends Cubit<ThoughtListState> {
  ThoughtListCubit() : super(ThoughtListState());

  void init() {
    emit(ThoughtListState(userModel: preferences.getUserModel()));
    _getThoughts();
  }

  void changeProps({UserModel? userModel, List<JournalModel>? journalList}) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,

        journalList: journalList ?? state.journalList,
      ),
    );
  }

  StreamSubscription? journalsSubscription;

  void _getThoughts() {
    if (state.userModel?.uid != null) {
      journalsSubscription?.cancel();
      journalsSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .collection("journals")
          .snapshots()
          .listen((event) {
            changeProps(
              journalList: event.docs
                  .map((e) => JournalModel.fromJson(e.data()))
                  .toList(),
            );
          });
    }
  }

  void dispose() {
    journalsSubscription?.cancel();
  }
}
