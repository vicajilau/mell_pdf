import 'package:mell_pdf/helper/file_helper.dart';
import 'package:mell_pdf/model/mergeable_files_list.dart';

class AppSession {
  static AppSession singleton = AppSession();

  FileHelper fileHelper = FileHelper.singleton;
  MergeableFilesList mfl = MergeableFilesList(FileHelper.singleton);
}
