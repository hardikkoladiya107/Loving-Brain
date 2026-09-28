import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/preferances.dart';
import 'family_snapshot_state.dart';

class FamilySnapshotCubit extends Cubit<FamilySnapshotState> {
  FamilySnapshotCubit() : super(const FamilySnapshotState());

  void init() {
    final user = preferences.getUserModel();
    final child = preferences.getChildModel();

    final cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'your child';

    String noticed = 'Evenings look like the hardest stretch';
    if (child?.difficultTimes != null && child!.difficultTimes!.isNotEmpty) {
      noticed = '${child.difficultTimes!.first} looks like the hardest stretch';
    } else if (child?.primaryConcern != null &&
        child!.primaryConcern!.trim().isNotEmpty) {
      noticed = '${child.primaryConcern} is the main focus right now';
    }

    String tryFirst = 'Start wind-down 15 minutes earlier';
    if (child?.successGoal != null && child!.successGoal!.trim().isNotEmpty) {
      tryFirst = child.successGoal!;
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
