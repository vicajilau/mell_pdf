import 'package:flutter/material.dart';
import 'package:mell_pdf/helper/local_storage.dart';
import 'package:mell_pdf/model/signature_model.dart';
import 'package:mell_pdf/view/widget/create_signature_button.dart';
import 'package:mell_pdf/view/widget/signature_thumbnail.dart';

class SignatureThumbnailWrap extends StatefulWidget {
  const SignatureThumbnailWrap({
    super.key,
    required this.signatures,
  });

  final List<SignatureModel> signatures;

  @override
  State<SignatureThumbnailWrap> createState() => _SignatureThumbnailWrapState();
}

class _SignatureThumbnailWrapState extends State<SignatureThumbnailWrap> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.signatures.length < 2
          ? 70
          : widget.signatures.length < 4
              ? 150
              : 200,
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          runSpacing: 8,
          spacing: 8,
          children: [
            const CreateSignatureButton(),
            ...List.generate(widget.signatures.length, (index) {
              return SignatureThumbnail(
                signature: widget.signatures[index],
                isSelected: LocalStorage.prefs.getInt('signature') ==
                    widget.signatures[index].id,
                callback: () => setState(() {}),
              );
            })
          ],
        ),
      ),
    );
  }
}
