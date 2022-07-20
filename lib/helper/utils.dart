import 'package:flutter/foundation.dart';

class Utils {
  static void printInDebug(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }
}
