import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:pdf_combiner/responses/merge_multiple_pdf_response.dart';
import 'package:pdf_combiner/responses/pdf_combiner_status.dart';

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
    return FileRead(file, nameOutputFile, null, file.lengthSync(), 'pdf');
  }

  static Future<FileRead> mergePdfDocuments(
      List<String> paths, String outputPath, String nameOutputFile) async {
    MergeMultiplePDFResponse response = await PdfCombiner.mergeMultiplePDFs(
        inputPaths: paths, outputPath: outputPath);
    if (response.status == PdfCombinerStatus.success) {
      File intermediateFile = File(response.response!);
      final size = await intermediateFile.length();
      return FileRead(intermediateFile, nameOutputFile, null, size, "pdf");
    }
    throw Exception('Cannot be generated PDF Document');
  }
}
