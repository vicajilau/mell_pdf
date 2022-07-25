import 'dart:io';

import 'package:image/image.dart';
import 'package:mell_pdf/helper/image_helper.dart';
import 'package:mell_pdf/helper/utils.dart';
import 'package:mell_pdf/model/file_read.dart';
import 'package:path_provider/path_provider.dart';

import '../model/enums.dart';

class FileHelper {
  static final FileHelper singleton = FileHelper();

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
        newFile, file.getName(), file.getSize(), file.getExtensionName());
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
        Utils.printInDebug("Document Folder Emptied");
      } catch (error) {
        Utils.printInDebug("ERROR CLEANING LOCAL FOLDER: $error");
      }
    }
  }

  void resizeImageInFile(FileRead file, int width, int height) {
    Image? image = decodeBySupportedFormat(file);
    if (image == null) {
      throw Exception('Cannot resize the image in the file: $file');
    }
    // Resize the image
    Image resizedImage = copyResize(image, width: width, height: height);
    // Save the image
    file
        .getFile()
        .writeAsBytesSync(encodeBySupportedFormat(file, resizedImage));
    ImageHelper.updateCache(file);
  }

  void rotateImageInFile(FileRead file) {
    Image? image = decodeBySupportedFormat(file);
    if (image == null) {
      throw Exception('Cannot rotate the image in the file: $file');
    }
    // Rotate 90 grades the image
    Image rotatedImage = copyRotate(image, 90);
    // Save the image
    List<int> encoded = encodeBySupportedFormat(file, rotatedImage);
    file.getFile().writeAsBytesSync(encoded);
    ImageHelper.updateCache(file);
  }

  List<int> encodeBySupportedFormat(FileRead file, Image image) {
    switch (file.getExtensionType()) {
      case SupportedFileType.png:
        return encodePng(image);
      case SupportedFileType.jpg:
        return encodeJpg(image);
      case SupportedFileType.jpeg:
        return encodeJpg(image);
      default:
        return [];
    }
  }

  Image? getImageOfImageFile(FileRead file) {
    return decodeBySupportedFormat(file);
  }

  Image? decodeBySupportedFormat(FileRead file) {
    switch (file.getExtensionType()) {
      case SupportedFileType.png:
        return decodePng(file.getFile().readAsBytesSync());
      case SupportedFileType.jpg:
        return decodeJpg(file.getFile().readAsBytesSync());
      case SupportedFileType.jpeg:
        return decodeJpg(file.getFile().readAsBytesSync());
      default:
        return null;
    }
  }
}
