import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.imgOnBoardingBg1.path),
        ),
      ),
      child: Scaffold(backgroundColor: Colors.transparent),
    );
  }
}
