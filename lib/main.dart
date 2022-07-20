import 'package:flutter/material.dart';
import 'helper/app_router.dart';
import 'helper/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: AppRouter.init().routes,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Constants.kMainColor,
        ),
      ),
    );
  }
}
