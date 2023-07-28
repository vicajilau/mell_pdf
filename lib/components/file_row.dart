import 'package:flutter/material.dart';
import 'package:mell_pdf/common/localization/localization.dart';
import 'package:mell_pdf/components/file_type_icon.dart';
import 'package:mell_pdf/helper/dialogs/custom_dialog.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: FileTypeIcon(file: file),
        title: Text(file.getName()),
        onTap: () {
          try {
            Utils.openFileProperly(context, file);
          } catch (error) {
            CustomDialog.showError(
                context: context,
                error: error,
                titleLocalized: '',
                subtitleLocalized: '',
                buttonTextLocalized: 'accept');
          }
        },
        subtitle: Text(
            "${Utils.printableSizeOfFile(file.getSize())} ${Localization.of(context).string('size_subtitle')}"),
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
        title: Text(Localization.of(context).string('open_file')),
        leading: const Icon(Icons.file_open),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          _showRenameFileDialog(context, file.getName(), renameButtonPressed);
        },
        title: Text(Localization.of(context).string('rename')),
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
          title: Text(Localization.of(context).string('resize_image')),
          leading: const Icon(Icons.aspect_ratio_rounded),
        ),
      );
      list.add(
        ListTile(
          onTap: () {
            Navigator.pop(context);
            rotateButtonPressed.call();
          },
          title: Text(Localization.of(context).string('rotate_image')),
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
        title: Text(
          Localization.of(context).string('remove'),
          style: const TextStyle(color: Colors.red),
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
