import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;
  static const signatureKey = "signature";

  static Future<void> configurePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int? indexFromSelectedSignature() {
    return _prefs.getInt(signatureKey);
  }

  static Future<void> removeSelectedSignature() async {
    await _prefs.remove(signatureKey);
  }

  static Future<void> addSelectedSignature(int id) async {
    await _prefs.setInt(signatureKey, id);
  }
}
