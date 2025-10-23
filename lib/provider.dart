import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/activity/bloc/activity_cubit.dart';
import 'package:loving_brain/ui/activity_completed/bloc/activity_completed_cubit.dart';
import 'package:loving_brain/ui/add_shared_event/cubit/add_shared_event_cubit.dart';
import 'package:loving_brain/ui/ai_chat/bloc/ai_chat_cubit.dart';
import 'package:loving_brain/ui/base_screen/bloc/base_cubit.dart';
import 'package:loving_brain/ui/chat_detail/bloc/chat_detail_cubit.dart';
import 'package:loving_brain/ui/chat_list/bloc/chat_list_cubit.dart';
import 'package:loving_brain/ui/child_profile/bloc/child_profile_cubit.dart';
import 'package:loving_brain/ui/daily_mood_check_in/bloc/daily_mood_check_in_cubit.dart';
import 'package:loving_brain/ui/daily_routine/bloc/daily_routine_cubit.dart';
import 'package:loving_brain/ui/essentials/bloc/essentials_cubit.dart';
import 'package:loving_brain/ui/event_approval/bloc/event_approval_cubit.dart';
import 'package:loving_brain/ui/event_detail/bloc/event_detail_cubit.dart';
import 'package:loving_brain/ui/forgot_password/bloc/forgot_password_cubit.dart';
import 'package:loving_brain/ui/home/bloc/home_cubit.dart';
import 'package:loving_brain/ui/link_co_parent/bloc/link_co_parent_cubit.dart';
import 'package:loving_brain/ui/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/new_behavior/bloc/new_behavior_cubit.dart';
import 'package:loving_brain/ui/parent_profile/bloc/parent_profile_cubit.dart';
import 'package:loving_brain/ui/play_and_connect/bloc/play_and_connect_cubit.dart';
import 'package:loving_brain/ui/profile/bloc/profile_cubit.dart';
import 'package:loving_brain/ui/propose_change/bloc/propose_change_cubit.dart';
import 'package:loving_brain/ui/register/bloc/register_cubit.dart';
import 'package:loving_brain/ui/schedule/bloc/schedule_cubit.dart';
import 'package:loving_brain/ui/subscription/bloc/subscription_cubit.dart';
import 'package:loving_brain/ui/thought_list/bloc/thought_list_cubit.dart';
import 'package:loving_brain/ui/write_your_thought/bloc/write_your_thought_cubit.dart';

var blocProvider = [
  BlocProvider<LoginCubit>(create: (BuildContext context) => LoginCubit()),
  BlocProvider<BaseCubit>(create: (BuildContext context) => BaseCubit()),
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
  BlocProvider<EssentialsCubit>(
    create: (BuildContext context) => EssentialsCubit(),
  ),
  BlocProvider<WriteYourThoughtCubit>(
    create: (BuildContext context) => WriteYourThoughtCubit(),
  ),
  BlocProvider<ProfileCubit>(create: (BuildContext context) => ProfileCubit()),
  BlocProvider<ThoughtListCubit>(
    create: (BuildContext context) => ThoughtListCubit(),
  ),
  BlocProvider<AddSharedEventCubit>(
    create: (BuildContext context) => AddSharedEventCubit(),
  ),
  BlocProvider<LinkCoParentCubit>(
    create: (BuildContext context) => LinkCoParentCubit(),
  ),
  BlocProvider<ChatDetailCubit>(
    create: (BuildContext context) => ChatDetailCubit(),
  ),
  BlocProvider<ChatListCubit>(
    create: (BuildContext context) => ChatListCubit(),
  ),
  BlocProvider<EventDetailCubit>(
    create: (BuildContext context) => EventDetailCubit(),
  ),
  BlocProvider<EventApprovalCubit>(
    create: (BuildContext context) => EventApprovalCubit(),
  ),
  BlocProvider<ProposeChangeCubit>(
    create: (BuildContext context) => ProposeChangeCubit(),
  ),
];
