import 'dart:io';

import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:pdf_combiner/responses/merge_multiple_pdf_response.dart';
import 'package:pdf_combiner/responses/pdf_combiner_status.dart';
import 'package:pdf_combiner/responses/pdf_from_multiple_image_response.dart';

import '../model/file_read.dart';

class PDFHelper {
  static Future<FileRead?> createPdfFromImage(
      FileRead imageFile, String outputPath, String nameOutputFile) async {
    final imageFullPath =
        "${imageFile.getFile().path}.${imageFile.getExtensionType().name}";
    PdfFromMultipleImageResponse response =
        await PdfCombiner.createPDFFromMultipleImages(
            inputPaths: [imageFullPath], outputPath: outputPath);
    if (response.status == PdfCombinerStatus.success) {
      File intermediateFile = File(response.response!);
      final size = await intermediateFile.length();
      return FileRead(intermediateFile, nameOutputFile, null, size, "pdf");
    }
    throw Exception('Cannot be generated PDF Document');
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
