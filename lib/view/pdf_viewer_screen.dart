import 'package:flutter/material.dart';
import 'package:mell_pdf/common/localization/localization.dart';
import 'package:mell_pdf/model/models.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

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
        actions: [
          IconButton(
              onPressed: () {
                Share.shareFiles([file.getFile().path],
                    text: Localization.of(context).string('document_generated_with_drag_pdf')); // Document Generated With Drag PDF
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: PdfViewPinch(
        controller: pdfPinchController,
      ),
    );
  }
}
