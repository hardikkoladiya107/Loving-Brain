import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'family_snapshot_state.dart';

class FamilySnapshotCubit extends Cubit<FamilySnapshotState> {
  FamilySnapshotCubit() : super(const FamilySnapshotState());

  void init() {
    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();

    final String cName = (child?.childName?.trim().isNotEmpty == true)
        ? child!.childName!.trim()
        : ((user?.childName?.trim().isNotEmpty == true)
              ? user!.childName!.trim()
              : 'your child');

    String noticed = 'Evenings look like the hardest stretch';
    final List<String>? difficultTimes = child?.difficultTimes;
    final String? primaryConcern = child?.primaryConcern;
    if (difficultTimes != null && difficultTimes.isNotEmpty) {
      noticed = '${difficultTimes.first} looks like the hardest stretch';
    } else if (primaryConcern != null && primaryConcern.trim().isNotEmpty) {
      noticed = '$primaryConcern is the main focus right now';
    }

    String tryFirst = 'Start wind-down 15 minutes earlier';
    final String? successGoal = child?.successGoal;
    if (successGoal != null && successGoal.trim().isNotEmpty) {
      tryFirst = successGoal;
    }

    emit(
      state.copyWith(
        childName: cName,
        whatWeNoticed: noticed,
        tryThisFirst: tryFirst,
      ),
    );
  }
}
