part of 'api.dart';

class AccountApi extends Fetch {
  Future<ResHandler> getProfile() async => await get('/user');

  Future<ResHandler> changePassword(Map<String, dynamic> data) async =>
      await post('https://simanis.codingaja.my.id/api/auth/reset', data);
      
  // Future<ResHandler> changePassword(Map<String, dynamic> data) async =>
  //     await post('/auth/reset', data);
      
  Future<ResHandler> changePhone(Map<String, dynamic> data) async =>
      await post('/ubah-hp/request-ubah-hp.php', data);
  Future<ResHandler> changePhoto(
          Map<String, dynamic> data, String username) async =>
      await post('update-user.php?user=$username', FormData.fromMap(data));
  Future<ResHandler> updateProfile(Map<String, dynamic> data) async =>
      await put('/ahli-waris/ubah-waris.php', data);

          Future<ResHandler> getHome() async =>
      await get('https://simanis.codingaja.com/api/home');
}
