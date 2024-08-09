import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreenDesktop extends StatefulWidget {
  const SplashScreenDesktop({super.key});

  @override
  State<SplashScreenDesktop> createState() => _SplashScreenDesktopState();
}

class _SplashScreenDesktopState extends State<SplashScreenDesktop>
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

                setTimer(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  void setTimer(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      _controller.stop();
      if (context.mounted) context.go("/home");
    });
  }
}
