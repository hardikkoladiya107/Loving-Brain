import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';

class EventApprovalScreen extends StatefulWidget {
  const EventApprovalScreen({super.key});

  @override
  State<EventApprovalScreen> createState() => _EventApprovalScreenState();
}

class _EventApprovalScreenState extends State<EventApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Assets.images.imgEventApprovalBg.image(
            height: context.height,
            width: context.width,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
