import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class OnBoardingScreen2 extends StatefulWidget {
  const OnBoardingScreen2({super.key});

  @override
  State<OnBoardingScreen2> createState() => _OnBoardingScreen2State();
}

class _OnBoardingScreen2State extends State<OnBoardingScreen2> {
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
