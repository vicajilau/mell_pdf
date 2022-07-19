import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenMobile extends StatefulWidget {
  const SplashScreenMobile({Key? key}) : super(key: key);

  @override
  State<SplashScreenMobile> createState() => _SplashScreenMobileState();
}

class _SplashScreenMobileState extends State<SplashScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Lottie.asset('assets/animations/splash.json'),
        ),
      ),
    );
  }
}
