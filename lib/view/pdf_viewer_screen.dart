import 'package:flutter/material.dart';
import 'package:mell_pdf/model/file_read.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewerScreen extends StatelessWidget {
  const PDFViewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final file = ModalRoute.of(context)!.settings.arguments as FileRead;
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
