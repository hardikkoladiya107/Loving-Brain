import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'shared_child_summary_state.dart';

class SharedChildSummaryCubit extends Cubit<SharedChildSummaryState> {
  SharedChildSummaryCubit() : super(const SharedChildSummaryState());

  String childName = 'your child';

  void init() {
    final user = preferences.getUserModel();
    final child = preferences.getChildModel();
    childName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'your child';
    emit(const SharedChildSummaryState());
  }
}
