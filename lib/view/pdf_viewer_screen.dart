import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mell_pdf/common/localization/localization.dart';
import 'package:mell_pdf/model/models.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

import '../helper/utils.dart';

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
        actions: isFinalFile(file)
            ? [
                IconButton(
                    onPressed: () async {
                      final xFile = XFile(file.getFile().path);
                      await Share.shareXFiles([xFile],
                          text: Localization.of(context).string(
                              'document_generated_with_drag_pdf')); // Document Generated With Drag PDF
                    },
                    icon: const Icon(Icons.share))
              ]
            : null,
      ),
      body: PdfViewPinch(
        controller: pdfPinchController,
      ),
    );
  }

  bool isFinalFile(FileRead file) => file.getName() == Utils.nameOfFinalFile;
}
