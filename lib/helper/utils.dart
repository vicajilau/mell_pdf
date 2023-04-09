import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mell_pdf/helper/helpers.dart';

import '../model/models.dart';

class Utils {
  static const nameOfFinalFile = 'Preview Document.pdf';

  static void printInDebug(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }

  static bool thereIsSignatureStored() {
    return false;
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
      case SupportedFileType.unknown:
        return false;
    }
  }

  static bool isPdf(FileRead file) =>
      file.getExtensionType() == SupportedFileType.pdf;

  static int getHeightOfImageFile(FileRead fileRead) {
    final image = AppSession.singleton.fileHelper.getImageOfImageFile(fileRead);
    return image?.height ?? 0;
  }

  static int getWidthOfImageFile(FileRead fileRead) {
    final image = AppSession.singleton.fileHelper.getImageOfImageFile(fileRead);
    return image?.width ?? 0;
  }

  static void openFileProperly(BuildContext context, FileRead file) {
    switch (file.getExtensionType()) {
      case SupportedFileType.pdf:
        Utils.printInDebug("Opened PDF file: ${file.getFile().path}");
        Navigator.pushNamed(context, "/pdf_viewer_screen", arguments: file);
        break;
      case SupportedFileType.png:
        _openImage(context, file);
        break;
      case SupportedFileType.jpg:
        _openImage(context, file);
        break;
      case SupportedFileType.unknown:
        throw Exception('An unknown file cannot be opened');
    }
  }

  static void _openImage(BuildContext context, FileRead file) {
    final imageProvider = Image.file(
      file.getFile(),
    ).image;
    showImageViewer(context, imageProvider, doubleTapZoomable: true,
        onViewerDismissed: () {
      Utils.printInDebug("Dismissed Image: ${file.getFile().path}");
    });
  }
}
