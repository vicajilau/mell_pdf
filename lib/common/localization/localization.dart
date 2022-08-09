import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Localization {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  Localization(this.locale);

  static const LocalizationsDelegate<Localization> delegate =
  _LocalizationDelegate();

  String string(String key) {
    return _localizedStrings[key] ?? key;
  }

  Future<bool> load() async {
    String jsonString = await _loadLangAsset();
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization)!;
  }

  Future _loadLangAsset() async {
    try {
      return await rootBundle
          .loadString('assets/strings/${locale.languageCode}.json');
    } catch (_) {
      return await rootBundle.loadString('assets/strings/en.json');
    }
  }
}

class _LocalizationDelegate extends LocalizationsDelegate<Localization> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _LocalizationDelegate();

  @override
  Future<Localization> load(Locale locale) async {
    Localization localization = Localization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_LocalizationDelegate old) => false;

  @override
  bool isSupported(Locale locale) => true; // Support all languages
}
