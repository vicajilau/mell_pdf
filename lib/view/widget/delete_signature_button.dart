import 'package:flutter/material.dart';
import 'package:mell_pdf/common/colors/colors_app.dart';
import 'package:mell_pdf/helper/db_storage.dart';
import 'package:mell_pdf/helper/notification_service.dart';

class DeleteSignatureButton extends StatelessWidget {
  const DeleteSignatureButton({
    super.key,
    required this.callback,
    required this.id,
  });

  final Function callback;
  final int id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        DBStorage.deleteSignature(id);
        callback();
      },
      onTap: () {
        NotificationService.showSnackbarError(
            'Manten pulsado para eliminar la firma');
      },
      child: Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: ColorsApp.kMainColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.close,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
