import 'dart:io';

import 'package:image/image.dart';

import 'enums/supported_file_type.dart';

class FileRead {
  File _file;
  String _name;
  Image? _image;
  final SupportedFileType _sft;
  final int _size;
  final String _extension;
  FileRead(this._file, this._name, this._image, this._size, this._extension)
      : _sft = SupportedFileTypeExtension.fromString(_extension);

  Image? getImage() => _image;

  void setImage(Image? image) => _image = image;

  File getFile() => _file;

  void setFile(File newFile) => _file = newFile;

  int getSize() {
    try {
      return _file.lengthSync();
    } catch (error) {
      return _size;
    }
  }

  String getName() => _name;

  void setName(String name) => _name = name;

  String getExtensionName() => _extension;

  SupportedFileType getExtensionType() => _sft;

  @override
  String toString() {
    return "File: $_file, size: ${getSize()}, name: $_name, extension: ${getExtensionType().name}, image-width: ${getImage()?.width}, image-height: ${getImage()?.height}";
  }
}
