import 'package:flutter/material.dart';
import 'package:mell_pdf/view/desktop/home_screen_desktop.dart';
import 'package:mell_pdf/view/pdf_viewer_screen.dart';
import 'package:platform_detail/platform_detail.dart';

import '../view/desktop/splash_screen_desktop.dart';
import '../view/mobile/home_screen_mobile.dart';
import '../view/mobile/splash_screen_mobile.dart';

class AppRouter {
  late final Map<String, WidgetBuilder> routes;

  AppRouter.init() {
    if (PlatformDetails.isMobile) {
      routes = getMobileRoutes();
    } else {
      routes = getDesktopRoutes();
    }
  }

  // Mobile Routing
  Map<String, WidgetBuilder> getMobileRoutes() {
    return {
      "/": (context) => const SplashScreenMobile(),
      "/home": (context) => const HomeScreenMobile(),
      "/pdf_viewer_screen": (context) => const PDFViewerScreen(),
    };
  }

  // Desktop Routing + WEB
  Map<String, WidgetBuilder> getDesktopRoutes() {
    return {
      "/": (context) => const SplashScreenDesktop(),
      "/home": (context) => const HomeScreenDesktop(),
      "/pdf_viewer_screen": (context) => const PDFViewerScreen(),
    };
  }
}
