import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:mell_pdf/model/file_read.dart';

import '../helper/utils.dart';
import '../model/enums.dart';

class FileTypeIcon extends StatelessWidget {
  final FileRead file;
  const FileTypeIcon({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          openFileProperly(context);
        },
        child: Image.asset(
            "assets/images/files/${file.getExtensionName()}-file.png"));
  }

  void openFileProperly(BuildContext context) {
    if (file.getExtensionType() == SupportedFileType.jpg ||
        file.getExtensionType() == SupportedFileType.png ||
        file.getExtensionType() == SupportedFileType.jpeg) {
      final imageProvider = Image.file(file.getFile()).image;
      showImageViewer(context, imageProvider, onViewerDismissed: () {
        Utils.printInDebug("Dismissed Image: ${file.getFile().path}");
      });
    } else if (file.getExtensionType() == SupportedFileType.pdf) {
      Utils.printInDebug("Opened PDF file: ${file.getFile().path}");
      Navigator.pushNamed(context, "/pdf_viewer_screen", arguments: file);
    }
  }
}
