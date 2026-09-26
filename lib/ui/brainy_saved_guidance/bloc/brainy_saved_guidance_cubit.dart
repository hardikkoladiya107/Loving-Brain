import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'brainy_saved_guidance_state.dart';

class BrainySavedGuidanceCubit extends Cubit<BrainySavedGuidanceState> {
  BrainySavedGuidanceCubit() : super(const BrainySavedGuidanceState());

  void init() {
    emit(
      state.copyWith(
        sleepItems: [
          BrainySavedItem(
            title: "Why bedtime got harder",
            subtitle: "Saved 2 days ago",
            imagePath: Assets.v2.images.imgSleep.path,
            imageBgColorValue: 0xFFF1EEFF,
          ),
        ],
        behaviourItems: [
          BrainySavedItem(
            title: "Tantrum triggers explained",
            subtitle: "Saved 5 days ago",
            imagePath: Assets.v2.images.imgTantrums.path,
            imageBgColorValue: 0xFFFEF0E8,
          ),
        ],
        parentWellbeingItems: [
          BrainySavedItem(
            title: "5 min breathing reset",
            subtitle: "Saved 1 week ago",
            imagePath: Assets.v2.images.imgHealth.path,
            imageBgColorValue: 0xFFE2F0FF,
          ),
        ],
      ),
    );
  }
}
