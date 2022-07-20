import 'package:flutter/material.dart';

import '../model/enums.dart';

class FileTypeIcon extends StatelessWidget {
  final SupportedFileType fileType;
  const FileTypeIcon({Key? key, required this.fileType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/files/${fileType.name}-file.png");
  }
}
