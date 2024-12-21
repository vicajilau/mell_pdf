import 'package:drag_pdf/view/splash_screen.dart';
import 'package:drag_pdf/view/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'common/colors/colors_app.dart';
import 'common/localization/localization.dart';
import 'helper/app_router.dart';
import 'helper/app_session.dart';
import 'helper/firebase_helper.dart';

class DragPdfApp extends StatelessWidget {
  const DragPdfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SplashScreen();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp.router(
            routerConfig: AppRouter.shared.getRouter(),
            debugShowCheckedModeBanner: false,
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

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }

  Future<void> initializeApp() async {
    await loadSecureInf();
    await loadFirebase();
    await prepareApp();
  }

  Future<void> loadSecureInf() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (error) {
      debugPrint(".env file is not loaded!!");
    }
  }

  Future<void> loadFirebase() async {
    FirebaseHelper.shared.initializeApp();
  }

  Future<void> prepareApp() async {
    await AppSession.singleton.fileHelper.loadLocalPath();
    AppSession.singleton.fileHelper.emptyLocalDocumentFolder();
  }
}
