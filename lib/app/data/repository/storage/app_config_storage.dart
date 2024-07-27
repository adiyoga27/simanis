import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/data/services/storage/storage.dart';

class AppConfigStorage {
  static Future<Map> getConfig() async {
    Map config = {};

    try {
      Map data = storage.read('app_config') ?? {};
      config = data;
    } catch (e, s) {
      Errors.check(e, s);
    }

    return config;
  }
}
