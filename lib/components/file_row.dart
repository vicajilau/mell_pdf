import 'package:flutter/material.dart';
import 'package:mell_pdf/components/file_type_icon.dart';
import 'package:mell_pdf/helper/dialogs/rename_dialog.dart';
import 'package:mell_pdf/helper/dialogs/resize_image_dialog.dart';
import 'package:mell_pdf/model/file_read.dart';

import '../helper/utils.dart';

class FileRow extends StatelessWidget {
  final FileRead file;
  final Function(String) renameButtonPressed;
  final Function removeButtonPressed;
  final Function rotateButtonPressed;
  final Function(int, int) resizeButtonPressed;
  const FileRow(
      {Key? key,
      required this.file,
      required this.renameButtonPressed,
      required this.removeButtonPressed,
      required this.rotateButtonPressed,
      required this.resizeButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FileTypeIcon(file: file),
        title: Text(file.getName()),
        onTap: () => Utils.openFileProperly(context, file),
        subtitle: Text("${Utils.printableSizeOfFile(file.getSize())} in size"),
        trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: getMenu(context),
                ),
              );
            }),
      ),
    );
  }

  List<Widget> getMenu(BuildContext context) {
    List<Widget> list = [
      ListTile(
        onTap: () {
          Navigator.pop(context);
          Utils.openFileProperly(context, file);
        },
        title: const Text('Open File'),
        leading: const Icon(Icons.file_open),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          _showRenameFileDialog(context, file.getName(), renameButtonPressed);
        },
        title: const Text('Rename'),
        leading: const Icon(Icons.edit),
      ),
    ];
    if (Utils.isImage(file)) {
      list.add(
        ListTile(
          onTap: () {
            Navigator.pop(context);
            _showFileSizePickerDialog(context, resizeButtonPressed);
          },
          title: const Text('Resize Image'),
          leading: const Icon(Icons.aspect_ratio_rounded),
        ),
      );
      list.add(
        ListTile(
          onTap: () {
            Navigator.pop(context);
            rotateButtonPressed.call();
          },
          title: const Text('Rotate Image'),
          leading: const Icon(Icons.rotate_right),
        ),
      );
    }
    list.add(
      const SizedBox(
        child: Divider(
          height: 2,
        ),
      ),
    );
    list.add(
      ListTile(
        onTap: () {
          removeButtonPressed.call();
          Navigator.pop(context);
        },
        title: const Text(
          'Remove',
          style: TextStyle(color: Colors.red),
        ),
        leading: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
    list.add(
      const SizedBox(
        height: 15,
      ),
    );
    return list;
  }

  void _showFileSizePickerDialog(
      BuildContext context, Function(int, int) resizeButtonPressed) async {
    showDialog(
      context: context,
      builder: (context) => ResizeImageDialog(
        file: file,
        resizeButtonPressed: resizeButtonPressed,
      ),
    );
  }

  void _showRenameFileDialog(BuildContext context, String nameFile,
      Function(String) renameButtonPressed) {
    showDialog(
        context: context,
        builder: (context) => RenameFileDialog(
            nameFile: nameFile, acceptButtonWasPressed: renameButtonPressed));
  }
}
