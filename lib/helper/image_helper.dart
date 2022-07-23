import 'package:flutter/material.dart';

import 'package:mell_pdf/model/file_read.dart';

class ImageHelper {
  static void updateCache(FileRead file) {
    final imageProvider = Image.file(
      file.getFile(),
    ).image;
    imageProvider.evict();
  }
}
