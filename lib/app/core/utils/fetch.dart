// 🎯 Dart imports:
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:lazyui/lazyui.dart' hide Response;
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/data/repository/api/api.dart';

bool _dismissOverlay = true;

extension FetchExtension on Future<ResHandler> {
  Future<ResHandler> keepOverlay() {
    _dismissOverlay = false;
    return this;
  }
}

extension DioExtension on Dio {
  void setToken(String token, {String? prefix}) {
    dio2.options.headers['authorization'] = prefix == null ? 'Bearer $token' : '$prefix $token';
  }

  int get logLimit => 2000;
}

extension ListFetchExtension on List<Future<ResHandler>> {
  /// ``` dart
  /// final reqUser = api.getUser();
  /// final reqProduct = api.getProduct();
  ///
  /// ResHandler res = await [reqUser, reqProduct].request();
  /// ```
  Future<ResHandler> request() async {
    Stopwatch stopWatch = Stopwatch();
    stopWatch.start();

    ResHandler result = ResHandler(status: false);
    List<ResHandler> handlers = [];

    await Future.forEach(this, (req) async {
      ResHandler res = await req.keepOverlay();
      handlers.add(res);
    });

    // dismiss overlay
    if (_dismissOverlay) Toasts.dismiss();

    // log message
    bool ok = false;
    String logMessage = '';

    // find error (status false)
    if (handlers.any((e) => !e.status)) {
      result = handlers.firstWhere((e) => !e.status);
      logMessage = 'Path: ${result.path}, Message: ${result.message}';
    } else {
      ok = true;
      result = ResHandler(status: true, data: [...handlers.map((e) => e.data).toList()], message: 'Request success');
    }

    stopWatch.stop();

    int time = stopWatch.elapsed.inMilliseconds;
    String timeRequest = '${time / 1000} ${time >= 1000 ? "s" : "ms"}';

    // log request
    logg('\n== GROUP REQUEST : $length Request(s) | $timeRequest | ${ok ? 'Success' : 'Failed'}');
    if (logMessage.isNotEmpty) logg(logMessage, color: LogColor.cyan);

    return result;
  }
}

BaseOptions _options = BaseOptions(
    followRedirects: false,
    baseUrl: serverApi,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 200),
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    responseType: ResponseType.plain,
    validateStatus: (status) => status! <= 598);

Dio dio2 = Dio(_options);

abstract class Fetch extends ResHandler {
  Future<ResHandler> _fetch(String method, String path, {Map<String, dynamic>? query, dynamic data, Function(int, int)? onReceiveProgress}) async {
    ResHandler result = ResHandler(status: false);
    Stopwatch stopWatch = Stopwatch();

    try {
      stopWatch.start();
      Response response = await dio2.fetch(RequestOptions(
          baseUrl: dio2.options.baseUrl,
          method: method,
          path: path,
          queryParameters: query,
          data: data,
          onReceiveProgress: onReceiveProgress,
          followRedirects: dio2.options.followRedirects,
          connectTimeout: dio2.options.connectTimeout,
          receiveTimeout: dio2.options.receiveTimeout,
          headers: dio2.options.headers,
          responseType: dio2.options.responseType,
          validateStatus: dio2.options.validateStatus));

      stopWatch.stop();
      result = await check(response, stopWatch.elapsed.inMilliseconds);
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      if (_dismissOverlay) {
        Toasts.dismiss();
      }

      _dismissOverlay = true;
    }

    return result;
  }

  /* ------------------------------------------------------------------------------
  | GET, POST, PUT, DELETE Request
  | */

  Future<ResHandler> get(String path, {Map<String, dynamic>? query, Options? options, Function(int, int)? onReceiveProgress}) async {
    return await _fetch('GET', path, query: query, onReceiveProgress: onReceiveProgress);
  }

  Future<ResHandler> post(String path, dynamic data) async => await _fetch('POST', path, data: data);
  Future<ResHandler> put(String path, dynamic data) async => await _fetch('PUT', path, data: data);
  Future<ResHandler> delete(String path) async => await _fetch('DELETE', path);
}

class ResHandler {
  final bool status;
  final int? statusCode;
  final String? path, message;
  final dynamic data, body;

  ResHandler({this.status = false, this.statusCode, this.path, this.message, this.data, this.body});

  // check response

  // why do we need Response Handler?
  // we don't know what kind of response we will get from server
  // we have to make sure that we get the right response

  /* 
    response that we expect:

    response = {
      "status": true,
      "message": "Data received!",
      "data": [] or {},
    }

    if one of the key is missing, we will get null and ERROR!
    so, we have to make sure that all of the key is available
    if the server doesn't return the key, we have to make it

    bisides, we have to show the request information in debug console
    and report the error with Bot (eg: telegram)
  */

  Future<ResHandler> check(Response response, int time) async {
    RequestOptions req = response.requestOptions;

    String baseUrl = req.baseUrl, method = req.method, path = req.path, statusMessage = response.statusMessage ?? 'No status message';
    int? statusCode = response.statusCode;
    dynamic responseData = response.data;

    Map<String, dynamic> query = req.queryParameters;

    // TIME REQUEST
    // we need to know how long it takes to get the response
    String timeRequest = '${time / 1000} ${time >= 1000 ? "s" : "ms"}';

    List<int> okStatus = [200, 201, 202];
    bool ok = okStatus.contains(statusCode);

    // DEBUG CONSOLE ==========================================================
    // show the request information in debug console

    String reqOptions = req.data.toString();

    if (req.data is FormData) {
      dynamic fields = req.data.fields;
      reqOptions += ' | ';

      if (fields is List) {
        for (var f in fields) {
          if (f is MapEntry) {
            reqOptions += '${f.key}: ${f.value}, ';
          }
        }
      }
    }

    String requestInfo = '$path, $statusCode ($statusMessage), $timeRequest';
    List<String> consoleMessages = ['[$method] $requestInfo', 'query: $query', 'body: $reqOptions', 'response: $responseData'];

    if (query.isEmpty) consoleMessages.removeAt(1);
    if (reqOptions.isEmpty || reqOptions == 'null') consoleMessages.removeAt(consoleMessages.length == 3 ? 1 : 2);

    String debugMessage = consoleMessages.map((e) => '-- $e\n').join();

    // statusCode = null is usually when the server is not available or request is timeout
    if (statusCode != null) {
      // print request information

      logg('\n== BASE URL : $baseUrl');
      logg(debugMessage, color: LogColor.cyan, limit: dio2.logLimit);
    }

    if (statusCode == 401 && path != 'login') {
      // back to login page
      Toasts.show('Unauthorized, silakan login kembali');
      Get.offAllNamed('/login');
    }

    String? message, serverMessage;
    dynamic data;

    if (responseData != null) {
      try {
        // try convert data to json
        Map<String, dynamic> map = json.decode(responseData);

        message = map['message'].toString();
        serverMessage = map['message'].toString();
        data = map['data'] == null ? map['result'] : map['data'] ?? map;

        if (statusCode == 500) {
          message = 'Terjadi kesalahan pada server, silakan coba lagi nanti.';
        } else if (statusCode == 422) {
          if (map['errors'] != null) {
            Map.from(map['errors']).forEach((key, value) {
              if (value is List && value.toList().isNotEmpty) {
                message = value[0];
              }
            });
          }
        }

        responseData = map;
      } catch (e) {
        // if failed, let it be default
      }
    }

    List<int> ignoreStatus = [401, 422];

    if (!ok && !ignoreStatus.contains(statusCode)) {
      // 401 is unauthorized
      Toasts.show(message);
      Errors.check(serverMessage, StackTrace.current, networkError: NetworkError(baseUrl: baseUrl, path: consoleMessages[0], error: message));
    }

    return ResHandler(
        status: ok, statusCode: response.statusCode, message: message ?? response.statusMessage, data: data, body: responseData, path: path);
  }
}

// last update : 2023-02-17, Ashta
