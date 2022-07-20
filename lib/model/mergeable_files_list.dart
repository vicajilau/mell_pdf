import 'package:file_picker/file_picker.dart';

class MergeableFilesList {
  List<PlatformFile> _files = [];

  bool hasAnyFile() => _files.isNotEmpty;

  List<PlatformFile> getFiles() => _files;

  PlatformFile getFile(int index) => _files[index];

  PlatformFile removeFile(int index) => _files.removeAt(index);

  void insertFile(int index, PlatformFile file) => _files.insert(index, file);

  int numberOfFiles() => _files.length;

  List<PlatformFile> addMultipleFiles(List<PlatformFile>? files) =>
      _files += files ?? [];

  @override
  String toString() {
    String text = "-------LOADED FILES -------- \n";
    for (PlatformFile file in _files) {
      text += "$file \n";
    }
    return text;
  }
}
