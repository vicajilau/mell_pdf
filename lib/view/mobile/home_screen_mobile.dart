import 'package:flutter/material.dart';
import 'package:mell_pdf/components/file_row.dart';
import 'package:mell_pdf/view_model/home_view_model.dart';

import '../../helper/constants.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({Key? key}) : super(key: key);

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  final HomeViewModel viewModel = HomeViewModel();

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
                icon: const Icon(Icons.add))
          ],
        ),
        body: viewModel.thereAreFilesLoaded()
            ? ListView.builder(
                itemCount: viewModel.getFiles().length,
                itemBuilder: (context, position) {
                  final file = viewModel.getFiles()[position];
                  return FileRow(
                    file: file,
                  );
                })
            : Center(
                child: Image.asset('assets/images/files/file.png'),
              ),
      ),
    );
  }
}
