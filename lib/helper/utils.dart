import 'package:flutter/foundation.dart';

class Utils {
  static void printInDebug(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }

  static String printableSizeOfFile(int size) {
    if (size / 1000000000 > 1) {
      // GB
      double result = size / 1000000000;
      return "${result.toStringAsFixed(2)} GB";
    } else if (size / 1000000 > 1) {
      // MB
      double result = size / 1000000;
      return "${result.toStringAsFixed(2)} MB";
    } else if (size / 1000 > 1) {
      // KB
      double result = size / 1000;
      return "${result.toStringAsFixed(2)} KB";
    }
    return 0.toString();
  }
}
