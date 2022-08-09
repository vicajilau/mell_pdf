import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mell_pdf/common/localization/localization.dart';
import 'helper/helpers.dart';

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
      localizationsDelegates: const [
        Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ],
    supportedLocales: const [
      Locale('en'),
      Locale('es'),
    ],
    );
  }
}
