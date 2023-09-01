import 'package:flutter/material.dart';
import 'package:drag_pdf/common/colors/colors_app.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({Key? key}) : super(key: key);

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: ColorsApp.green,
    ));
  }
}
