import 'package:flutter/material.dart';
import 'package:drag_pdf/model/models.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewerScreen extends StatelessWidget {
  const PDFViewerScreen({Key? key, required this.file}) : super(key: key);
  final FileRead file;

  @override
  Widget build(BuildContext context) {
    final pdfPinchController = PdfControllerPinch(
      document: PdfDocument.openFile(file.getFile().path),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(file.getName()),
      ),
      body: PdfViewPinch(
        controller: pdfPinchController,
      ),
    );
  }
}
