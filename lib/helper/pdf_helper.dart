import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_merger/pdf_merger.dart';

import '../model/file_read.dart';

class PDFHelper {
  static Future<FileRead?> createPdfFromImage(
      FileRead imageFile, String outputPath, String nameOutputFile) async {
    final image = pw.MemoryImage(
      imageFile.getFile().readAsBytesSync(),
    );
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(image),
      );
    }));

    final intermediateFile = File(outputPath);
    await intermediateFile.writeAsBytes(await pdf.save());
    return FileRead(intermediateFile, nameOutputFile, null,
        intermediateFile.lengthSync(), 'pdf');
  }

  static Future<FileRead?> createPdfFromOtherPdf(
      FileRead pdfFile, String outputPath, String nameOutputFile) async {
    final file = pdfFile.getFile().copySync(outputPath);
    return FileRead(file, nameOutputFile, null, file.lengthSync(), 'pdf');
  }

  static Future<FileRead?> createPdfFromWord(
      FileRead wordFile, String outputPath, String nameOutputFile) async {
    final file = wordFile.getFile().copySync(outputPath);
    return FileRead(file, nameOutputFile, null, file.lengthSync(), '.docx');
  }

  static Future<FileRead> mergePdfDocuments(
      List<String> paths, String outputPath, String nameOutputFile) async {
    MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
        paths: paths, outputDirPath: outputPath);
    if (response.status == "success") {
      File intermediateFile = File(response.response!);
      final size = await intermediateFile.length();
      return FileRead(intermediateFile, nameOutputFile, null, size, "pdf");
    }
    throw Exception('Cannot be generated PDF Document');
  }

  static Future<List<String?>> createImageFromPDF(String singleFile, String outputDirPath) async {
    CreateImageFromPDFResponse response  = await PdfMerger.createImageFromPDF(path: singleFile, outputDirPath: outputDirPath);

    if(response.status == "success" && response.response != null) {
      return response.response!;
    }
    throw Exception('Cannot be generated Image from PDF Document');
  }
}
