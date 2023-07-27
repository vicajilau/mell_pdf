import 'package:isar/isar.dart';

part 'signature_model.g.dart';

@collection
class SignatureModel {
  Id id = Isar.autoIncrement;

  String name = '';

  List<int> image = [];
}
