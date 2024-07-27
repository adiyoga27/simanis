/*
  Response response = await dio.get('your_api_url');
  ResponseHandler result = await ResponseHandler.check(response);
*/

// Author: Ashta | ashtaaav@gmail.com | ashtav.github.io
// Description: ResponseHandler merupakan class yang digunakan untuk memeriksa response dari request yang dilakukan

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:lazyui/lazyui.dart' hide Errors, Response ;
import 'package:simanis/app/core/app_config.dart';
import 'package:simanis/app/core/values/value.dart';
import 'package:simanis/app/data/repository/api/api.dart';
import 'package:simanis/app/data/repository/storage/auth_storage.dart';
import 'package:simanis/app/data/services/storage/storage.dart';
import 'package:simanis/app/modules/home/controllers/home_controller.dart';
import 'package:simanis/app/routes/app_pages.dart';

class ResponseHandler {
  ResponseHandler({this.status = false, this.code, this.message, this.statusMessage, this.data = const [], this.body, this.token, this.meta});

  bool status;
  int? code;
  String? message, token, statusMessage;
  dynamic data, body, meta, transaction;

  factory ResponseHandler.fromJson(Map<String, dynamic> json) => ResponseHandler(
        status: json["status"],
        code: json["code"],
        message: json["message"] ?? json["messages"],
        statusMessage: json["status_message"],
        data: json["data"] ?? json["result"],
        body: json["body"],
        meta: json["meta"],
        token: json["bearer_token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "status_message": statusMessage,
        "data": data,
        "transaction": transaction,
        "body": body,
        "meta": meta,
        "bearer_token": token,
      };

  static Future<ResponseHandler> check(Response response, {bool ignoreUnauthorized = false}) async {
    // get time request
    var time = storage.read(response.requestOptions.path);
    String timeRequest = time == null ? '-' : '${time / 1000} ${time >= 1000 ? "s" : "ms"}';

    int? statusCode = response.statusCode;
    dynamic data = response.requestOptions.data, responseData = response.data;
    bool isResponseEmpty = '$responseData'.trim().isEmpty;

    // CONFIG
    bool bot = AppConfig.botActive;
    // dynamic chatIds = Config.bot['chatId'];
    // String botToken = Config.bot['token'];
    String appVersion = AppConfig.version, buildNumber = AppConfig.buildDate;

    // DEBUG CONSOLE ==========
    String fields = '$data';

    try {
      fields = '${response.requestOptions.data?.fields?.asMap()}';
    } catch (_) {
      fields = '${response.requestOptions.data}';
    }

    String baseUrl = response.requestOptions.baseUrl;
    String method = response.requestOptions.method;
    String statusMessage = '${response.statusMessage}';
    Map<String, dynamic> query = response.requestOptions.queryParameters;

    List<String> consoleMessages = [
      '[$method] ${response.requestOptions.path}, $statusCode ($statusMessage), $timeRequest',
      'query: ${response.requestOptions.queryParameters}',
      'body: $fields',
      'response: $responseData'
    ];

    if (query.isEmpty) consoleMessages.removeAt(1);
    if (fields.trim().isEmpty || fields.trim() == 'null') {
      consoleMessages.removeAt(consoleMessages.length == 3 ? 1 : 2);
    }

    String debugMessage = consoleMessages.map((e) => '-- $e\n').join();

    // jika status code == null, biasanya karena request timeout
    if (statusCode != null) {
      // print request to DEBUG CONSOLE
      logg('\n== DEBUG : $baseUrl');
      logg(debugMessage, color: LogColor.cyan, limit: 15000);
    }

    // LARAVEL ERROR VALIDATION RESPONSES
    if (!isResponseEmpty) {
      var jsonData = json.decode(response.data);
      if (jsonData['errors'] != null && jsonData is Map) {
        Map.from(jsonData['errors']).forEach((key, value) => logg('$key -> $value'));
      }
    }

    // BOT ==========
    if (bot) {
      List<int> ignores = [200, 201, 401, 403, 422, 429];
      final auth = await Auth.user();

      String name = auth.username == null ? 'Unknown' : '${auth.name} (${auth.username})';

      if (!ignores.contains(statusCode)) {
        int maxL = 150;

        // String baseUrl = '${response.requestOptions.baseUrl}';
        String errorMessage = responseData.length > maxL ? responseData.substring(0, maxL) + '... [TOO LONG]' : responseData;

        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        String brand = androidInfo.brand.ucwords;
        String botMessage = '';

        String method = response.requestOptions.method;

        String details = '''
<b>Details</b>
[$method] $statusCode (${response.statusMessage}), $timeRequest
$brand (${androidInfo.model}) - SDK: ${androidInfo.version.sdkInt}
$name - $group ($appVersion $buildNumber)
        ''';

        // get url without query or params
        String url = response.requestOptions.path;
        url = url.split('?')[0];

        String cleanErrorMessage = errorMessage.replaceAll('{', '').replaceAll('}', '').trimLeft().replaceAll('\n', '');

        // check status code
        switch (statusCode) {
          case 404:
            botMessage = '$url Not Found!. \n\n$cleanErrorMessage \n\n$details';
            break;

          case 500:
            botMessage = 'Terjadi kesalahan pada server dengan URL $url \n\n$details';
            break;

          default:
            botMessage = '$cleanErrorMessage. \n\n$details';
            break;
        }

        Bot.sendMessage(botMessage, AppConfig.botToken, AppConfig.botChatId);
      }
    }

    // RETURN RESPONSES =====
    List<int> okStatus = [200, 201, 202];
    bool ok = okStatus.contains(statusCode);

    // default data yang dikembalikan apabila terjadi kesalahan dan server tidak memberikan response apapun
    var defaultResponse = {
      'status': ok,
      'code': statusCode,
      'message': '',
      'status_message': response.statusMessage,
      'body': isResponseEmpty && ok
          ? {'status': ok}
          : isResponseEmpty
              ? null
              : json.decode('$response')
    };

    Map<String, dynamic> mapResult = isResponseEmpty ? defaultResponse : json.decode(response.data);

    defaultResponse.forEach((k, v) {
      if (!mapResult.containsKey(k)) mapResult[k] = v;
    });

    // COBA BUAT HANDLER RESPONSE UNTUK INI, JIKA SERVER TIDAK MENGIRIMKAN DATA, STATUS, MESSAGE LAKUKAN SESUATU!
    // if (ok && mapResult['status'] == null) {
    //   String __message =
    //       '-- Response data tidak valid (property data, status, atau message tidak ditemukan). Url: /${response.request.path} (${response.request.method})';

    //   if (chatIds is List) {
    //     chatIds.forEach((id) => Bot.sendMessage(__message, botToken, id));
    //   } else {
    //     Bot.sendMessage(__message, botToken, chatIds);
    //   }

    //   return ResponseHandler(status: true);
    // }

    // terkadang dari backend lupa atau tidak memberikan response properti seperti status, message, atau data
    // untuk menangani hal ini, kita tambahkan properti status, message, dan data

    if (mapResult['body'] == null) {
      mapResult['data'] = null;
    } else {
      if (mapResult['body']['data'] == null && mapResult['status']) {
        var resultData = mapResult['result'];
        var body = mapResult['body'];

        String messageData = mapResult['message'] ?? '';
        messageData = mapResult['messages'] ?? messageData;

        mapResult = {};
        mapResult['data'] = resultData;
        mapResult['status'] = ok;
        mapResult['code'] = statusCode;
        mapResult['message'] = messageData;
        mapResult['body'] = body;
      } else {
        String messageData = mapResult['message'] ?? '';
        messageData = mapResult['messages'] ?? messageData;

        mapResult['message'] = messageData;
      }

      if (statusCode == 422) {
        var jsonData = json.decode(response.data);

        if (jsonData['errors'] != null && jsonData['errors'] is Map) {
          List errMessages = [];
          Map.from(jsonData['errors']).forEach((key, value) => errMessages.add(value));

          if (errMessages.isNotEmpty) {
            var errorData = errMessages[0];

            if (errorData is List) {
              if (errorData.isNotEmpty) mapResult['message'] = errorData[0];
            } else {
              mapResult['message'] = errorData;
            }
          }
        }
      }

      //if unauthorized, then logout
      if (statusCode == 401) {
        await Storage.remove(only: ['user', 'token']);
        dio.options.headers['authorization'] = '';
        Get.delete<HomeController>();

        // back to login page
        // Get.offAll(() => const LoginView());
        Get.offAllNamed(Routes.LOGIN);
      }
    }

    if (response.statusCode == 500) {
      // if (Get.isDialogOpen) Get.back();

      try {
        mapResult['message'] = json.decode(responseData)['message'];
      } catch (e) {
        mapResult['message'] = 'Terjadi kesalahan pada server.';
      }

      // await ResponseHandler.statusCode(500);
      // return ResponseHandler.fromJson(mapResult);
    }

    // RETURN RESPONSE =====
    return ResponseHandler.fromJson(mapResult);
  }

  // TRY CATCH RESPONSE HANDLER
  static Future<ResponseHandler> catchResponse(dynamic e, {StackTrace? s}) async {
    var mapResponse = {
      'status': false,
      'message': '$e',
    };

    // try {
    //   // INTERNET CONNECTION (TIDAK ADA KONEKSI INTERNET)
    //   if (e.toString().contains('SocketException') || '$e'.contains('NoSuchMethodError')) {
    //     Toasts.show('Koneksi internet bermasalah.');
    //     mapResponse['message'] = 'Periksa kembali koneksi internet kamu.';

    //     return ResponseHandler.fromJson(mapResponse);
    //   }

    //   // log('--- ERROR ---');
    //   // log(e.toString());

    //   Errors.check(e, s ?? StackTrace.current);
    // } catch (e, s) {
    //   Errors.check(e, s);
    //   return ResponseHandler.fromJson(mapResponse);
    // }

    return ResponseHandler.fromJson(mapResponse);
  }

  static Future statusCode(int code) async {
    switch (code) {
      case 500:
        var errorCache = storage.read('serverError');

        if (errorCache == null) {
          await storage.write('serverError', 500);

          Get.snackbar('Oops! Server Error', 'Kami akan perbaiki masalah ini segera.',
              backgroundColor: Colors.redAccent, colorText: Colors.white, duration: const Duration(seconds: 10), borderRadius: 2);

          // Fn.timer(() async => await Storage.remove(only: ['serverError']), 10000);
        }

        break;
      default:
    }
  }
}
