import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:mell_pdf/model/file_read.dart';

class MergeableFilesList {
  final List<FileRead> _files = [];

  bool hasAnyFile() => _files.isNotEmpty;

  List<FileRead> getFiles() => _files;

  FileRead getFile(int index) => _files[index];

  FileRead removeFile(int index) => _files.removeAt(index);

  void insertFile(int index, FileRead file) => _files.insert(index, file);

  int numberOfFiles() => _files.length;

  List<FileRead> addMultipleFiles(List<PlatformFile> files) {
    for (PlatformFile file in files) {
      _files.add(FileRead(
          File(file.path!), file.size, file.name, file.extension ?? ""));
    }
    return _files;
  }

  @override
  String toString() {
    String text = "-------LOADED FILES -------- \n";
    for (FileRead file in _files) {
      text += "$file \n";
    }
    return text;
  }
}
