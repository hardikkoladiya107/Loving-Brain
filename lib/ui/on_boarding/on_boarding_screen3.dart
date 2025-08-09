import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class OnBoardingScreen3 extends StatefulWidget {
  const OnBoardingScreen3({super.key});

  @override
  State<OnBoardingScreen3> createState() => _OnBoardingScreen3State();
}

class _OnBoardingScreen3State extends State<OnBoardingScreen3> {
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
