import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mell_pdf/common/colors/colors_app.dart';
import 'package:mell_pdf/common/localization/localization.dart';
import 'package:mell_pdf/helper/db_storage.dart';
import 'package:mell_pdf/helper/local_storage.dart';
import 'package:mell_pdf/helper/notification_service.dart';

import 'helper/helpers.dart';
import 'package:mell_pdf/helper/firebase_helper.dart';


Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadSecureInf();
  await loadFirebase();
  await prepareApp();
  await LocalStorage.configurePrefs();
  await DBStorage.configureDataBase();
}

Future loadSecureInf() async => await dotenv.load(fileName: ".env");

Future loadFirebase() async {
  FirebaseHelper.shared.initializeApp();
}

Future prepareApp() async {
  await AppSession.singleton.fileHelper.loadLocalPath();
  AppSession.singleton.fileHelper.emptyLocalDocumentFolder();
}

void main() async {
  await initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: NotificationService.messengerKey,
      debugShowCheckedModeBanner: false,
      routes: AppRouter.init().routes,
      darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData.light(useMaterial3: true).copyWith(
        primaryColor: ColorsApp.white,
        appBarTheme: const AppBarTheme(
            color: ColorsApp.kMainColor, foregroundColor: Colors.white),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
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
