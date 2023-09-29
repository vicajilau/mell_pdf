import 'package:flutter/material.dart';
import 'package:drag_pdf/common/colors/colors_app.dart';
import 'package:drag_pdf/common/localization/localization.dart';
import 'package:go_router/go_router.dart';

class FileDialog {
  static void add(
      {required BuildContext context,
      required Function loadImageFromGallery,
      required Function loadFileFromFileSystem}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(Localization.of(context)
            .string('choose_an_option')), // Choose an option
        content: Text(Localization.of(context).string('content_file_dialog')),
        // Do you want to load the image from your Gallery or file from File System?
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              context.pop();
              loadImageFromGallery.call();
            },
            child: Text(Localization.of(context).string('image')), // IMAGE
          ),
          TextButton(
            onPressed: () {
              context.pop();
              loadFileFromFileSystem.call();
            },
            child: Text(Localization.of(context).string('file')), // FILE
          ),
          TextButton(
            onPressed: () => context.pop('Cancel'),
            child: Text(
              Localization.of(context).string('cancel'), // CANCEL
              style: const TextStyle(color: ColorsApp.kMainColor),
            ),
          )
        ],
      ),
    );
  }
}
