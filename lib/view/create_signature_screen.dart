import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../common/localization/localization.dart';

class CreateSignatureScreen extends StatefulWidget {
  const CreateSignatureScreen({Key? key}) : super(key: key);

  @override
  State<CreateSignatureScreen> createState() => _CreateSignatureScreenState();
}

class _CreateSignatureScreenState extends State<CreateSignatureScreen> {
  int numberOfRedo = 0;

  late final SignatureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportPenColor: Colors.black,
      onDrawStart: () => numberOfRedo = 0,
      onDrawEnd: () => log('onDrawEnd'),
    );
    _controller.addListener(() {
      setState(() {
        log('Value changed');
      });
    });
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.of(context).string('signature_screen_title')),
        leading: IconButton(
          onPressed: () {
            if (_controller.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(Localization.of(context)
                          .string('signature_screen_back_title_alert')),
                      content: Text(Localization.of(context)
                          .string('signature_screen_back_subtitle_alert')),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'close_alert');
                            Navigator.pop(context, 'yes');
                          },
                          child: Text(Localization.of(context)
                              .string('generic_yes')), // LOAD
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context, 'no');
                          },
                          child: Text(Localization.of(context)
                              .string('generic_no')), // SCAN
                        )
                      ],
                    );
                  });
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Signature(
        controller: _controller,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: const Icon(Icons.check),
              color: Colors.blue,
              onPressed:
                  _controller.isNotEmpty ? () => exportSignature() : null,
              tooltip: Localization.of(context)
                  .string('signature_screen_save_tooltip'),
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              color: Colors.blue,
              onPressed: _controller.isNotEmpty
                  ? () {
                      setState(() {
                        _controller.undo();
                        numberOfRedo++;
                      });
                    }
                  : null,
              tooltip: Localization.of(context)
                  .string('signature_screen_undo_tooltip'),
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              color: Colors.blue,
              onPressed: numberOfRedo != 0
                  ? () {
                      setState(() {
                        _controller.redo();
                        numberOfRedo--;
                      });
                    }
                  : null,
              tooltip: Localization.of(context)
                  .string('signature_screen_redo_tooltip'),
            ),
            //CLEAR CANVAS
            IconButton(
              icon: const Icon(Icons.clear),
              color: Colors.blue,
              onPressed: _controller.isNotEmpty
                  ? () {
                      setState(() {
                        _controller.clear();
                        numberOfRedo = 0;
                      });
                    }
                  : null,
              tooltip: Localization.of(context)
                  .string('signature_screen_clear_tooltip'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      exportBackgroundColor: Colors.white,
      penColor: Colors.black,
      points: _controller.points,
    );
    //converting the signature to png bytes
    final signature = exportController.toPngBytes();
    //clean up the memory
    exportController.dispose();
    return signature;
  }
}
