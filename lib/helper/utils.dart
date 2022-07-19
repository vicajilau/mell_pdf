import 'package:flutter/foundation.dart';

class Utils {
  void printInDebug(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }
}
