import 'package:flutter/material.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/home_screen/home_screen.dart';
import 'package:loving_brain/ui/on_boarding/on_boarding_screen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 2), () {
          if (preferences.getBool(SharedPreference.isLogin) ?? false) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const OnBoardingScreen1(),
              ),
            );
          }
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
