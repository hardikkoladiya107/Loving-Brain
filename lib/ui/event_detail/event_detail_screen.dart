import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Assets.images.imgEventDetailBg.image(
            height: context.height,
            width: context.width,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
