import 'dart:io';

import 'package:mell_pdf/helper/enum_helper.dart';

import 'enums.dart';

class FileRead {
  final File _file;
  String _name;
  final SupportedFileType _sft;
  final String _extension;
  FileRead(this._file, this._name, this._extension)
      : _sft = EnumHelper.generateSupportedFileTypeFromString(_extension);

  File getFile() => _file;

  int getSize() => _file.lengthSync();

  String getName() => _name;

  void setName(String name) => _name = name;

  String getExtensionName() => _extension;

  SupportedFileType getExtensionType() => _sft;

  @override
  String toString() {
    return "File: $_file, size: ${getSize()}, name: $_name, extension: ${getExtensionType().name}";
  }
}
