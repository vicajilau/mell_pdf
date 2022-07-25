import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mell_pdf/helper/app_session.dart';
import 'package:mell_pdf/model/file_read.dart';

import '../model/enums.dart';

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

  static bool isImage(FileRead file) {
    switch (file.getExtensionType()) {
      case SupportedFileType.pdf:
        return false;
      case SupportedFileType.png:
        return true;
      case SupportedFileType.jpg:
        return true;
      case SupportedFileType.jpeg:
        return true;
      case SupportedFileType.unknown:
        return false;
    }
  }

  static int getHeightOfImageFile(FileRead fileRead) {
    final image = AppSession.singleton.fileHelper.getImageOfImageFile(fileRead);
    return image?.height ?? 0;
  }

  static int getWidthOfImageFile(FileRead fileRead) {
    final image = AppSession.singleton.fileHelper.getImageOfImageFile(fileRead);
    return image?.width ?? 0;
  }

  static void openFileProperly(BuildContext context, FileRead file) {
    if (Utils.isImage(file)) {
      final imageProvider = Image.file(
        file.getFile(),
      ).image;
      showImageViewer(context, imageProvider, onViewerDismissed: () {
        Utils.printInDebug("Dismissed Image: ${file.getFile().path}");
      });
    } else if (file.getExtensionType() == SupportedFileType.pdf) {
      Utils.printInDebug("Opened PDF file: ${file.getFile().path}");
      Navigator.pushNamed(context, "/pdf_viewer_screen", arguments: file);
    }
  }
}
