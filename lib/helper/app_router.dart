import 'package:flutter/material.dart';
import 'package:mell_pdf/helper/helpers.dart';
import 'package:mell_pdf/view/create_signature_screen.dart';
import 'package:platform_detail/platform_detail.dart';

import '../view/views.dart';

class AppRouter {
  late final Map<String, WidgetBuilder> routes;

  AppRouter.init() {
    if (PlatformDetail.isMobile) {
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
      "/preview_document_screen": (context) => const PreviewDocumentScreen(),
      "/create_signature_screen": (context) => const CreateSignatureScreen(),
      "/loading": (context) => const LoadingScreen(),
    };
  }

  // Desktop Routing + WEB
  Map<String, WidgetBuilder> getDesktopRoutes() {
    return {
      "/": (context) => const SplashScreenDesktop(),
      "/home": (context) => const HomeScreenDesktop(),
      "/pdf_viewer_screen": (context) => const PDFViewerScreen(),
      "/preview_document_screen": (context) => const PreviewDocumentScreen(),
      "/create_signature_screen": (context) => const CreateSignatureScreen(),
    };
  }
}
