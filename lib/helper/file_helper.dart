import 'dart:io';

import 'package:image/image.dart';
import 'package:drag_pdf/helper/helpers.dart';
import 'package:drag_pdf/model/models.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static final FileHelper singleton = FileHelper();

  late String localPath;

  Future<void> loadLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    localPath = '${directory.path}/files/';
    Utils.printInDebug('LocalPath is: $localPath');
  }

  FileRead saveFileInLocalPath(FileRead file, String localPath) {
    File newFile = File('$localPath${file.getName()}');
    newFile.writeAsBytesSync(file.getFile().readAsBytesSync());
    Image? image;
    if (Utils.isImage(file)) {
      image = getImageOfImageFile(file);
    }
    return FileRead(newFile, file.getName(), image, file.getSize(),
        file.getExtensionName());
  }

  void removeFile(FileRead file) async {
    file.getFile().deleteSync();
  }

  void removeIfExist(String pathFile) {
    final file = File(pathFile);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  void emptyLocalDocumentFolder() {
    final Directory directory = Directory(localPath);
    if (directory.existsSync()) {
      try {
        directory.deleteSync(recursive: true);
        Utils.printInDebug(
            "DOCUMENT FOLDER EMPTIED"); // Document Folder Emptied
      } catch (error) {
        Utils.printInDebug("ERROR CLEANING LOCAL FOLDER: $error");
      }
    }
    if (!Directory(localPath).existsSync()) {
      Directory(localPath).createSync(recursive: true);
      Utils.printInDebug("LOCAL FOLDER CREATED");
    }
  }

  void resizeImageInFile(FileRead file, int width, int height) {
    Image? image = file.getImage();
    if (image == null) {
      throw Exception('Cannot resize the image in the file: $file');
    }
    // Resize the image
    Image resizedImage = copyResize(image, width: width, height: height);
    file.setImage(resizedImage);
    // Save the image
    file
        .getFile()
        .writeAsBytesSync(encodeBySupportedFormat(file, resizedImage));
  }

  void rotateImageInFile(FileRead file) {
    Image? image = file.getImage();
    if (image == null) {
      throw Exception('Cannot rotate the image in the file: $file');
    }
    // Rotate 90 grades the image
    Image rotatedImage = copyRotate(image, angle: 90);
    file.setImage(rotatedImage);
    // Save the image
    List<int> encoded = encodeBySupportedFormat(file, rotatedImage);
    file.getFile().writeAsBytesSync(encoded);
  }

  List<int> encodeBySupportedFormat(FileRead file, Image image) {
    switch (file.getExtensionType()) {
      case SupportedFileType.png:
        return encodePng(image);
      case SupportedFileType.jpg:
        return encodeJpg(image);
      default:
        return [];
    }
  }

  Image? getImageOfImageFile(FileRead file) {
    return decodeBySupportedFormat(file);
  }

  Image? decodeBySupportedFormat(FileRead file) {
    return decodeNamedImage(
        file.getFile().path, file.getFile().readAsBytesSync());
  }

  String getFormatOfFile(String path) {
    final parts = path.split(".");
    return parts.last;
  }
}
