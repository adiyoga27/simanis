import 'package:simanis/app/data/models/user_model.dart';
import 'package:simanis/app/data/services/storage/storage.dart';

UserModel auth = UserModel();

class Auth {
  static Future<UserModel> user() async {
    try {
      Map<String, dynamic> map = storage.read('user') ?? {};
      return UserModel.fromJson(map);
    } catch (e) {
      return UserModel();
    }
  }
}
