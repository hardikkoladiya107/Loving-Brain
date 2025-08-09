import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/login/bloc/login_cubit.dart';

var blocProvider = [
  BlocProvider<LoginCubit>(create: (BuildContext context) => LoginCubit()),
];
