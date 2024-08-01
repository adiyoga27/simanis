import 'package:fetchly/fetchly.dart' as f;
import 'package:fetchly/models/request.dart';
import 'package:lazyui/lazyui.dart' hide Request;
import 'package:simanis/app/core/app_config.dart';

class RequestHandler {
  static onRequest(Request request) async {
    int status = request.status;

    if (![200, 201, 422, 401].contains(status)) {
      final device = await Utils.getDevice();
      String message =
          request.log.toString().replaceAll('-- ', '').replaceAll('== ', '');
      message =
          '<b>Error Info</b>\n$message\n<b>Device Info</b>\n${device.value}';

      Bot.sendMessage(message, AppConfig.botToken, AppConfig.botChatId);
    }
  }

  static void setToken(String token) {
    f.dio.setToken(token);
  }
}
