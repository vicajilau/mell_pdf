import 'dart:io';

import 'package:file_picker/file_picker.dart';

class HomeViewModel {
  List<File> files = [];

  Future<void> loadFilesFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    }
  }
}
