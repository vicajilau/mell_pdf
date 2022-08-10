import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mell_pdf/common/colors/colors.dart';
import 'package:mell_pdf/common/localization/localization.dart';
import 'package:mell_pdf/components/components.dart';
import 'package:mell_pdf/view_model/view_models.dart';
import '../../helper/helpers.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({Key? key}) : super(key: key);

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile>
    with WidgetsBindingObserver {
  final HomeViewModel viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        Utils.printInDebug(Localization.of(context).string(
            'the_app_did_enter_in_foreground')); // The app did enter in foreground
        break;
      case AppLifecycleState.inactive:
        Utils.printInDebug(Localization.of(context)
            .string('the_app_is_minimize')); // The app is minimize
        break;
      case AppLifecycleState.paused:
        Utils.printInDebug(Localization.of(context).string(
            'the_app_just_went_into_background')); // The app just went into background
        break;
      case AppLifecycleState.detached:
        Utils.printInDebug(Localization.of(context)
            .string('the_app_is_going_to_close')); // The app is going to close
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove back button
          title: Text(Localization.of(context).string('drag_pdf')), // DRAG PDF
          actions: [
            IconButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(Localization.of(context)
                      .string('choose_an_option')), // Choose an option
                  content: Text(Localization.of(context).string(
                      'content_home_screen_dialog')), // 'Do you want to load the file(s) from disk or from the document scanner?'
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        FileDialog.add(
                            context: context,
                            loadImageFromGallery: () async {
                              await viewModel.loadImagesFromStorage();
                              setState(() {
                                Utils.printInDebug(
                                    viewModel.getMergeableFilesList());
                              });
                            },
                            loadFileFromFileSystem: () async {
                              await viewModel.loadFilesFromStorage();
                              setState(() {
                                Utils.printInDebug(
                                    viewModel.getMergeableFilesList());
                              });
                            });
                      },
                      child:
                          Text(Localization.of(context).string('load')), // LOAD
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context, 'Scan');
                        final file = await viewModel.scanDocument();
                        if (file != null) {
                          setState(() {
                            Utils.printInDebug("Document Scanned: $file");
                          });
                        }
                      },
                      child:
                          Text(Localization.of(context).string('scan')), // SCAN
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: Text(
                        Localization.of(context).string('cancel'), // Cancel
                        style: const TextStyle(color: ColorsApp.kMainColor),
                      ),
                    )
                  ],
                ),
              ),
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: viewModel.thereAreFilesLoaded()
            ? ReorderableListView.builder(
                itemCount: viewModel.getMergeableFilesList().numberOfFiles(),
                onReorderStart: (int value) => HapticFeedback.mediumImpact(),
                itemBuilder: (context, position) {
                  final file =
                      viewModel.getMergeableFilesList().getFile(position);
                  return Dismissible(
                    key: Key("${file.hashCode}"),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      await viewModel.removeFileFromDisk(position);
                      setState(() {
                        // Then show a snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${Localization.of(context).string('removed_toast')} ${file.getName()}'),
                          ),
                        );
                      });
                    },
                    background: Container(
                      color: ColorsApp.red,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(
                              Icons.delete,
                              color: ColorsApp.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: FileRow(
                      file: file,
                      removeButtonPressed: () {
                        setState(() {
                          viewModel.removeFileFromDiskByFile(file);
                        });
                      },
                      rotateButtonPressed: () async {
                        Loading.show(context);
                        await Future.wait([
                          IsolateHelper.createRotateIsolate(file),
                          ImageHelper.updateCache(file)
                        ]);
                        setState(() {
                          Loading.hide(context);
                        });
                      },
                      resizeButtonPressed: (int width, int height) async {
                        Loading.show(context);
                        await Future.wait([
                          IsolateHelper.createResizeIsolate(
                              file, width, height),
                          ImageHelper.updateCache(file)
                        ]);
                        setState(() {
                          Loading.hide(context);
                        });
                      },
                      renameButtonPressed: (String name) async {
                        await viewModel.renameFile(file, name);
                        setState(() {
                          Utils.printInDebug("Renamed File: $file");
                        });
                      },
                    ),
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex = newIndex - 1;
                  }
                  setState(() {
                    final element = viewModel.removeFileFromList(oldIndex);
                    viewModel.insertFileIntoList(newIndex, element);
                  });
                },
              )
            : Center(
                child: Image.asset('assets/images/files/file.png'),
              ),
        floatingActionButton: Visibility(
          visible: viewModel.thereAreFilesLoaded(),
          child: FloatingActionButton(
            onPressed: () async {
              final file = await viewModel.generatePreviewPdfDocument();
              setState(() {
                Utils.openFileProperly(context, file);
              });
            },
            backgroundColor: ColorsApp.kMainColor,
            child: const Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}
