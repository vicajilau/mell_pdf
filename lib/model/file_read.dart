import 'dart:io';

import 'package:mell_pdf/helper/enum_helper.dart';

import 'enums.dart';

class FileRead {
  File _file;
  String _name;
  final SupportedFileType _sft;
  final int _size;
  final String _extension;
  FileRead(this._file, this._name, this._size, this._extension)
      : _sft = EnumHelper.generateSupportedFileTypeFromString(_extension);

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
    return "File: $_file, size: ${getSize()}, name: $_name, extension: ${getExtensionType().name}";
  }
}
