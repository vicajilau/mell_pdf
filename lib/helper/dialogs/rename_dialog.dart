import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drag_pdf/common/localization/localization.dart';
import 'package:drag_pdf/helper/helpers.dart';
import 'package:go_router/go_router.dart';

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
      title: Text(Localization.of(context).string('rename_file')),
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
              labelText: Localization.of(context).string('file_name'),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Visibility(
          visible: isAcceptButtonVisible,
          child: TextButton(
            onPressed: () {
              context.pop();
              widget.acceptButtonWasPressed(nameController.text);
            },
            child: Text(
              Localization.of(context).string('accept'),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            Localization.of(context).string('cancel'),
            style: const TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
}
