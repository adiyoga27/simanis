part of api2;

class AccountApi extends Fetch {
  Future<ResHandler> getProfile() async => await get('/consumer/profile');

  Future<ResHandler> changePassword(Map<String, dynamic> data) async => await post('/ganti-password.php', data);
  Future<ResHandler> changePhone(Map<String, dynamic> data) async => await post('/ubah-hp/request-ubah-hp.php', data);
  Future<ResHandler> changePhoto(Map<String, dynamic> data, String username) async =>
      await post('update-user.php?user=$username', FormData.fromMap(data));
  Future<ResHandler> updateProfile(Map<String, dynamic> data) async => await put('/ahli-waris/ubah-waris.php', data);

}
