import 'package:flutter/material.dart';
import 'package:mell_pdf/components/file_type_icon.dart';
import 'package:mell_pdf/model/file_read.dart';

import '../helper/utils.dart';

class FileRow extends StatelessWidget {
  final FileRead file;
  const FileRow({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FileTypeIcon(file: file),
        title: Text(file.getName()),
        subtitle: Text("${Utils.printableSizeOfFile(file.getSize())} in size"),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }
}
