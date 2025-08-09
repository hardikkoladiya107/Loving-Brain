import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class OnBoardingScreen4 extends StatefulWidget {
  const OnBoardingScreen4({super.key});

  @override
  State<OnBoardingScreen4> createState() => _OnBoardingScreen4State();
}

class _OnBoardingScreen4State extends State<OnBoardingScreen4> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgOnBoardingBg1.path),
        ),
      ),
      child: Scaffold(backgroundColor: Colors.transparent),
    );
  }
}
