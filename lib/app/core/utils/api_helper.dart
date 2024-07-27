import 'package:dio/dio.dart';
import 'package:lazyui/lazyui.dart' hide Response;
import 'package:simanis/app/data/repository/api/api.dart';
import 'package:simanis/app/data/services/storage/storage.dart';

class Fetch {
  // FOR REQUEST TESTING ONLY
  // Use this site to generate response with status code that you want:
  // http://httpstat.us
  // http://google.com:81 (timeout)

  static Future<Response> get(String url, {Map<String, dynamic>? queryParameters, Options? options, Function(int, int)? onReceiveProgress}) async {
    Stopwatch stopWatch = Stopwatch();
    Response response = Response(requestOptions: RequestOptions(path: ''));

    await storage.remove(url);

    try {
      stopWatch.start();
      response = await dio.get(url, queryParameters: queryParameters, options: options, onReceiveProgress: onReceiveProgress);
    } catch (e, s) {
      Errors.check(e, s, networkError: NetworkError(path: url));
    }

    stopWatch.stop();
    await storage.write(url, stopWatch.elapsed.inMilliseconds);
    return response;
  }

  static Future<Response> post(String url, {dynamic data, Options? options}) async {
    Stopwatch stopWatch = Stopwatch();
    Response? response;

    await Storage.remove(only: [url]);

    try {
      stopWatch.start();
      response = await dio.post(url, data: data, options: options);
    } catch (e, s) {
      Errors.check(e, s, networkError: NetworkError(path: url));
    }

    stopWatch.stop();
    await storage.write(url, stopWatch.elapsed.inMilliseconds);
    return response!;
  }

  static Future<Response> put(String url, {dynamic data}) async {
    Stopwatch stopWatch = Stopwatch();
    Response response = Response(requestOptions: RequestOptions(path: ''));

    await Storage.remove(only: [url]);

    try {
      stopWatch.start();
      response = await dio.put(url, data: data);
    } catch (e, s) {
      Errors.check(e, s, networkError: NetworkError(path: url));
    }

    stopWatch.stop();
    await storage.write(url, stopWatch.elapsed.inMilliseconds);
    return response;
  }

  static Future delete(String url) async {
    Stopwatch stopWatch = Stopwatch();
    Response response = Response(requestOptions: RequestOptions(path: ''));

    await Storage.remove(only: [url]);

    try {
      stopWatch.start();
      response = await dio.delete(url);
    } catch (e, s) {
      Errors.check(e, s, networkError: NetworkError(path: url));
    }

    stopWatch.stop();
    await storage.write(url, stopWatch.elapsed.inMilliseconds);
    return response;
  }
}
