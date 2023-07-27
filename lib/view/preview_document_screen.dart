import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mell_pdf/common/colors/colors_app.dart';
import 'package:mell_pdf/common/localization/localization.dart';
import 'package:mell_pdf/helper/local_storage.dart';
import 'package:mell_pdf/model/models.dart';
import 'package:pdfx/pdfx.dart';
import 'package:platform_detail/platform_detail.dart';
import 'package:share_plus/share_plus.dart';

import '../helper/dialogs/custom_dialog.dart';

class PreviewDocumentScreen extends StatelessWidget {
  const PreviewDocumentScreen({Key? key}) : super(key: key);

  void showSignatureMenu(BuildContext context, FileRead file) {
    final signature = DBStorage.getSignature();
    List<int> image = [];
    late Uint8List? myUint8List;
    if (signature != null) {
      image = signature.image;
      myUint8List = Uint8List.fromList(image);
    }

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(Localization.of(context).string('signature_title_alert')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Localization.of(context).string('signature_subtitle_alert')),
            const SizedBox(height: 24),
            Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                color: PlatformDetail.isLightMode ? null : Colors.white,
                border: Border.all(
                  color: Colors.black54,
                  width: 0.5,
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: image.isNotEmpty
                  ? Image.memory(myUint8List!)
                  : const Text('No signature'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // TODO
            },
            child:
                Text(Localization.of(context).string('signature_sign_alert')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Scan');
              Navigator.pushNamed(context, "/create_signature_screen",
                  arguments: file);
            },
            child:
                Text(Localization.of(context).string('signature_create_alert')),
          ),
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
        ],
      ),
      body: PdfViewPinch(
        controller: pdfPinchController,
      ),
    );
  }
}
