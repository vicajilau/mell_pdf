import 'package:flutter/material.dart';
import 'package:mell_pdf/common/colors/colors_app.dart';
import 'package:mell_pdf/common/localization/localization.dart';
import 'package:mell_pdf/helper/local_storage.dart';
import 'package:mell_pdf/model/models.dart';
import 'package:mell_pdf/view/widget/signature_thumbnail_wrap.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

import '../helper/dialogs/custom_dialog.dart';

class PreviewDocumentScreen extends StatelessWidget {
  const PreviewDocumentScreen({Key? key}) : super(key: key);

  void showSignatureMenu(BuildContext context, FileRead file) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceAround,
        title: Text(Localization.of(context).string('signature_title_alert')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Localization.of(context).string('signature_subtitle_alert')),
            Text(Localization.of(context)
                .string('signature_subtitle_alert_options')),
            const SizedBox(height: 24),
            const SignatureThumbnailWrap(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => (LocalStorage.indexFromSelectedSignature() != null)
                ? signDocument(context)
                : null,
            child:
                Text(Localization.of(context).string('signature_sign_alert')),
          ),
          // TextButton(
          //   onPressed: () async {
          //     Navigator.pop(context, 'Scan');
          //     Navigator.pushNamed(context, "/create_signature_screen",
          //         arguments: file);
          //   },
          //   child:
          //       Text(Localization.of(context).string('signature_create_alert')),
          // ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              Localization.of(context).string('cancel'), // Cancel
              style: const TextStyle(color: ColorsApp.kMainColor),
            ),
          )
        ],
      ),
    );
  }

  void signDocument(BuildContext context) {
    Navigator.pop(context);
  }

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
            onPressed: () => showSignatureMenu(context, file),
            icon: const Icon(Icons.create),
          ),
          IconButton(
              onPressed: () async {
                try {
                  await Share.shareXFiles(
                    [XFile(file.getFile().path)],
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
        ],
      ),
      body: PdfViewPinch(
        controller: pdfPinchController,
      ),
    );
  }
}
