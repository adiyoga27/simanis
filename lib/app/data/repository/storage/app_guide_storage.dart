import 'package:simanis/app/data/services/storage/storage.dart';

enum ATType {
  intro,
  databaseMember,
  product,
  claimBonus,
  invoice,
  invoice1,
  imageDetailProduct,
  term,
  invoicePage,
  memberIDs,
  letter1,
  letter2,
  autoFillDeliv
}

class AppTutor {
  static mark(ATType key) async {
    return await storage.write('guide_$key', true);
  }

  static bool get(ATType key) => storage.read('guide_$key') ?? false;

  static Future remove(ATType key) async => await storage.remove('guide_$key');
}
