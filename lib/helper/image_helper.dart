import 'package:flutter/material.dart';

import 'package:mell_pdf/model/models.dart';

class ImageHelper {
  static void updateCache(FileRead file) {
    final imageProvider = Image.file(
      file.getFile(),
    ).image;
    imageProvider.evict();
  }
}
