import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:mell_pdf/helper/pdf_helper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mell_pdf/helper/file_helper.dart';
import 'package:mell_pdf/model/file_read.dart';

import '../helper/utils.dart';

class FileManager {
  final List<FileRead> _filesInMemory = [];
  final FileHelper fileHelper;

  FileManager(this.fileHelper);

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

  bool isNameUsedInOtherLoadedFile(String name) =>
      _filesInMemory.indexWhere((element) => element.getName() == name) != -1;

  Future<void> renameFile(FileRead file, String newFileName) async {
    var path = file.getFile().path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    final newFile = await file.getFile().rename(newPath);
    file.setFile(newFile);
    file.setName(newFileName);
  }

  void insertFile(int index, FileRead file) =>
      _filesInMemory.insert(index, file);

  int numberOfFiles() => _filesInMemory.length;

  Future<List<FileRead>> addMultipleFiles(List<PlatformFile> files) async {
    for (PlatformFile file in files) {
      final fileRead = FileRead(
          File(file.path!), _nameOfNextFile(), file.size, file.extension ?? "");
      await _addSingleFile(fileRead);
    }
    return _filesInMemory;
  }

  Future<List<FileRead>> addMultipleImages(List<XFile> files) async {
    for (XFile file in files) {
      final FileRead fileRead;
      if (file.name.contains(".heic")) {
        String? jpegPath = await HeicToJpg.convert(file.path);
        final jpegFile = File(jpegPath!);
        fileRead = FileRead(
            jpegFile, _nameOfNextFile(), jpegFile.lengthSync(), "jpeg");
      } else {
        final size = await file.length();
        fileRead = FileRead(File(file.path), _nameOfNextFile(), size, "jpeg");
      }
      await _addSingleFile(fileRead);
    }
    return _filesInMemory;
  }

  Future<void> _addSingleFile(FileRead file) async {
    final localFile = await saveFile(file);
    _filesInMemory.add(localFile);
  }

  Future<FileRead> saveFile(FileRead file) async =>
      await fileHelper.saveFileInLocalPath(file);

  void rotateImageInMemoryAndFile(FileRead file) {
    fileHelper.rotateImageInFile(file);
  }

  void resizeImageInMemoryAndFile(FileRead file, int width, int height) {
    fileHelper.resizeImageInFile(file, width, height);
  }

  Future<void> clearFilesFromLocalDirectory() async =>
      await fileHelper.emptyLocalDocumentFolder();

  String _nameOfNextFile() => "File-${_filesInMemory.length + 1}";

  Future<FileRead?> scanDocument() async {
    FileRead? fileRead;
    List<String>? paths = await CunningDocumentScanner.getPictures();
    if (paths != null) {
      final pdf = pw.Document();
      File file;
      for (String path in paths) {
        final image = pw.MemoryImage(
          File(path).readAsBytesSync(),
        );

        pdf.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        }));
      }
      final lp = await fileHelper.localPath;
      file = File('$lp${_nameOfNextFile()}');
      await file.writeAsBytes(await pdf.save());

      final size = await file.length();
      fileRead = FileRead(file, _nameOfNextFile(), size, "pdf");
      await _addSingleFile(fileRead);
    }
    return fileRead;
  }

  Future<FileRead> generatePreviewPdfDocument(
      String outputPath, String nameOutputFile) async {
    List<String> intermediateFiles = [];
    for (FileRead file in _filesInMemory) {
      if (Utils.isImage(file)) {
        final intermediate = await PDFHelper.createPdfFromImage(
            file, '${file.getFile().path}.pdf', '${file.getName()}.pdf');
        intermediateFiles.add(intermediate!.getFile().path);
      } else if (Utils.isPdf(file)) {
        final intermediate = await PDFHelper.createPdfFromOtherPdf(
            file, '${file.getFile().path}.pdf', '${file.getName()}.pdf');
        intermediateFiles.add(intermediate!.getFile().path);
      }
    }
    FileRead fileRead = await PDFHelper.mergePdfDocuments(
        intermediateFiles, outputPath, nameOutputFile);
    return fileRead;
  }

  @override
  String toString() {
    String text = "-------LOADED FILES -------- \n";
    for (FileRead file in _filesInMemory) {
      text += "$file \n";
    }
    return text;
  }
}
