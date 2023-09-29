import 'package:drag_pdf/helper/file_helper.dart';
import 'package:drag_pdf/helper/file_manager.dart';

class AppSession {
  static AppSession singleton = AppSession();

  FileHelper fileHelper = FileHelper.singleton;
  FileManager mfl = FileManager(FileHelper.singleton);
  bool loading = false;
}
