import 'package:flutter/material.dart';
import 'package:mell_pdf/common/colors/colors_app.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbarError(String message) {
    final SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: ColorsApp.kMainColor,
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
