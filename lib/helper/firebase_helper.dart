import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:drag_pdf/model/enums/log_event.dart';
import 'package:platform_detail/platform_detail.dart';

import '../firebase_options.dart';

class FirebaseHelper {
  static FirebaseHelper shared = FirebaseHelper();

  late final FirebaseAnalytics _analytics;
  late final FirebaseCrashlytics _crashlytics;

  Future<void> initializeApp([bool enabledInDebugMode = false]) async {
    if (dotenv.env['enabledCrashlyticsInDebugMode'] != null &&
        dotenv.env['enabledFirebaseInDebugMode'] != null) {
      final crashDetectorInDebug =
          dotenv.env['enabledCrashlyticsInDebugMode'] == 'true';
      final analyticsInDebug =
          dotenv.env['enabledFirebaseInDebugMode'] == 'true';
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      await initializeFirebase(analyticsInDebug);
      await initializeCrashlytics(crashDetectorInDebug);
    }
  }

  Future<void> initializeFirebase([bool enabledInDebugMode = false]) async {
    if (kDebugMode) {
      await _analytics.setAnalyticsCollectionEnabled(enabledInDebugMode);
    }
  }

  Future<void> initializeCrashlytics([bool enabledInDebugMode = false]) async {
    FlutterError.onError = (errorDetails) {
      _crashlytics.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
    // Force disable Crashlytics collection while doing every day development.
    if (kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(
          enabledInDebugMode); // Temporarily toggle this to true if you want to test crash reporting in your app.
      print(
          "Crashlytics state: ${_crashlytics.isCrashlyticsCollectionEnabled}");
    }
  }

  Future<void> logErrorInFirebase(
      Object error, String titleLocalized, String subtitleLocalized) async {
    final event = LogEvent.error.value;
    final deviceInfo = await PlatformDetail.deviceInfo();
    final parameters = {
      "event_name": event,
      "error": error.toString(),
      "title_localized": titleLocalized,
      "subtitle_localized": subtitleLocalized,
      "device_info": deviceInfo,
    };
    await _analytics.logEvent(name: event, parameters: parameters);
  }
}
