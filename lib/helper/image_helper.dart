import 'package:flutter/material.dart';

import 'package:drag_pdf/model/models.dart';

class ImageHelper {
  static Future<void> updateCache(FileRead file) async {
    final imageProvider = Image.file(
      file.getFile(),
    ).image;
    await imageProvider.evict();
  }
}
