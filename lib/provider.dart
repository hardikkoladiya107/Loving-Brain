import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/activity/bloc/activity_cubit.dart';
import 'package:loving_brain/ui/activity_completed/bloc/activity_completed_cubit.dart';
import 'package:loving_brain/ui/ai_chat/bloc/ai_chat_cubit.dart';
import 'package:loving_brain/ui/daily_routine/bloc/daily_routine_cubit.dart';
import 'package:loving_brain/ui/home_screen/bloc/home_cubit.dart';
import 'package:loving_brain/ui/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/play_and_connect/bloc/play_and_connect_cubit.dart';
import 'package:loving_brain/ui/schedule/bloc/schedule_cubit.dart';
import 'package:loving_brain/ui/subscription/bloc/subscription_cubit.dart';

var blocProvider = [
  BlocProvider<LoginCubit>(create: (BuildContext context) => LoginCubit()),
  BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit()),
  BlocProvider<DailyRoutineCubit>(
    create: (BuildContext context) => DailyRoutineCubit(),
  ),
  BlocProvider<ScheduleCubit>(
    create: (BuildContext context) => ScheduleCubit(),
  ),
  BlocProvider<SubscriptionCubit>(
    create: (BuildContext context) => SubscriptionCubit(),
  ),
  BlocProvider<PlayAndConnectCubit>(
    create: (BuildContext context) => PlayAndConnectCubit(),
  ),
  BlocProvider<AiChatCubit>(create: (BuildContext context) => AiChatCubit()),
  BlocProvider<ActivityCompletedCubit>(
    create: (BuildContext context) => ActivityCompletedCubit(),
  ),
  BlocProvider<ActivityCubit>(
    create: (BuildContext context) => ActivityCubit(),
  ),
];
