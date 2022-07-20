import 'package:file_picker/file_picker.dart';

class HomeViewModel {
  List<PlatformFile> _files = [];

  Future<void> loadFilesFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );
    _files += result?.files ?? [];
  }

  List<PlatformFile> getFiles() => _files;

  bool thereAreFilesLoaded() => _files.isNotEmpty;
}
