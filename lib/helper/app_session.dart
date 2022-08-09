import 'package:mell_pdf/helper/file_helper.dart';
import 'package:mell_pdf/model/file_manager.dart';

class AppSession {
  static AppSession singleton = AppSession();

  FileHelper fileHelper = FileHelper.singleton;
  FileManager mfl = FileManager(FileHelper.singleton);
}
