import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenDesktop extends StatefulWidget {
  const SplashScreenDesktop({Key? key}) : super(key: key);

  @override
  State<SplashScreenDesktop> createState() => _SplashScreenDesktopState();
}

class _SplashScreenDesktopState extends State<SplashScreenDesktop> {
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
