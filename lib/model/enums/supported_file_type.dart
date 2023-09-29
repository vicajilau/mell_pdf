enum SupportedFileType { pdf, png, jpg, jpeg }

extension SupportedFileTypeExtension on SupportedFileType {
  String getIconPath() {
    String path = "assets/images/files/";
    switch (this) {
      case SupportedFileType.pdf:
        return "${path}pdf_file.png";
      case SupportedFileType.png:
        return "${path}png_file.png";
      case SupportedFileType.jpg:
        return "${path}jpg_file.png";
      case SupportedFileType.jpeg:
        return "${path}jpg_file.png";
    }
  }

  static List<String> namesOfSupportedExtension() =>
      SupportedFileType.values.map((e) => e.name).toList();

  static SupportedFileType fromString(String text) =>
      SupportedFileType.values.firstWhere((element) => element.name == text);
}
