import 'package:mell_pdf/model/enums.dart';

class EnumHelper {
  static SupportedFileType generateSupportedFileTypeFromString(String? string) {
    if (string?.toLowerCase() == "pdf") {
      return SupportedFileType.pdf;
    } else if (string?.toLowerCase() == "jpg") {
      return SupportedFileType.jpg;
    } else if (string?.toLowerCase() == "png") {
      return SupportedFileType.png;
    } else {
      return SupportedFileType.unknown;
    }
  }
}
