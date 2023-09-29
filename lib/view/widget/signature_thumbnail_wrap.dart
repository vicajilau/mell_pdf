import 'package:flutter/material.dart';
import 'package:drag_pdf/helper/db_storage.dart';
import 'package:drag_pdf/helper/local_storage.dart';
import 'package:drag_pdf/model/signature_model.dart';
import 'package:drag_pdf/view/widget/create_signature_button.dart';
import 'package:drag_pdf/view/widget/signature_thumbnail.dart';

class SignatureThumbnailWrap extends StatefulWidget {
  const SignatureThumbnailWrap({
    super.key,
  });

  @override
  State<SignatureThumbnailWrap> createState() => _SignatureThumbnailWrapState();
}

class _SignatureThumbnailWrapState extends State<SignatureThumbnailWrap> {
  @override
  Widget build(BuildContext context) {
    final List<SignatureModel> signatures = DBStorage.getSignatures();
    return SizedBox(
      height: signatures.length < 2
          ? 90
          : signatures.length < 4
              ? 180
              : 200,
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            CreateSignatureButton(callback: () => setState(() {})),
            ...List.generate(signatures.length, (index) {
              return SignatureThumbnail(
                signature: signatures[index],
                isSelected: LocalStorage.indexFromSelectedSignature() ==
                    signatures[index].id,
                callback: () => setState(() {}),
              );
            })
          ],
        ),
      ),
    );
  }
}
