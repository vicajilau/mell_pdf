import 'package:drag_pdf/helper/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'helper/helpers.dart';
import 'my_app.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadSecureInf();
  await loadFirebase();
  await prepareApp();
}

Future loadSecureInf() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (error) {
    debugPrint(".env file is not loaded!!");
  }
}

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
