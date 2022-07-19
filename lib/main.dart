import 'package:flutter/material.dart';
import 'package:mell_pdf/view/mobile/splash_screen_mobile.dart';
import 'package:platform_detail/platform_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PlatformDetails.isMobile
            ? const SplashScreenMobile()
            : const SplashScreenMobile());
  }
}
