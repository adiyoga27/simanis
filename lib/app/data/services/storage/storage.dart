import 'package:get_storage/get_storage.dart';

late GetStorage storage;

class Storage {
  static Future remove({List<String> only = const [], List<String> except = const [], List<String> contains = const []}) async {
    final List<String> keys = storage.getKeys().toList();

    for (var i = 0; i < keys.length; i++) {
      if (except.isEmpty) {
        if (only.isNotEmpty) {
          if (only.contains(keys[i])) {
            storage.remove(keys[i]);
          }
        } else {
          // jika terdapat key yang mirip, maka hapus
          if (contains.isNotEmpty) {
            for (var e in contains) {
              if (keys[i].contains(e)) {
                storage.remove(keys[i]);
              }
            }
          } else {
            storage.remove(keys[i]);
          }
        }
      } else {
        if (!except.contains(keys[i])) {
          storage.remove(keys[i]);
        }
      }
    }
  }
}
