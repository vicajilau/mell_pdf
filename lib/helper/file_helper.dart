import 'dart:io';

import 'package:mell_pdf/helper/utils.dart';
import 'package:mell_pdf/model/file_read.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final dirPath = '${directory.path}/files/';
    if (!Directory(dirPath).existsSync()) {
      Directory(dirPath).createSync(recursive: true);
    }
    return dirPath;
  }

  Future<FileRead> saveFileInLocalPath(FileRead file) async {
    final localPath = await _localPath;
    String fullPath = '$localPath${file.getName()}';
    File newFile = File(fullPath);
    int copy = 1;
    while (newFile.existsSync()) {
      final newName = '$copy-${file.getName()}';
      fullPath = '$localPath$newName';
      newFile = File(fullPath);
      file.setName(newName);
      copy++;
    }
    newFile.writeAsBytes(file.getFile().readAsBytesSync());
    return FileRead(
        newFile, file.getSize(), file.getName(), file.getExtensionName());
  }

  Future<void> removeFile(FileRead file) async {
    await file.getFile().delete();
  }

  Future<void> emptyLocalDocumentFolder() async {
    final localDocumentsDirectory = await getApplicationDocumentsDirectory();
    final dirPath = '${localDocumentsDirectory.path}/files/';
    final Directory directory = Directory(dirPath);
    if (directory.existsSync()) {
      try {
        directory.deleteSync(recursive: true);
        Utils.printInDebug("Document Folder Empty");
      } catch (error) {
        Utils.printInDebug("ERROR CLEANING LOCAL FOLDER: $error");
      }
    }
  }
}
