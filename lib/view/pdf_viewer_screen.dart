import 'package:flutter/material.dart';
import 'package:mell_pdf/common/localization/localization.dart';
import 'package:mell_pdf/model/models.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

import '../helper/dialogs/custom_dialog.dart';
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
                // IconButton(
                //   onPressed: () => showDialog<String>(
                //     context: context,
                //     builder: (BuildContext context) => AlertDialog(
                //       title: Text(Localization.of(context)
                //           .string('signature_title_alert')),
                //       content: Text(Localization.of(context)
                //           .string('signature_subtitle_alert')),
                //       actions: [
                //         TextButton(
                //           onPressed: () {
                //             Navigator.pop(context);
                //           },
                //           child: Text(Localization.of(context)
                //               .string('signature_sign_alert')),
                //         ),
                //         TextButton(
                //           onPressed: () async {
                //             Navigator.pop(context, 'Scan');
                //             Navigator.pushNamed(
                //                 context, "/create_signature_screen",
                //                 arguments: file);
                //           },
                //           child: Text(Localization.of(context)
                //               .string('signature_create_alert')),
                //         ),
                //         TextButton(
                //           onPressed: () => Navigator.pop(context, 'Cancel'),
                //           child: Text(
                //             Localization.of(context).string('cancel'), // Cancel
                //             style: const TextStyle(color: ColorsApp.kMainColor),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                //   icon: const Icon(Icons.create),
                // ),
                IconButton(
                    onPressed: () async {
                      try {
                        await Share.shareXFiles(
                          [XFile(file.getFile().path)],
                          text: Localization.of(context)
                              .string('document_generated_with_drag_pdf'),
                          sharePositionOrigin: Rect.fromLTRB(
                              MediaQuery.of(context).size.width - 300,
                              0,
                              0,
                              MediaQuery.of(context).size.height - 300),
                        ); // Document Generated With Drag PDF
                      } catch (error) {
                        CustomDialog.showError(
                          context: context,
                          error: error,
                          titleLocalized: 'share_file_error_title',
                          subtitleLocalized: 'share_file_error_subtitle',
                          buttonTextLocalized: 'accept',
                        );
                      }
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
