import 'package:flutter/material.dart';
import 'package:drag_pdf/model/file_read.dart';

import '../helper/utils.dart';
import '../model/enums/supported_file_type.dart';

class FileTypeIcon extends StatelessWidget {
  final FileRead file;
  const FileTypeIcon({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Utils.openFileProperly(context, file);
      },
      child: Image.asset(file.getExtensionType().getIconPath()),
    );
  }
}
