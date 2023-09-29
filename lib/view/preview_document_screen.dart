import 'package:drag_pdf/model/models.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

import '../helper/dialogs/custom_dialog.dart';

class PreviewDocumentScreen extends StatefulWidget {
  const PreviewDocumentScreen({super.key, required this.file});

  final FileRead file;

  @override
  State<PreviewDocumentScreen> createState() => _PreviewDocumentScreenState();
}

class _PreviewDocumentScreenState extends State<PreviewDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    final pdfPinchController = PdfControllerPinch(
      document: PdfDocument.openFile(widget.file.getFile().path),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("DRAG PDF"),
        actions: [
          /*IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(
                    Localization.of(context).string('signature_title_alert')),
                content: Text(Localization.of(context)
                    .string('signature_subtitle_alert')),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Localization.of(context)
                        .string('signature_sign_alert')),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context, 'Scan');
                      context.go(
                          "/home/preview_document_screen/create_signature_screen");
                    },
                    child: Text(Localization.of(context)
                        .string('signature_create_alert')),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: Text(
                      Localization.of(context).string('cancel'),
                      style: const TextStyle(color: ColorsApp.kMainColor),
                    ),
                  )
                ],
              ),
            ),
            icon: const Icon(Icons.create),
          ),*/
          IconButton(
              onPressed: () async {
                try {
                  await Share.shareXFiles(
                    [XFile(widget.file.getFile().path)],
                    sharePositionOrigin: Rect.fromLTRB(
                        MediaQuery.of(context).size.width - 300,
                        0,
                        0,
                        MediaQuery.of(context).size.height - 300),
                  ); // Document Generated With Drag PDF
                } catch (error) {
                  if (!context.mounted) return; // check "mounted" property
                  CustomDialog.showError(
                    context: context,
                    error: error,
                    titleLocalized: 'share_file_error_title',
                    subtitleLocalized: 'share_file_error_subtitle',
                    buttonTextLocalized: 'accept',
                  );
                }
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      body: PdfViewPinch(
        controller: pdfPinchController,
      ),
    );
  }
}
