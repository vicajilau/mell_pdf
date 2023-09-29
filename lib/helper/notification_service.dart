import 'package:flutter/material.dart';
import 'package:drag_pdf/common/colors/colors_app.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar({
    required String message,
    bool isError = false,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    final SnackBar snackBar = SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isError ? ColorsApp.kMainColor : Colors.greenAccent,
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
