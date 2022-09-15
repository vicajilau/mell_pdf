import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenMobile extends StatefulWidget {
  const SplashScreenMobile({Key? key}) : super(key: key);

  @override
  State<SplashScreenMobile> createState() => _SplashScreenMobileState();
}

class _SplashScreenMobileState extends State<SplashScreenMobile>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Container(
            child: Lottie.asset(
              'assets/animations/splash.json',
              controller: _controller,
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                _controller
                  ..duration = composition.duration
                  ..repeat();

                setTimer();
              },
            ),
          ),
        ),
      ),
    );
  }

  void setTimer() {
    Future.delayed(const Duration(seconds: 4), () {
      _controller.stop();
      Navigator.pushNamed(context, "/home");
    });
  }
}
