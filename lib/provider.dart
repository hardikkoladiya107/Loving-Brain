import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/auth/forgot_password/bloc/forgot_password_cubit.dart';
import 'package:loving_brain/ui/auth/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/auth/otp/bloc/otp_cubit.dart';
import 'package:loving_brain/ui/auth/register/bloc/register_cubit.dart';
import 'package:loving_brain/ui/base_screen/bloc/base_cubit.dart';
import 'package:loving_brain/ui/help_flow/bloc/help_flow_cubit.dart';
import 'package:loving_brain/ui/onboarding/bloc/onboarding_cubit.dart';
import 'package:loving_brain/ui/profile/bloc/profile_cubit.dart';
import 'package:loving_brain/ui/subscription/bloc/subscription_cubit.dart';
// ignore: depend_on_referenced_packages
import 'package:nested/nested.dart';

final List<SingleChildWidget> blocProvider = <SingleChildWidget>[
  BlocProvider<LoginCubit>(create: (BuildContext context) => LoginCubit()),
  BlocProvider<BaseCubit>(create: (BuildContext context) => BaseCubit()),
  BlocProvider<HelpFlowCubit>(
    create: (BuildContext context) => HelpFlowCubit(),
  ),
  BlocProvider<SubscriptionCubit>(
    create: (BuildContext context) => SubscriptionCubit(),
  ),
  BlocProvider<RegisterCubit>(
    create: (BuildContext context) => RegisterCubit(),
  ),
  BlocProvider<OtpCubit>(create: (BuildContext context) => OtpCubit()),
  BlocProvider<OnboardingCubit>(
    create: (BuildContext context) => OnboardingCubit(),
  ),
  BlocProvider<ForgotPasswordCubit>(
    create: (BuildContext context) => ForgotPasswordCubit(),
  ),
  BlocProvider<ProfileCubit>(create: (BuildContext context) => ProfileCubit()),
];
