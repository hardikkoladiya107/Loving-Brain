import 'package:flutter_bloc/flutter_bloc.dart';
import 'family_timeline_state.dart';

class FamilyTimelineCubit extends Cubit<FamilyTimelineState> {
  FamilyTimelineCubit() : super(const FamilyTimelineState());
  void init() {
    emit(
      state.copyWith(
        events: [
          TimelineEvent(
            title: 'Started the 6-Week Sleep Journey',
            subtitle: '18 May - with Priya',
          ),
          TimelineEvent(
            title: 'Bedtime moved 10 minutes earlier',
            subtitle: '14 May - held for six nights',
          ),
          TimelineEvent(title: 'Completed week 1 check-in', subtitle: '11 May'),
          TimelineEvent(
            title: 'A harder week travel disrupted the routine',
            subtitle: '4 May',
          ),
          TimelineEvent(
            title: 'First sleep pattern recognised',
            subtitle: '28 April',
          ),
        ],
      ),
    );
  }
}
