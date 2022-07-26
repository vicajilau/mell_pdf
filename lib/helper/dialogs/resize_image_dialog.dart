import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mell_pdf/helper/numerical_ranger_formatter.dart';
import 'package:mell_pdf/helper/utils.dart';
import 'package:mell_pdf/model/file_read.dart';

class ResizeImageDialog extends StatefulWidget {
  final FileRead file;
  final Function(int, int) resizeButtonPressed;
  const ResizeImageDialog(
      {Key? key, required this.file, required this.resizeButtonPressed})
      : super(key: key);

  @override
  State<ResizeImageDialog> createState() => _ResizeImageDialogState();
}

class _ResizeImageDialogState extends State<ResizeImageDialog> {
  final heightController = TextEditingController();
  final widthController = TextEditingController();
  late final int _maxHeight;
  late final int _maxWidth;
  bool scaleEnable = true;

  @override
  void initState() {
    super.initState();
    _maxHeight = Utils.getHeightOfImageFile(widget.file);
    _maxWidth = Utils.getWidthOfImageFile(widget.file);
  }

  @override
  void dispose() {
    heightController.dispose();
    widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modify File Size'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: heightController,
            onChanged: (text) {
              if (text.isNotEmpty && scaleEnable) {
                final numberInput = int.parse(text);
                if (_maxWidth == _maxHeight) {
                  widthController.text = numberInput.toString();
                } else {
                  final scale = _maxHeight / _maxWidth;
                  final double quotient = _maxHeight / numberInput;
                  final int value = (_maxWidth / quotient - scale).round() + 1;
                  if (value > 0) {
                    widthController.text = value.toString();
                  }
                }
              }
            },
            maxLength: _maxHeight.toString().length,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            inputFormatters: [
              NumericalRangeFormatter(min: 1, max: _maxHeight.toDouble())
            ],
            decoration: InputDecoration(
              hintText: "1 - ${_maxHeight.toString()} pixels",
              border: const OutlineInputBorder(),
              labelText: 'Height Pixels',
            ),
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: false),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: widthController,
            onChanged: (text) {
              if (text.isNotEmpty && scaleEnable) {
                final numberInput = int.parse(text);
                if (_maxWidth == _maxHeight) {
                  widthController.text = numberInput.toString();
                } else {
                  final scale = _maxHeight / _maxWidth;
                  final double quotient = _maxWidth / numberInput;
                  final int value = (_maxHeight / quotient - scale).round() + 1;
                  if (value > 0) {
                    heightController.text = value.toString();
                  }
                }
              }
            },
            maxLength: _maxWidth.toString().length,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            inputFormatters: [
              NumericalRangeFormatter(min: 1, max: _maxWidth.toDouble())
            ],
            decoration: InputDecoration(
              hintText: "1 - ${_maxWidth.toString()} pixels",
              border: const OutlineInputBorder(),
              labelText: 'Width Pixels',
            ),
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: false),
          ),
          Row(
            children: [
              Checkbox(
                  value: scaleEnable,
                  onChanged: (value) {
                    setState(() {
                      scaleEnable = value ?? false;
                    });
                  }),
              Text(scaleEnable ? 'Keep Scale' : 'Scale Disabled')
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.resizeButtonPressed(getFinalWidth(), getFinalHeight());
          },
          child: const Text(
            'ACCEPT',
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

  int getFinalWidth() {
    try {
      return int.parse(widthController.text);
    } catch (error) {
      return _maxWidth;
    }
  }

  int getFinalHeight() {
    try {
      return int.parse(heightController.text);
    } catch (error) {
      return _maxHeight;
    }
  }
}
