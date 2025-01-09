import 'dart:io';

import 'package:drag_pdf/helper/file_manager.dart';
import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:pdf_combiner/responses/merge_multiple_pdf_response.dart';
import 'package:pdf_combiner/responses/pdf_combiner_status.dart';
import 'package:pdf_combiner/responses/pdf_from_multiple_image_response.dart';

import '../model/file_read.dart';

/// Helper class to handle PDF creation and manipulation.
class PDFHelper {
  /// Creates a PDF document from a single image file.
  ///
  /// - [imageFile]: The image file to convert into a PDF.
  /// - [outputPath]: The directory where the PDF will be saved.
  /// - [nameOutputFile]: The desired name of the output PDF file.
  ///
  /// Returns a [FileRead] object representing the created PDF, or throws an exception
  /// if the PDF could not be generated.
  static Future<FileRead?> createPdfFromImage(
      FileRead imageFile, String outputPath, String nameOutputFile) async {
    // Request PDF creation from the image file using PdfCombiner.
    PdfFromMultipleImageResponse response =
        await PdfCombiner.createPDFFromMultipleImages(
            inputPaths: [imageFile.getFile().path],
            outputPath: outputPath,
            needImageCompressor: false);

    // If the operation was successful, return a FileRead instance for the PDF.
    if (response.status == PdfCombinerStatus.success) {
      File intermediateFile = File(response.response!);
      final size = await intermediateFile.length();
      return FileRead(intermediateFile, nameOutputFile.removeExtension(), null, size, "pdf");
    }

    // Throw an exception if PDF creation fails.
    throw Exception('Cannot be generated PDF Document');
  }

  /// Copies an existing PDF file to a new location with a specified name.
  ///
  /// - [pdfFile]: The original PDF file to copy.
  /// - [outputPath]: The target directory for the copied PDF.
  /// - [nameOutputFile]: The desired name for the copied PDF.
  ///
  /// Returns a [FileRead] object representing the copied PDF.
  static Future<FileRead?> createPdfFromOtherPdf(
      FileRead pdfFile, String outputPath, String nameOutputFile) async {
    // Copy the PDF file to the specified output path.
    final file = pdfFile.getFile().copySync(outputPath);
    return FileRead(file, nameOutputFile, null, file.lengthSync(), 'pdf');
  }

  /// Merges multiple PDF documents into a single PDF file.
  ///
  /// - [paths]: A list of file paths to the PDFs to merge.
  /// - [outputPath]: The directory where the merged PDF will be saved.
  /// - [nameOutputFile]: The desired name of the merged PDF file.
  ///
  /// Returns a [FileRead] object representing the merged PDF, or throws an exception
  /// if the merge operation fails.
  static Future<FileRead> mergePdfDocuments(
      List<String> paths, String outputPath, String nameOutputFile) async {
    // Request merging of multiple PDFs using PdfCombiner.
    MergeMultiplePDFResponse response = await PdfCombiner.mergeMultiplePDFs(
        inputPaths: paths, outputPath: outputPath);

    // If the operation was successful, return a FileRead instance for the merged PDF.
    if (response.status == PdfCombinerStatus.success) {
      File intermediateFile = File(response.response!);
      final size = await intermediateFile.length();
      return FileRead(intermediateFile, nameOutputFile.removeExtension(), null, size, "pdf");
    }

    // Throw an exception if merging fails.
    throw Exception('Cannot be generated PDF Document');
  }
}
