import 'package:flutter_bloc/flutter_bloc.dart';
import 'permissions_state.dart';

class PermissionsCubit extends Cubit<PermissionsState> {
  PermissionsCubit() : super(const PermissionsState());

  void init() {}
}
