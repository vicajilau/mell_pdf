import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mell_pdf/components/file_row.dart';
import 'package:mell_pdf/view_model/home_view_model.dart';

import '../../helper/constants.dart';
import '../../helper/utils.dart';

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
        Utils.printInDebug("The app did enter in foreground");
        break;
      case AppLifecycleState.inactive:
        Utils.printInDebug("The app is minimize");
        break;
      case AppLifecycleState.paused:
        Utils.printInDebug("The app just went into background");
        break;
      case AppLifecycleState.detached:
        Utils.printInDebug("The app is going to close");
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
          title: const Text("Drag PDF"),
          actions: [
            IconButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Choose an option'),
                  content: const Text(
                      'Do you want to load the file(s) from disk or from the document scanner?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        await viewModel.loadFilesFromStorage();
                        setState(() {
                          Utils.printInDebug(viewModel.getMergeableFilesList());
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("Disk"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Scan'),
                      child: const Text('Scan'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Constants.kMainColor),
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
                            content: Text('Removed File: ${file.getName()}'),
                          ),
                        );
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
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
                      rotateButtonPressed: () {
                        setState(() {
                          viewModel.rotateImageInMemoryAndFile(file);
                        });
                      },
                      resizeButtonPressed: (int weight, int height) {
                        setState(() {
                          viewModel.resizeImageInMemoryAndFile(
                              file, weight, height);
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
            onPressed: () {},
            backgroundColor: Constants.kMainColor,
            child: const Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}
