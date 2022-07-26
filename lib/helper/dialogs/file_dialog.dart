import 'package:flutter/material.dart';

import '../constants.dart';

class FileDialog {
  static void add(
      {required BuildContext context,
      required Function loadImageFromGallery,
      required Function loadFileFromFileSystem}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Choose an option'),
        content: const Text(
            'Do you want to load the image(s) from your Gallery or file(s) from your File System?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              loadImageFromGallery.call();
            },
            child: const Text("IMAGE"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              loadFileFromFileSystem.call();
            },
            child: const Text('FILE'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Constants.kMainColor),
            ),
          )
        ],
      ),
    );
  }
}
