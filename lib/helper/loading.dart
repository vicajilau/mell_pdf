import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading {
  static void show(BuildContext context) {
    Navigator.pushNamed(context, '/loading');
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/animations/loading.json'),
      ),
    );
  }
}
