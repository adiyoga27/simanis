part of 'api.dart';

class AuthService {
  // login with username and password
  static Future<ResponseHandler> login(Map<String, dynamic> map) async {
    try {
      Response response = await Fetch.post('$serverApi/auth/login', data: FormData.fromMap(map));

      return await ResponseHandler.check(response);
    } catch (e) {

      return ResponseHandler.catchResponse(e);
    }
  }

   static Future<ResponseHandler> registration(Map<String, dynamic> map) async {
    try {
      Response response = await Fetch.post('$serverApi/auth/registration', data: FormData.fromMap(map));

      return await ResponseHandler.check(response);
    } catch (e) {

      return ResponseHandler.catchResponse(e);
    }
  }
     static Future<ResponseHandler> updateProfile(Map<String, dynamic> map) async {
    try {
      Response response = await Fetch.post('$serverApi/user', data: FormData.fromMap(map));

      return await ResponseHandler.check(response);
    } catch (e) {

      return ResponseHandler.catchResponse(e);
    }
  }
  static Future<ResponseHandler> verifyEmail(Map<String, dynamic> map) async {
    try {
      Response response = await Fetch.post('$serverApi/auth/resend-verification', data: FormData.fromMap(map));

      return await ResponseHandler.check(response);
    } catch (e) {

      return ResponseHandler.catchResponse(e);
    }
  }



  // forget password
  static Future<ResponseHandler> requestOtp(Map<String, dynamic> map) async {
    try {
      map['group'] = group;
      Response response = await Fetch.post('$serverApi/auth/send-otp-forget', data: FormData.fromMap(map));
      return await ResponseHandler.check(response);
    } catch (e) {
      return ResponseHandler.catchResponse(e);
    }
  }

  // change password
  static Future<ResponseHandler> resetPassword(Map<String, dynamic> map) async {
    try {
      Response response = await Fetch.post('ganti-password.php', data: FormData.fromMap(map));
      return await ResponseHandler.check(response);
    } catch (e) {
      return ResponseHandler.catchResponse(e);
    }
  }

  // verify otp forget password
  static Future<ResponseHandler> verifyOTPForgetPassword(Map<String, dynamic> map) async {
    try {
      Response response = await Fetch.post('verify-otp', data: FormData.fromMap(map));
      return await ResponseHandler.check(response);
    } catch (e) {
      return ResponseHandler.catchResponse(e);
    }
  }

}
