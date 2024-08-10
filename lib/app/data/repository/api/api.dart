library api;

import 'package:dio/dio.dart';
import 'package:simanis/app/core/app_config.dart';
import 'package:simanis/app/core/utils//api_helper.dart';
import 'package:simanis/app/core/values/value.dart';
import 'package:simanis/app/data/repository/api/response_handler.dart';

part 'auth_service.dart';
// part 'achievement_service.dart';
// part 'address_service.dart';
// part 'member_service.dart';
// part 'menu_service.dart';
// part 'payment_service.dart';
// part 'promo_service.dart';
// part 'reward_service.dart';
// part 'shop_service.dart';
// part 'ticket_service.dart';
// part 'user_service.dart';
// part 'vmoney_service.dart';

// CONFIG DIO

BaseOptions dioOptions(String baseUrl, String token) => BaseOptions(
    followRedirects: false,
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 200),
    headers: {'Accept': 'application/json', 'Content-Type': 'application/x-www-form-urlencoded', 'authorization': token},
    responseType: ResponseType.plain,
    validateStatus: (status) => status! <= 598);

final Dio dio = Dio(dioOptions(AppConfig.baseUrl, ''));

String localBaseUrl = 'https://simanis.codingaja.my.id/api',
    serverApi = 'https://simanis.codingaja.my.id/api';

/*
  # NOTE 

  Untuk saat ini, url api yang digunakan adalah native dan laravel,
  Untuk native sendiri permission akses datanya dengan param idmember,
  sedangkan laravel dengan token

 https://simanis.codingaja.my.id/api/v1/ -> 
*/

class UtilRh {
  static Future tryx(Function() fn) async {
    try {
      return await fn();
    } catch (e) {
      return ResponseHandler.catchResponse(e);
    }
  }
}
