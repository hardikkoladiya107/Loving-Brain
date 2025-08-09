import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.imgOnBoardingBg.path),
        ),
      ),
      child: Scaffold(backgroundColor: Colors.transparent),
    );
  }
}
