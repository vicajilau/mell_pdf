import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:image/image.dart';
import 'package:mell_pdf/helper/pdf_helper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mell_pdf/helper/file_helper.dart';
import 'package:mell_pdf/model/file_read.dart';

import 'enums/supported_file_type.dart';

class FileManager {
  final List<FileRead> _filesInMemory = [];
  final FileHelper fileHelper;

  FileManager(this.fileHelper);

  bool hasAnyFile() => _filesInMemory.isNotEmpty;

  List<FileRead> getFiles() => _filesInMemory;

  FileRead getFile(int index) => _filesInMemory[index];

  FileRead removeFileFromDisk(int index) {
    fileHelper.removeFile(_filesInMemory[index]);
    return _filesInMemory.removeAt(index);
  }

  void removeFileFromDiskByFile(FileRead file) {
    fileHelper.removeFile(file);
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

  List<FileRead> addMultipleFiles(List<PlatformFile> files, String localPath) {
    for (PlatformFile file in files) {
      final fileRead = FileRead(File(file.path!), _nameOfNextFile(), null,
          file.size, file.extension ?? "");
      _addSingleFile(fileRead, localPath);
    }
    return _filesInMemory;
  }

  Future<List<FileRead>> addMultipleImagesOnDisk(
      List<XFile> files, String localPath, List<String> names) async {
    List<FileRead> finalFiles = [];
    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final FileRead fileRead;
      final bytes = await file.readAsBytes();
      Image? image = decodeNamedImage(file.name, bytes);
      final size = await file.length();
      final format = FileHelper.singleton.getFormatOfFile(file.path);
      fileRead = FileRead(File(file.path), names[i], image, size, format);
      final fileSaved = saveFileOnDisk(fileRead, localPath);
      finalFiles.add(fileSaved);
    }
    return finalFiles;
  }

  void _addSingleFile(FileRead file, String localPath) {
    final localFile = saveFileOnDisk(file, localPath);
    _filesInMemory.add(localFile);
  }

  void addFilesInMemory(List<FileRead> files) {
    for (FileRead file in files) {
      _filesInMemory.add(file);
    }
  }

  FileRead saveFileOnDisk(FileRead file, String localPath) =>
      fileHelper.saveFileInLocalPath(file, localPath);

  void rotateImageInMemoryAndFile(FileRead file) {
    fileHelper.rotateImageInFile(file);
  }

  void resizeImageInMemoryAndFile(FileRead file, int width, int height) {
    fileHelper.resizeImageInFile(file, width, height);
  }

  String _nameOfNextFile({int value = 1}) =>
      "File-${_filesInMemory.length + value}";

  List<String> nextNames(int numberOfFiles) {
    List<String> names = [];
    for (int i = 1; i <= numberOfFiles; i++) {
      names.add(_nameOfNextFile(value: i));
    }
    return names;
  }

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
      file = File('${fileHelper.localPath}${_nameOfNextFile()}');
      await file.writeAsBytes(await pdf.save());

      final size = await file.length();
      fileRead = FileRead(file, _nameOfNextFile(), null, size, "pdf");
      _addSingleFile(fileRead, fileHelper.localPath);
    }
    return fileRead;
  }

  Future<FileRead> generatePreviewPdfDocument(
      String outputPath, String nameOutputFile) async {
    List<String> intermediateFiles = [];
    for (FileRead file in _filesInMemory) {
      final FileRead? intermediate;
      switch (file.getExtensionType()) {
        case SupportedFileType.pdf:
          intermediate = await PDFHelper.createPdfFromOtherPdf(
              file, '${file.getFile().path}.pdf', '${file.getName()}.pdf');
          intermediateFiles.add(intermediate!.getFile().path);
          break;
        case SupportedFileType.png:
          intermediate = await PDFHelper.createPdfFromImage(
              file, '${file.getFile().path}.pdf', '${file.getName()}.pdf');
          intermediateFiles.add(intermediate!.getFile().path);
          break;
        case SupportedFileType.jpg:
          intermediate = await PDFHelper.createPdfFromImage(
              file, '${file.getFile().path}.pdf', '${file.getName()}.pdf');
          intermediateFiles.add(intermediate!.getFile().path);
          break;
        case SupportedFileType.unknown:
          throw Exception('Unknown file type in file: ${file.getName()}');
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
