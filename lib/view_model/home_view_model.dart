import 'package:file_picker/file_picker.dart';
import 'package:mell_pdf/model/file_read.dart';
import 'package:mell_pdf/model/mergeable_files_list.dart';

class HomeViewModel {
  final MergeableFilesList _mfl = MergeableFilesList();

  Future<void> loadFilesFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png'],
    );
    await _mfl.addMultipleFiles(result?.files ?? []);
  }

  MergeableFilesList getMergeableFilesList() => _mfl;

  bool thereAreFilesLoaded() => _mfl.hasAnyFile();

  Future<FileRead> removeFileFromDisk(int index) async =>
      await _mfl.removeFileFromDisk(index);

  FileRead removeFileFromList(int index) => _mfl.removeFileFromList(index);

  void insertFileIntoList(int index, FileRead file) =>
      _mfl.insertFile(index, file);

  Future<void> clearFilesFromLocalDirectory() async =>
      await _mfl.clearFilesFromLocalDirectory();
}
