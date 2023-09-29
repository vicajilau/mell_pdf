import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:drag_pdf/helper/local_storage.dart';
import 'package:drag_pdf/model/signature_model.dart';
import 'package:drag_pdf/view/widget/delete_signature_button.dart';
import 'package:platform_detail/platform_detail.dart';

class SignatureThumbnail extends StatelessWidget {
  const SignatureThumbnail({
    super.key,
    required this.signature,
    required this.isSelected,
    required this.callback,
  });

  final SignatureModel signature;
  final bool isSelected;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    List<int> image = signature.image;
    Uint8List myUint8List = Uint8List.fromList(image);

    return GestureDetector(
      onTap: () {
        LocalStorage.addSelectedSignature(signature.id);
        callback();
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(8),
            width: 100,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isSelected
                  ? Colors.blueAccent.withOpacity(0.2)
                  : PlatformDetail.isLightMode
                      ? null
                      : Colors.white,
              border: Border.all(
                color: Colors.black54,
                width: 0.5,
              ),
            ),
            child: Image.memory(myUint8List),
          ),
          if (isSelected)
            Positioned(
              top: 0,
              right: 0,
              child:
                  DeleteSignatureButton(callback: callback, id: signature.id),
            ),
        ],
      ),
    );
  }
}
