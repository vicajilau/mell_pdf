import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mell_pdf/helper/app_session.dart';
import 'package:mell_pdf/model/file_read.dart';
import 'package:mell_pdf/model/mergeable_files_list.dart';

class HomeViewModel {
  final MergeableFilesList _mfl = AppSession.singleton.mfl;

  Future<void> loadFilesFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png'],
    );
    await _mfl.addMultipleFiles(result?.files ?? []);
  }

  Future<void> loadImagesFromStorage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      await _mfl.addMultipleImages(images);
    }
  }

  MergeableFilesList getMergeableFilesList() => _mfl;

  bool thereAreFilesLoaded() => _mfl.hasAnyFile();

  Future<FileRead> removeFileFromDisk(int index) async =>
      await _mfl.removeFileFromDisk(index);

  Future<void> removeFileFromDiskByFile(FileRead file) async =>
      await _mfl.removeFileFromDiskByFile(file);

  FileRead removeFileFromList(int index) => _mfl.removeFileFromList(index);

  void insertFileIntoList(int index, FileRead file) =>
      _mfl.insertFile(index, file);

  Future<void> clearFilesFromLocalDirectory() async =>
      await _mfl.clearFilesFromLocalDirectory();

  void rotateImageInMemoryAndFile(FileRead file) {
    _mfl.rotateImageInMemoryAndFile(file);
  }

  void resizeImageInMemoryAndFile(FileRead file, int width, int height) {
    _mfl.resizeImageInMemoryAndFile(file, width, height);
  }

  Future<void> renameFile(FileRead file, String newName) async {
    await _mfl.renameFile(file, newName);
  }

  Future<FileRead?> scanDocument(BuildContext context) async {
    return await _mfl.scanDocument(context);
  }
}
