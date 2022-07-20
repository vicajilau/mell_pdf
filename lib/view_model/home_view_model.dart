import 'package:file_picker/file_picker.dart';
import 'package:mell_pdf/model/mergeable_files_list.dart';

class HomeViewModel {
  final MergeableFilesList _mfl = MergeableFilesList();

  Future<void> loadFilesFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png'],
    );
    _mfl.addMultipleFiles(result?.files);
  }

  MergeableFilesList getMergeableFilesList() => _mfl;

  bool thereAreFilesLoaded() => _mfl.hasAnyFile();

  PlatformFile removeFileFromList(int index) => _mfl.removeFile(index);

  void insertFileIntoList(int index, PlatformFile file) =>
      _mfl.insertFile(index, file);
}
