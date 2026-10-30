import 'package:flutter_bloc/flutter_bloc.dart';
import 'programme_detail_state.dart';

/// Cubit managing 6-Week Sleep Journey / Program Detail (Screen 44).
/// Conforms to AGENTS.md Rule 4.2.
class ProgrammeDetailCubit extends Cubit<ProgrammeDetailState> {
  ProgrammeDetailCubit() : super(const ProgrammeDetailState());

  void init() {
    emit(const ProgrammeDetailState());
  }

  void reset() {
    emit(const ProgrammeDetailState());
  }

  void changeProps() {
    emit(const ProgrammeDetailState());
  }
}
