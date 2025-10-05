import 'package:flutter_bloc/flutter_bloc.dart';

import 'link_co_parent_state.dart';

class LinkCoParentCubit extends Cubit<LinkCoParentState> {
  LinkCoParentCubit() : super(LinkCoParentState());

  void changeProps({String? selectedTab}) {
    emit(state.copyWith(selectedTab: selectedTab ?? state.selectedTab));
  }

  void init() {
    emit(LinkCoParentState());
  }
}
