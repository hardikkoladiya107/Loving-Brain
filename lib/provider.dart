import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/activity/bloc/activity_cubit.dart';
import 'package:loving_brain/ui/activity_completed/bloc/activity_completed_cubit.dart';
import 'package:loving_brain/ui/ai_chat/bloc/ai_chat_cubit.dart';
import 'package:loving_brain/ui/child_profile/bloc/child_profile_cubit.dart';
import 'package:loving_brain/ui/daily_mood_check_in/bloc/daily_mood_check_in_cubit.dart';
import 'package:loving_brain/ui/daily_routine/bloc/daily_routine_cubit.dart';
import 'package:loving_brain/ui/forgot_password/bloc/forgot_password_cubit.dart';
import 'package:loving_brain/ui/home_screen/bloc/home_cubit.dart';
import 'package:loving_brain/ui/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/new_behavior/bloc/new_behavior_cubit.dart';
import 'package:loving_brain/ui/parent_profile/bloc/parent_profile_cubit.dart';
import 'package:loving_brain/ui/play_and_connect/bloc/play_and_connect_cubit.dart';
import 'package:loving_brain/ui/register/bloc/register_cubit.dart';
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
  BlocProvider<NewBehaviorCubit>(
    create: (BuildContext context) => NewBehaviorCubit(),
  ),
  BlocProvider<ParentProfileCubit>(
    create: (BuildContext context) => ParentProfileCubit(),
  ),
  BlocProvider<ChildProfileCubit>(
    create: (BuildContext context) => ChildProfileCubit(),
  ),
  BlocProvider<DailyMoodCheckInCubit>(
    create: (BuildContext context) => DailyMoodCheckInCubit(),
  ),
  BlocProvider<RegisterCubit>(
    create: (BuildContext context) => RegisterCubit(),
  ),
  BlocProvider<ForgotPasswordCubit>(
    create: (BuildContext context) => ForgotPasswordCubit(),
  ),
];
