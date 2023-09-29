import 'package:flutter/material.dart';
import 'package:drag_pdf/common/colors/colors_app.dart';
import 'package:drag_pdf/common/localization/localization.dart';
import 'package:drag_pdf/helper/db_storage.dart';
import 'package:drag_pdf/helper/local_storage.dart';
import 'package:drag_pdf/helper/notification_service.dart';

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
        LocalStorage.removeSelectedSignature().then((value) =>
            NotificationService.showSnackbar(
                message: Localization.of(context)
                    .string('signature_delete_snackbar')));
        callback();
      },
      onTap: () {
        NotificationService.showSnackbar(
            message: Localization.of(context)
                .string('signature_delete_snackbar_error'),
            isError: true);
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
