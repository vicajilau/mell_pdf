import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mell_pdf/components/file_type_icon.dart';
import 'package:mell_pdf/helper/enum_helper.dart';
import 'package:mell_pdf/model/enums.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import '../helper/utils.dart';

class FileRow extends StatelessWidget {
  final PlatformFile file;
  const FileRow({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FileTypeIcon(
            fileType:
                EnumHelper.generateSupportedFileTypeFromString(file.extension)),
        title: Text(file.name),
        trailing: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            openFileProperly(context);
          },
        ),
      ),
    );
  }

  void openFileProperly(BuildContext context) {
    final typeFile =
        EnumHelper.generateSupportedFileTypeFromString(file.extension);
    if (typeFile == SupportedFileType.jpg ||
        typeFile == SupportedFileType.png) {
      final imageProvider = Image.file(File(file.path ?? "")).image;
      showImageViewer(context, imageProvider, onViewerDismissed: () {
        Utils.printInDebug("Dismissed Image: ${file.path}");
      });
    } else if (typeFile == SupportedFileType.pdf) {
      Utils.printInDebug("Opened PDF file: ${file.path!}");
      Navigator.pushNamed(context, "/pdf_viewer_screen", arguments: file);
    }
  }
}
