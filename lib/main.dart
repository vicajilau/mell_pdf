import 'package:flutter/material.dart';
import 'package:mell_pdf/helper/app_session.dart';
import 'helper/app_router.dart';
import 'helper/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSession.singleton.fileHelper.emptyLocalDocumentFolder();
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
