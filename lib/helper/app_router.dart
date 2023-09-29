import 'package:drag_pdf/helper/helpers.dart';
import 'package:drag_pdf/model/file_read.dart';
import 'package:drag_pdf/view/create_signature_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:drag_pdf/view/painter_signature_screen.dart';
import 'package:platform_detail/platform_detail.dart';

import '../view/views.dart';

class AppRouter {
  late final GoRouter _routes;

  static AppRouter shared = AppRouter();

  AppRouter() {
    if (PlatformDetail.isMobile) {
      _routes = _getMobileRoutes();
    } else {
      _routes = _getDesktopRoutes();
    }
  }

  GoRouter getRouter() => _routes;

  // Mobile Routing
  GoRouter _getMobileRoutes() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreenMobile(),
        ),
        GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreenMobile(),
            routes: [
              GoRoute(
                  path: 'preview_document_screen',
                  builder: (context, state) =>
                      PreviewDocumentScreen(file: state.extra as FileRead),
                  routes: [
                    GoRoute(
                      path: 'create_signature_screen',
                      builder: (context, state) =>
                          const CreateSignatureScreen(),
                    ),
                    GoRoute(
                      path: 'painter_signature_screen',
                      builder: (context, state) =>
                      const PainterSignatureScreen(),
                    ),
                  ]),
              GoRoute(
                path: 'pdf_viewer_screen',
                builder: (context, state) =>
                    PDFViewerScreen(file: state.extra as FileRead),
              ),
            ]),
        GoRoute(
          path: '/loading',
          builder: (context, state) => const LoadingScreen(),
        ),
      ],
    );
  }

  // Desktop Routing + WEB
  GoRouter _getDesktopRoutes() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreenDesktop(),
        ),
        GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreenDesktop(),
            routes: [
              GoRoute(
                  path: 'preview_document_screen',
                  builder: (context, state) =>
                      PreviewDocumentScreen(file: state.extra as FileRead),
                  routes: [
                    GoRoute(
                      path: 'create_signature_screen',
                      builder: (context, state) =>
                          const CreateSignatureScreen(),
                    )
                  ]),
              GoRoute(
                path: 'pdf_viewer_screen',
                builder: (context, state) =>
                    PDFViewerScreen(file: state.extra as FileRead),
              ),
            ]),
        GoRoute(
          path: '/loading',
          builder: (context, state) => const LoadingScreen(),
        ),
      ],
    );
  }
}
