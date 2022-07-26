import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mell_pdf/helper/file_helper.dart';
import 'package:mell_pdf/model/file_read.dart';

class MergeableFilesList {
  final List<FileRead> _filesInMemory = [];
  final FileHelper fileHelper;

  MergeableFilesList(this.fileHelper);

  bool hasAnyFile() => _filesInMemory.isNotEmpty;

  List<FileRead> getFiles() => _filesInMemory;

  FileRead getFile(int index) => _filesInMemory[index];

  Future<FileRead> removeFileFromDisk(int index) async {
    await fileHelper.removeFile(_filesInMemory[index]);
    return _filesInMemory.removeAt(index);
  }

  Future<void> removeFileFromDiskByFile(FileRead file) async {
    await fileHelper.removeFile(file);
    _filesInMemory.remove(file);
  }

  FileRead removeFileFromList(int index) {
    return _filesInMemory.removeAt(index);
  }

  void insertFile(int index, FileRead file) =>
      _filesInMemory.insert(index, file);

  int numberOfFiles() => _filesInMemory.length;

  Future<List<FileRead>> addMultipleFiles(List<PlatformFile> files) async {
    for (PlatformFile file in files) {
      final fileRead = FileRead(
          File(file.path!), file.name, file.size, file.extension ?? "");
      final localFile = await fileHelper.saveFileInLocalPath(fileRead);
      _filesInMemory.add(localFile);
    }
    return _filesInMemory;
  }

  Future<List<FileRead>> addMultipleImages(List<XFile> files) async {
    for (XFile file in files) {
      final FileRead fileRead;
      if (file.name.contains(".heic")) {
        String? jpegPath = await HeicToJpg.convert(file.path);
        final jpegFile = File(jpegPath!);
        fileRead = FileRead(jpegFile, file.name, jpegFile.lengthSync(), "jpeg");
      } else {
        final size = await file.length();
        fileRead = FileRead(File(file.path), file.name, size, "jpeg");
      }

      final localFile = await fileHelper.saveFileInLocalPath(fileRead);
      _filesInMemory.add(localFile);
    }
    return _filesInMemory;
  }

  void rotateImageInMemoryAndFile(FileRead file) {
    fileHelper.rotateImageInFile(file);
  }

  void resizeImageInMemoryAndFile(FileRead file, int width, int height) {
    fileHelper.resizeImageInFile(file, width, height);
  }

  Future<void> clearFilesFromLocalDirectory() async =>
      await fileHelper.emptyLocalDocumentFolder();

  @override
  String toString() {
    String text = "-------LOADED FILES -------- \n";
    for (FileRead file in _filesInMemory) {
      text += "$file \n";
    }
    return text;
  }
}
