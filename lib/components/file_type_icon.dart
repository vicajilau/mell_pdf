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
        Utils.openFileProperly(context, file);
      },
      child: Image.asset(file.getExtensionType().getIconPath()),
    );
  }
}
