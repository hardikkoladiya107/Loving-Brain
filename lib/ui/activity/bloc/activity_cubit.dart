import 'package:flutter_bloc/flutter_bloc.dart';

import 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityState());
}
