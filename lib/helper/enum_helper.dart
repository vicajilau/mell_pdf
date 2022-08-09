import 'package:mell_pdf/model/models.dart';

class EnumHelper {
  static SupportedFileType generateSupportedFileTypeFromString(String? string) {
    if (string?.toLowerCase() == "pdf") {
      return SupportedFileType.pdf;
    } else if (string?.toLowerCase() == "jpg") {
      return SupportedFileType.jpg;
    } else if (string?.toLowerCase() == "jpeg") {
      return SupportedFileType.jpg;
    } else if (string?.toLowerCase() == "png") {
      return SupportedFileType.png;
    } else {
      return SupportedFileType.unknown;
    }
  }
}
