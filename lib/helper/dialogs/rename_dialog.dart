import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mell_pdf/helper/app_session.dart';

class RenameFileDialog extends StatefulWidget {
  final String nameFile;
  final Function(String) acceptButtonWasPressed;
  const RenameFileDialog(
      {Key? key, required this.nameFile, required this.acceptButtonWasPressed})
      : super(key: key);

  @override
  State<RenameFileDialog> createState() => _RenameFileDialogState();
}

class _RenameFileDialogState extends State<RenameFileDialog> {
  final nameController = TextEditingController();
  final maxLength = 20;
  bool isAcceptButtonVisible = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename File'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            onChanged: (text) {
              if (text.isEmpty) {
                setState(() {
                  isAcceptButtonVisible = false;
                });
              } else if (AppSession.singleton.mfl
                  .isNameUsedInOtherLoadedFile(nameController.text)) {
                setState(() {
                  isAcceptButtonVisible = false;
                });
              } else {
                setState(() {
                  isAcceptButtonVisible = true;
                });
              }
            },
            maxLength: maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              hintText: widget.nameFile,
              border: const OutlineInputBorder(),
              labelText: 'File Name',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Visibility(
          visible: isAcceptButtonVisible,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.acceptButtonWasPressed(nameController.text);
            },
            child: const Text(
              'ACCEPT',
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'CANCEL',
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
}
