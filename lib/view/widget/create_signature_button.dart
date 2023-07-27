import 'package:flutter/material.dart';
import 'package:mell_pdf/common/colors/colors_app.dart';
import 'package:platform_detail/platform_detail.dart';

class CreateSignatureButton extends StatelessWidget {
  const CreateSignatureButton({
    required this.callback,
    super.key,
  });
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 70,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: PlatformDetail.isLightMode ? null : Colors.white,
          border: Border.all(
            color: Colors.black54,
            width: 0.5,
          ),
        ),
        child: IconButton(
          onPressed: () async {
            await Navigator.pushNamed(context, "/create_signature_screen");
            callback();
          },
          icon: const Icon(
            Icons.add_circle,
            size: 30,
            color: ColorsApp.kMainColor,
          ),
        ));
  }
}
