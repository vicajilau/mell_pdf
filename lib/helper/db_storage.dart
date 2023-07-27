import 'package:isar/isar.dart';
import 'package:mell_pdf/model/signature_model.dart';
import 'package:path_provider/path_provider.dart';

class DBStorage {
  static late Isar _isar;

  static Future<void> configureDataBase() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [SignatureModelSchema],
      directory: dir.path,
    );
  }

  static void addSignature(SignatureModel signature) {
    _isar.writeTxnSync(() {
      _isar.signatureModels.putSync(signature);
    });
  }

  static void cleanAllAndAddSignature(SignatureModel signature) {
    deleteAllSignatures();
    _isar.writeTxnSync(() {
      _isar.signatureModels.putSync(signature);
    });
  }

  static List<SignatureModel> getSignatures() {
    List<SignatureModel> signatures = [];
    _isar.txnSync(() {
      signatures = _isar.signatureModels.where().findAllSync();
    });
    return signatures;
  }

  static SignatureModel? getSignature() {
    SignatureModel? signature;
    _isar.txnSync(() {
      signature = _isar.signatureModels.where().findFirstSync();
    });
    return signature;
  }

  static void deleteAllSignatures() {
    final signatures = getSignatures();
    _isar.writeTxnSync(() {
      _isar.signatureModels.deleteAllSync(signatures.map((e) => e.id).toList());
    });
  }

  static void deleteSignature(int id) {
    _isar.writeTxnSync(() {
      _isar.signatureModels.deleteSync(id);
    });
  }
}
