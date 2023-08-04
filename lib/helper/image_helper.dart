import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mell_pdf/model/models.dart';

class ImageHelper {
  static Future<void> updateCache(FileRead file) async {
    final imageProvider = Image.file(
      file.getFile(),
    ).image;
    await imageProvider.evict();
  }

  static Image createImageFromMemory(List<int> elements) {
    Uint8List bytes = Uint8List.fromList(elements);
    return Image.memory(bytes);
  }
}
