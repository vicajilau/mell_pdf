import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewerScreen extends StatelessWidget {
  const PDFViewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final file = ModalRoute.of(context)!.settings.arguments as PlatformFile;
    final pdfPinchController = PdfControllerPinch(
      document: PdfDocument.openFile(file.path ?? ""),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
      ),
      body: PdfViewPinch(
        controller: pdfPinchController,
      ),
    );
  }
}
