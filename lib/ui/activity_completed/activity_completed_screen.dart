import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';
import 'bloc/activity_completed_cubit.dart';
import 'bloc/activity_completed_state.dart';

class ActivityCompletedScreen extends StatefulWidget {
  const ActivityCompletedScreen({super.key});

  @override
  State<ActivityCompletedScreen> createState() =>
      _ActivityCompletedScreenState();
}

class _ActivityCompletedScreenState extends State<ActivityCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityCompletedCubit, ActivityCompletedState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgActivityCompleted.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(children: []),
          ),
        );
      },
      listener: (context, state) {},
    );
    return Container(child: Scaffold());
  }
}
