import 'package:flutter/material.dart';
import 'package:mell_pdf/common/colors/colors_app.dart';
import 'package:mell_pdf/helper/local_storage.dart';
import 'package:mell_pdf/model/signature_model.dart';
import 'package:mell_pdf/view/widget/signature_thumbnail.dart';
import 'package:platform_detail/platform_detail.dart';

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
      height: widget.signatures.length <= 2
          ? 70
          : widget.signatures.length <= 4
              ? 150
              : 200,
      child: SingleChildScrollView(
        child: Wrap(
            runSpacing: 8,
            spacing: 8,
            children: List.generate(widget.signatures.length + 1, (index) {
              if (index == widget.signatures.length) {
                return Container(
                    width: 100,
                    height: 70,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: PlatformDetail.isLightMode ? null : Colors.white,
                      border: Border.all(
                        color: Colors.black54,
                        width: 0.5,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context, 'Scan');
                        Navigator.pushNamed(
                            context, "/create_signature_screen");
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        size: 30,
                        color: ColorsApp.kMainColor,
                      ),
                    ));
              } else {
                return SignatureThumbnail(
                  signature: widget.signatures[index],
                  isSelected: LocalStorage.prefs.getInt('signature') ==
                      widget.signatures[index].id,
                  callback: () => setState(() {}),
                );
              }
            })),
      ),
    );
  }
}
